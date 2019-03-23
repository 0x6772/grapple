#!/bin/sh

# macOS-specific script to dismount (whatever really, but aimed at)
# removable, encrypted storage. The GUI works too, but I'm usually
# in a terminal when I'm using grapple.

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

# XXX put this in a config file, you monster
vols="list your vols here"
vol_base="/Volumes"

for vol in $vols
do
  vol_path="${vol_base}/${vol}"

  if [ -d "$vol_path" ]
  then
    cmd="diskutil unmount $vol_path"
    echo $cmd
    $cmd
    if [ $? -gt 0 ];
    then
      cmd="diskutil unmount force $vol_path"
      echo $cmd
      $cmd
    fi
  else
    echo "Skipping [$vol_path]: not mounted."
  fi
done
