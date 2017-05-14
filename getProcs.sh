#!/bin/bash
grep "^[ \t]*Function" *.ipf | grep -oE '[ \t]+[A-Za-z_0-9]+\(' | tr -d " " | tr -d "(" > output
for i in `cat output`; do grep -ie "$i" *.ipf | grep -w "Function" >> funcfile.txt ; done
sed -i -e 's/.ipf:Function /  /g' funcfile.txt
