#!/bin/bash 

domain=$1
mkdir /root/$1
mkdir /root/$1/xray

subfinder -d $1 -silent | anew /root/$1/subs.txt
assetfinder -subs-only $1 | anew /root/$1/subs.txt
amass enum -passive -d $1 | anew /root/$1/subs.txt
                                                                                                                                                                                                             
                                                                                                                                                                                                             
                                                                                                                                                                                                             
cat /root/$1/subs.txt | httpx -silent | anew /root/$1/alive.txt              
                                                                                                                                                                                                                                                                                                                                                                                                                      

## Test by Xray 

for i in $(cat /root/$1/alive.txt); do ./xray_linux_amd64 ws --basic-crawler $i --plugins xss,sqldet,xxe,ssrf,cmd-injection,path-traversal --ho $(date +"%T").html ; done 
  

## test for nuclei 

cat /root/$1/alive.txt | nuclei -t /root/cent/cent-nuclei-templates -es info,unknown -etags ssl,network | anew /root/$1/nuclei.txt

## scan ffuf

ffuf -c -w /root/$1/alive.txt:FUZZ1 -w /root/mywordlist/common.txt:FUZZ2 -u FUZZ1/FUZZ2 -mc 200 -ac -v -of html -o /root/$1/ffuf.html
