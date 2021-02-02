#!/usr/bin/perl -w

# Copyright (c) 2021 Alan Gabriel Rosenkoetter
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

# XXX Yeah yeah yeah, Perl's rand() is almost definitely not
# cryptographically secure on any platform, let alone macOS, but
# we're generating 4 to 8 random digits betwen 0 and 9 (inclusive)
# here, so maybe worry about that later.

use strict;

# XXX This is lazy, but there won't be CLI parsing involved with
# this after incorporation into grapple proper, so whatever.
my $count;
if ($#ARGV > -1)
{
  $count = shift @ARGV;
}
else
{
  $count = 4;
}

if ((not ($count =~ /^\d$/)) or ($count < 4) or ($count > 8))
{
  print STDERR "Count argument needs to be ",
    "an integer between 4 and 8.\n";
  exit 1;
}

my $pin = "";

for (my $i = 0; $i < $count; $i++)
{
  $pin .= int(rand(10));
}

print $pin, "\n";
