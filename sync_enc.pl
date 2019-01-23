#!/usr/bin/perl -w

use strict;
use Cwd;
use File::Spec::Functions;
use File::Basename;
use File::Copy qw(copy);
use IO::Socket;
use Data::Dumper;

# XXX config or cli this
# XXX username, dumbass! (for now in sync_hosts)
my $file_check_regex = '^passwd';
my $encrypted_suffix_regex = '(gpg|pgp|asc)$';
my $encrypted_suffix_actual = 'gpg';
my $recipient = 'you@your.domain';

my $cwd = getcwd();

my $sync_hosts_file = catfile($cwd, 'sync_hosts');

STDIN->autoflush(1);
sub get_yes ($);

my (@clear_files, @enc_files);
opendir(my $cwd_handle, $cwd);

print "All matched clear-text files:\n";
foreach my $line (sort grep { /$file_check_regex/ } readdir $cwd_handle)
{
  my $file = catfile($cwd, $line);
  chomp $file;

  unless ($file =~ m/\.$encrypted_suffix_regex/)
  {
    push @clear_files, $file;
    print "$file\n";
  }
}

foreach my $clear_file (@clear_files)
{
  if (get_yes "\nEncrypt $clear_file?")
  {
		my $old_enc_file = "${clear_file}.$encrypted_suffix_actual";
		# XXX it'd be better to use the regex here too, but I
		# don't want to rewinddir yet and... bleh
		if (-f $old_enc_file)
		{
			my $bak_enc_dir = dirname(${clear_file});
			my $bak_enc_file = "bak." . basename(${clear_file}) .
				"." . $encrypted_suffix_actual;
			my $bak_enc_path = "${bak_enc_dir}/$bak_enc_file";
			print "Preserving $old_enc_file as $bak_enc_path\n";
			copy($old_enc_file, $bak_enc_path)
				or die "Copy failed: $!";
		}

    my $command = "gpg -e -v --yes -r $recipient $clear_file";
    print "--> $command\n";
    system $command;
  }

  if (get_yes "\nDelete $clear_file?")
  {
    if (unlink $clear_file)
    {
      print "Removed $clear_file\n";
    }
    else
    {
      warn "Could not remove file $!";
    }
  }
  else
  {
    print "Leaving unencrypted file $clear_file!\n"
  }
}

my $enc_file_regex = "$file_check_regex\.$encrypted_suffix_regex";


rewinddir $cwd_handle;

print "\nAll matched encrypted files:\n";
foreach my $line (sort grep { /$enc_file_regex/ } readdir $cwd_handle)
{
  my $file = catfile($cwd, $line);
  chomp $file;

  push @enc_files, $file;
  print "$file\n";
}
print "\n";

closedir $cwd_handle;
	
my $scp;
if ($^O =~ m/^mswin/i)
{
  $scp = "pscp";
}
else
{
  $scp = "scp";
}

print "Synchronizing:\n";

open(my $sync_hosts, $sync_hosts_file);

while (<$sync_hosts>)
{
  my $host = $_;
  chomp ($host);

  foreach my $enc_file (@enc_files)
  {
	  my $command = "$scp $enc_file $host:";
	  print "--> $command\n";
	  system $command;
  }
}

close $sync_hosts;

sub get_yes ($)
{
  my $prompt = shift;

  my $response; undef $response;

  while (not (defined($response) && ($response =~ m/(^$|^y|^n)/i)))
  {
    print "$prompt\n[y]/n> ";
    $response = <STDIN>;
  }

  if ($response =~ m/^n/)
  {
    return 0;
  }
  else
  {
    return 1;
  }
}
