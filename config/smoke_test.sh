#!/bin/bash

if [[ `curl -sL -w "%{http_code}\n" "localhost" -o /dev/null` != "200" ]];
then
    exit 1
fi;

exit 0
