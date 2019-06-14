#!/bin/bash

echo " _____       _     _           _   _                                  ";
echo "/  ___|     (_)   | |         | | | |                                 ";
echo "\ \`--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___  ";
echo " \`--. \ '_ \| |/ _\` |/ _ \ '__| | | |/ _\` |/ __| | | | | | | '_ \` _ \ ";
echo "/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |";
echo "\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_|";
echo "      | |                                                             ";
echo "      |_|                                                             ";

echo -ne 'Dictionary file path: '
read dict

### If variable is empty or file doesn't exist
if [ -z "$dict" ]
then
        echo Missing dictionary! You must specify a dictionary of directories.
        exit 1
elif [ ! -f "$dict" ]
then
        echo File not found. Are you sure you typed the right path?
        exit 1
fi

echo -ne 'URL: '
read url

### If variable is empty
if [ -z "$url" ]
then
        echo Missing URL to scan!
        exit 1
fi

echo -ne 'Timeout: '
read tout

### If timeout is not specified, set the default of 3
if [ -z "$tout" ]
then
        echo -e 'Timeout not specified. Using the default 3 seconds'
        tout=3
fi

echo -ne 'Stealth: '
read stealth

if [ -z "$stealth" ]
then
        echo -e "Stealth not specified. Every packet will be sent ASAP"
        stealth=0
elif ! [ "$stealth" -eq "$stealth" ] 2>/dev/null
then
        echo -e "Value not valid. Write the seconds you want to wait for each request to be delivered"
        exit 1
fi

echo -e '\nScanning URL '"$url"' with dictionary located in '"$dict"'...'

for crawl in $(cat "$dict")
        do
                EXIT_CODE=$(curl -sL -w '%{http_code}' --connect-timeout $tout -o /dev/null $url/$crawl)
                if [[ $EXIT_CODE = 20* ]] || [[ $EXIT_CODE = 30* ]]
                then
                        echo -ne "\033[2K\u2713 $url/$crawl, HTTP $EXIT_CODE\n"
                else
                        echo -ne "\033[2K\u2610 $url/$crawl, HTTP $EXIT_CODE\r"
                fi
                sleep $stealth
        done
echo
