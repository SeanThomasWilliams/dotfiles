#!/bin/bash -eux

exec 3<>/dev/tcp/www.google.com/80

sed >&3 "s/$/\r\n/" <<< "GET / HTTP/1.1
Host: http://www.google.com
Connection: close

"
echo -e "" >&3
cat <&3
