#!/bin/bash
DEFAULT_LANG="el"
while getopts ":i" opts;
do
  case ${opts} in
    i) echo "interactive on"
       INTERACTIVE_VAL="-i" ;;
    \?) echo "Invalid option: -$OPTARG" >&2 ;;
  esac
done

if [ -z "$1" ]
  then SUBLANG_VAL=$DEFAULT_LANG
  else SUBLANG_VAL=$1
fi

cwd=$(pwd)
for vid in "$cwd"/*.mkv "$cwd"/*.mp4 "$cwd"/*.avi;
do
  [ -e "$vid" ] || continue
  subdownloader -c $INTERACTIVE_VAL -l $SUBLANG_VAL --rename-subs --video="$vid"
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
