#!/bin/bash
# Name - synchDirectories.sh
# Purpose - Update files that have been modified or added recently,
#           to mirror a directory to its backup or to keep a second dir.

SYNCH='cp -Ruvp'

clear

if [ "$#" -ne 2 ]
then
  # make sure the use introduces two and only two directories to synchronise
  printf "Error: input syntax.\nYou are using the script: %s\n\n" ${0//*\//}
  printf "Use: $0 [dir1] [dir2]\n\n"
  exit 1

elif [ ! -d "$1" ] || [ ! -d "$2" ]
then
  # prompt to validate the user input, this will disallow auto-creation
  printf "Error: insufficient input. Make sure either directory exist:\n
  $1\n
  $2\n
  Or check whether their path is correct.\n\nUsage: $0 [dir1] [dir2]\n\n"
  exit 1

else
  DIR1=${1%/}
  DIR2=${2%/}
  shift 2
fi

# Pass the command to execute the update or creation of files:
echo 
echo "synchronising $DIR1/ to $DIR2/ in progress:"
echo && $SYNCH $DIR1/. $DIR2/

# Loop through the directories and check for deleted files:
for i in $(find $DIR2 \( ! -wholename $DIR2 \)); do
  if [ -d "$i" ]; then
    DNAME=${i##*/} && ls -R ${DIR1}/* | grep -q $DNAME &>/dev/null &&
    cd $i/ && continue
    # otherwise remove the directory
    printf "removing --> %s\n" "$i"
    rm -rf "$i"

  else
    FNAME=${i##*/} && ls -R ${DIR1}/* | grep -q $FNAME &>/dev/null && continue
    # otherwise remove the file
    printf "removing --> %s\n" "$i"
    rm -f "$i"
  fi
done
echo

echo Done! && echo
exit 0
