#!/bin/bash
FOLDER_PATH=$1
REFERENCE_SIZE=$2
SIZE=$(/usr/bin/du -s $FOLDER_PATH  | /usr/bin/awk '{print $1}')
echo "$FOLDER_PATH  -  ${SIZE}kB"
if [[ $SIZE -gt $(( $REFERENCE_SIZE )) ]]; then exit 1;fi