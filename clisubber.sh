#!/bin/bash
DEFAULT_LANG="el"

if [ -z "$1" ]
  then SUBLANG_VAL=$DEFAULT_LANG
  else SUBLANG_VAL=$1
fi

echo "Language is set to $SUBLANG_VAL"

cwd=$(pwd)
for vid in "$cwd"/*.mkv "$cwd"/*.mp4 "$cwd"/*.avi;
do
  [ -e "$vid" ] || continue
  subdownloader -ci -l $SUBLANG_VAL --rename-subs --video="$vid"
done

for sub in "$cwd"/*.srt "$cwd"/*.sub;
do
  [ -e "$sub" ] || continue
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
