#!/bin/bash

#Method 1
echo "Method 1"
echo "--------"
cat urlfile | tr '[:upper:]' '[:lower:]' | cut -d '/' -f3 | sed 's/\.$//' | awk -F '.' '{print $(NF-1)"."$NF}' | sort | uniq

echo " "
#Method 2
echo "Method 2"
echo "--------"
cat urlfile | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' | sed 's/\.$//'| cut -d '/' -f3 | awk -F "[.]" '{print $(NF-1)"."$NF}'  | sort | uniq
