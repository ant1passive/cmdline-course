#! /bin/bash

cat $1 |
tr 'A-Z' 'a-z' |
tr -s '[:space:]' '\n' |
tr -d '[:punct:]' |
sort | 
uniq -c | 
sort -nr > $2
