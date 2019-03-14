#!/usr/bin/perl -w


# Copyright (c) 2019 Alan Gabriel Rosenkoetter
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

use strict;
use Cwd;
use File::Spec::Functions;
use File::Basename;
use File::Copy qw(copy);
use IO::Socket;
use Data::Dumper;

# XXX config or cli this
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
  chomp ($_);
  my ($user, $host, $port) = split /:/, $_;

  foreach my $enc_file (@enc_files)
  {
	  my $command = "$scp" 
      . (length($port) > 1 ? " -P $port" : " ")
      . " $enc_file"
      . (length($user) > 1 ? " $user@" : " ")
      . "$host:";
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
