#!/bin/bash

# https://regex-golang.appspot.com/assets/html/index.html

export REPLACE_SCOPE="./statsd"
export REPLACE_MODE=-w # "-d"

gofmt -l $REPLACE_MODE -r '"datadog" -> "stackstate"' $REPLACE_SCOPE
find ./statsd -type f -exec sed -i '' -e 's/datadog\./stackstate\./g' {} \;
find ./statsd -type f -exec sed -i '' -e 's/github.com\/DataDog\/datadog-go/github.com\/StackVista\/stackstate-go/g' {} \;

UNAME="$(uname)"
if [[ $UNAME != MSYS* ]]; then
    echo "Checking replacements..."

    grep -r --include=*.go "\"DD_"  $PWD/../cmd $PWD/../config $PWD/../checks

    RESULT=$?
    if [ $RESULT -eq 0 ]; then
      echo "Please fix branding: there is still something using DD_ prefix"
      exit 1
    else
      echo "Branding was successful, return code $RESULT"
    fi
fi
