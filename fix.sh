#!/bin/bash

allfiles=$(find Book -name "*.htm")

for afile in ${allfiles[@]}; do
   echo "$afile"
   sed -i 's/big5/UTF-8/g' "${afile}"
done