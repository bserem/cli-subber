#!/bin/bash
cwd=$(pwd)
echo $cwd;

for sub in "$cwd"/*.srt
do
  [ -e "$sub" ] || continue
  echo "$sub"
  subenc=$(enca -L none -i "$sub")
  if [ "$subenc" != "UTF-8" ]
  then
    echo "Changing encoding of subtitle"
    iconv -f CP1253 -t utf-8 -o tempsub "$sub"
    mv tempsub "$sub"
  else
    echo "This subtitle is properly encoded"
  fi
done
