#!/bin/bash

random-string()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}

for i in {1..10000}
do
    key=$(random-string)
    email=$(echo "$(random-string)"@example.com)
    echo $key,$email >> keys.csv
done