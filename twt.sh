#!/bin/sh
# twt - basic twtxt writing
twtxt="./twtxt.txt"
dt=$(date +%FT%T)
post=$(echo $@ | cut -c1-140)

echo $dt	$post > tmp.twtxt.txt
cat "$twtxt" >> tmp.twtxt.txt
mv tmp.twtxt.txt "$twtxt"
