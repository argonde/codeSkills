#!/bin/bash
# Name - findDuplicates.sh
# Purpose - Find any duplicate file names through a directory path,
#           and report the amount of copies


if [ "$#" -gt 0 ]
then
  MATCH=$1
  shift
fi

# create text inventory files, containing all files in their directory
# then concatenate these files into a single text file

find . -type d \( ! -name . \) -exec bash -c ' dirname=$(basename "{}") &&
  cd "{}" && ls >> foundFiles.txt &&
  sed "/^found/d" foundFiles.txt' \; >> ffiles.txt

# count the amount of unique files found

echo
echo 'Results : #copies - fileName '
echo
sort ffiles.txt | uniq -c | awk '$1 > 1' | awk '/^ +*/{print $1, $2}' | \
  grep ".*$MATCH$" | tee duploFiles.txt 

# check on status for debugging

echo
STATE=${PIPESTATUS[@]}
echo -n 'Pipe Status:  ' && ( "$STATE" &> /dev/null | tr ' ' '+'; echo 0 ) | bc

if [ "$?" -ne 0 ]
then
  echo 'Detailed pipe status {sort|count|dupl|print|filter|out}:' $STATE
  exit 1
fi
echo

# clean up process and exit

find ./ -name foundFil* -exec rm -rf {} \; && rm -f ffiles.txt

exit 0
