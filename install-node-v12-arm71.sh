#!/bin/bash


## script must be run as root
if [ "$(whoami)" != "root" ]
then
    echo "You do NOT have permission to run $0 as non-root user."
    exit 1
fi



mode=$1
if [ "$mode" != "gz" ] && [ "$mode" != "xz" ]
then
  echo "Invalid mode: $1 ($mode)"
  echo ""
  echo "Usage: $0 <mode>"
  echo "    mode = gz | xz"
  exit 1
fi 

echo "Using mode: $mode ($1)"
## install dir
mkdir install
cd install

version=node-v12.20.1-linux-armv7l
if [ "$mode" == "gz" ]
then
  ## tar.gz compression
  echo "Downloading \"$mode\" file"
  node_url=https://nodejs.org/dist/latest-v12.x
  src_file=${version}.tar.gz
  curl $node_url/$src_file -o $src_file
elif [ "$mode" == "xz" ]; then
  ## tar.zx compression
  echo "Downloading \"$mode\" file"
  node_url=https://nodejs.org/dist/latest-v12.x
  src_file=${version}.tar.xz
  curl $node_url/$src_file -o $src_file
fi

## inspect checksum
sum_check=SHASUMS256.txt
curl --silent  https://nodejs.org/dist/latest-v12.x/SHASUMS256.txt --stderr - | \
  grep $src_file > $sum_check

# check, exit on failure
if ! sha256sum --check $sum_check
then
  echo "Check sum failed. Script exiting as a security precaution."
  exit 2
fi

## unpack the src
tar -xf $src_file

## move node to destination
cp -R ${version}/* /usr/local/

## clean up install files
cd ..
rm -fr install

## verify install
node -v 
npm -v

