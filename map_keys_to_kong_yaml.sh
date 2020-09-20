#!/bin/bash

while IFS=',' read -ra line; do
  echo -e "- username: ${line[1]}\n  keyauth_credentials:\n  - key: ${line[0]}" >> consumers.yml
done < keys.csv