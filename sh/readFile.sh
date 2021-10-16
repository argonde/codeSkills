#!/bin/bash
# Name - readFile.sh
# Purpose - Improve the readability of files printed by line on terminal.

clear

LINE=

if [ ! -r "$1" ]; then
  echo "Cannot find file: \"$1\"" 1>&2
  echo -e "Syntax reminder: $0 [FILE] [y/n] \n" >&2
  exit 1

elif [ "$#" -eq 2 ] && [[ "$2" =~ (^[yn]$) ]]; then
  case "$2" in
  'y')
    nl -w2 -ba -s'> ' "$1"
    ;;
  'n')
    IFS=
      while read LINE
        do
          echo "$LINE"
        done <"$1"
    ;;
    esac

else
  echo -e "Syntax help: $0 [FILE] [y/n]\n" >&2
  exit 1
fi
echo

exit 0
