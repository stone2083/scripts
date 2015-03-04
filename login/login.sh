#!/bin/sh

base=$(dirname $0)
cnf="$base/hosts.cnf"

loop=0
gecho "============================================================="
while read line
do
    let loop=$loop+1
    gecho -en "$loop\t"
    gecho $line | gsed -r 's/\s+/\t\t/'
    hosts[loop]=$line
done < $cnf
gecho "============================================================="
gecho -n "selects:  "

read id
ssh $(echo ${hosts[$id]} | gawk '{print $1}')
