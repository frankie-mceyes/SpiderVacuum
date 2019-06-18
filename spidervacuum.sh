#!/bin/bash

echo " _____	   _	 _		   _   _";
echo "/  ___|	 (_)   | |		 | | | |";
echo "\ \`--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___  ";
echo " \`--. \ '_ \| |/ _\` |/ _ \ '__| | | |/ _\` |/ __| | | | | | | '_ \` _ \ ";
echo "/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |";
echo "\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_|";
echo "	  | |";
echo "	  |_|";
echo ""

echo -n 'Dictionary file path: '
read dict

if [ -z "$dict" ]															### If variable is empty or file doesn't exist
then
		echo 'Missing dictionary! You must specify a dictionary of directories.'
		exit 1
elif [ ! -f "$dict" ]
then
		echo 'File not found. Are you sure you typed the right path?'
		exit 1
elif grep -q ' ' $dict
then
		echo 'File contains spaces. URLs should not contain spaces. Please, check your dictionary.'				### If file contains spaces
		exit 1
fi

echo -n 'URL: '
read url

echo -ne '\tChecking if URL is alive... '
if [ -z "$url" ]															### If variable is empty
then
		echo 'Missing URL to scan!'
		exit 1
elif [[ "$(host $url > /dev/null 2>&1; echo $?)" != 0 ]]										### If exit code of host command to URL is not 0, means that URL is unreachable
then
		echo 'URL non reachable, aborting.'
		exit 1
else
		echo -ne 'OK\n'
fi

echo -n 'Timeout: '
read tout

if [ -z "$tout" ]															### If timeout is not specified, set the default of 3
then
		echo -e '\tTimeout not specified. Using the default 3 seconds.'
		tout=3
elif ! [ "$tout" -eq "$tout" ] 2>/dev/null												### If value inserted is an integer number
then
		echo -e "Value not valid. Write the seconds you want to wait for a response."
		exit 1
fi

echo -n 'Stealth: '
read stealth

	if [ -z "$stealth" ]														### If stealth delay is not specified
then
		echo -e "\tStealth not specified. Every packet will be sent ASAP."
		stealth=0
elif ! [ "$stealth" -eq "$stealth" ] 2>/dev/null											### If value inserted is an integer number
then
		echo -e "Value not valid. Write the seconds you want to wait for each request to be delivered."
		exit 1
fi

		countdown=$(wc -l $dict | awk '{print$1}')										### Initialize total count of pending URL
count=1																	### Initialize counter for URL countdown

echo -e '\nScanning URL '"$url"' with dictionary located in '"$dict"'. Total URLs pending: '"$countdown"

for crawl in $(cat "$dict")
		do
				EXIT_CODE=$(curl -sL -w '%{http_code}' --connect-timeout $tout -o /dev/null $url/$crawl)		### Just a check of the HTTP return code
				### The following codes are the 200-299 (success), the 300-399 (redirect) and specific 400-499 codes that, even if they are theorically errors, mean that the resource we are looking for does exist in the server
				if [[ $EXIT_CODE = 20* ]] || [[ $EXIT_CODE = 30* ]] || [[ $EXIT_CODE = 401 ]] || [[ $EXIT_CODE = 403 ]] || [[ $EXIT_CODE = 407 ]] || [[ $EXIT_CODE = 407 ]] || [[ $EXIT_CODE = 423 ]] || [[ $EXIT_CODE = 451 ]]
				then
						echo -ne "\033[2K\u2713 $url/$crawl, HTTP $EXIT_CODE; URL $count of $countdown\n"
				else
						echo -ne "\033[2K\u2610 $url/$crawl, HTTP $EXIT_CODE; URL $count of $countdown\r"
				fi
				sleep $stealth
				count=$((count+1))
		done
echo


### For any clarification about HTTP return codes, check here:
###	 https://thevirusdoublezero.tk/codici-http/
