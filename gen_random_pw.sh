#!/bin/sh

BYTECOUNT=12
# base64 encodes 3 real bytes as 4 ASCII-printable bytes, so
# unless you feed openssl rand a multiple of 3, you'll get =
# padding at the end, which is kinda non-random in the ASCII
# representation

# XXX $PATH bizness
openssl rand -base64 $BYTECOUNT
