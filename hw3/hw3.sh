#!/usr/bin/env bash

echo "find, $(man find |wc -l)" > hw3_bash.txt
echo "ls, $(man ls |wc -l)" >> hw3_bash.txt
echo "man, $(man man |wc -l)" >> hw3_bash.txt
sort -t, -g -k2 -r hw3_bash.txt > hw3_bash_sorted.txt
