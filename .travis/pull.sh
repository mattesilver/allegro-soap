#!/bin/bash

FILE=allegro-soap.xml
FILE_ORIG=allegro-soap.orig.xml
FILE_NEW=allegro-soap.new.xml

curl -o $FILE_ORIG 'https://webapi.allegro.pl/service.php?wsdl'
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo problem
  exit $EXIT_CODE
fi

xmllint --format $FILE_ORIG >$FILE_MEW

if [ -f $FILE ] && [ -z "$(diff $FILE_NEW $FILE)" ]; then
  export CHANGED=0
  echo no change
  rm $FILE_NEW
  exit
else
  export CHANGED=1
  mv $FILE_NEW $FILE
fi

NEW_VERSION=$(date "+%Y.%m.%d")
OLD_VERSION=$(cat VERSION | tr -d "\n")

if [ "$OLD_VERSION" ] && [ "$NEW_VERSION" = $OLD_VERSION ]; then
  # second run this day
  NEW_VERSION="$NEW_VERSION-1"
elif [ "$NEW_VERSION" = "${OLD_VERSION:0:10}" ]; then
  num=${OLD_VERSION:11:1}
  num=$(($num + 1))
  NEW_VERSION="${NEW_VERSION}-${num}"
fi

echo $OLD_VERSION '=>' $NEW_VERSION

echo $NEW_VERSION >VERSION
export VERSION=$NEW_VERSION
