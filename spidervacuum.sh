#!/bin/bash

########################################################
# TODO
# [+] SpiderVacuum over TOR
# [+] Where possible, optimize requests and make everything work fast
# [ ] Use all files in a directory as dictionaries
# [+] If timeout is wrong, don't exit, make it change
# [ ] If stealth is wrong, don't exit, make it change
########################################################


if [[ "$1" = "tor" ]] || [[ "$1" = "TOR" ]]
then
        if torify --version > /dev/null 2>&1                                                                                            ### If Torify is not installed
        then
                checkTor=1                                                                                                              ### Set the TOR check variable to TRUE
        else
                echo "Torify not found... Cannot send packets through TOR if Torify is not installed."
                echo "You can install it with \"sudo apt install torify\""
                exit 1
        fi
else
        checkTor=0                                                                                                                      ### If TOR option is not specified
fi

cat << "EOF"
 _____       _     _           _   _
/  ___|     (_)   | |         | | | |
\ `--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___
 `--. \ '_ \| |/ _` |/ _ \ '__| | | |/ _` |/ __| | | | | | | '_ ` _ \
/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |
\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_| by Frankie McEyes
    | |
    |_|
EOF

echo -n "Dictionary file path: "
read dict

if [ -z "$dict" ]                                                                                                                       ### If path is not specified
then
        echo "Missing dictionary! You must specify a dictionary of directories."
        exit 1
elif [ ! -f "$dict" ]                                                                                                                   ### If file doesn't exist
then
        echo "File not found. Are you sure you typed the right path?"
        exit 1
elif grep -q ' ' $dict
then
        echo "File contains spaces. URLs should not contain spaces. Please, check your dictionary."                                     ### If file contains spaces
        exit 1
fi

echo -n 'URL: '
read url

if [ -z "$url" ]                                                                                                                        ### If variable is empty
then
        echo "Missing URL to scan!"
        exit 1
fi
echo -ne "\tChecking if URL is alive... "

if [ $checkTor -eq 1 ]                                                                                                                  ### If you choose TOR, also the URL check will be over TOR
then
        torify curl -sI -w '%{http_code}' "$url" > /dev/null                                                                            ### Just a simple and mute curl to the URL header. Why just the header? Is a lighter request
        checkUrl=$?                                                                                                                     ### Exit status code of the previous command. If it's 0, it succeded
else
        curl -sI -w '%{http_code}' "$url" > /dev/null
        checkUrl=$?
fi

if [ $checkUrl -eq 0 ]                                                                                                                  ### If a simple CURL to the URL fails, the URL is not valid
then
        echo -ne 'OK\n'
else
        echo "URL non reachable, aborting."
        exit 1
fi

while true                                                                                                                              ### Post conditional loop that repeats itself if user wants to change timeout
do
        echo -n 'Timeout: '
        read tout

        if [ -z "$tout" ]                                                                                                               ### If timeout is not specified, set the default of 3 seconds
        then
                echo -e "\tTimeout not specified. Using the default 3 seconds."
                tout=3
        elif ! [ "$tout" -eq "$tout" ] || [ $tout -lt 0  ] 2>/dev/null                                                                  ### If value inserted is not an integer number
        then
                echo -e "Value not valid. Write the seconds you want to wait for a response."
                exit 1
        fi

        if [ $tout -lt 3 ] && [ $checkTor -eq 1 ]                                                                                       ### If timeout is less than 3 seconds and TOR option is enabled
        then
                echo -e "\tWarning! You choose to send the packets over TOR, but you typed a timeout of $tout seconds, which could cause timeouts too often, due to the nature of the TOR network."
                echo -ne "\tDo you want to maintain this value? (N/y) "
                read prompt
                if [[ $prompt =~ ^[Yy]$ ]]                                                                                              ### If the user wants to continue, exit the loop
                then
                        break
                fi
        else
                break
        fi
done

if [ $checkTor -eq 0 ]                                                                                                                  ### If TOR is not checked, continues to ask for stealth value
then
        echo -n 'Stealth: '
        read stealth

        if [ -z "$stealth" ]                                                                                                            ### If stealth delay is not specified
        then
                        echo -e "\tStealth not specified. Every packet will be sent ASAP."
                        stealth=0
        elif ! [ "$stealth" -eq "$stealth" ] || [ $stealth -lt 0  ] 2>/dev/null                                                         ### If value inserted is an integer number
        then
                        echo -e "Value not valid. Write the seconds you want to wait for each request to be delivered."
                        exit 1
        fi
else
        echo -e "TOR option enabled, bypassing stealth.\n"
        stealth=0                                                                                                                       ### If TOR is enabled, bypass stealth setting the sleep amount to 0
fi

countdown=$(wc -l $dict | awk '{print$1}')                                                                                              ### Initialize total count of pending URLs
count=1                                                                                                                                 ### Initialize counter for URL countdown

echo -e "\nScanning URL $url with dictionary located in $dict. Total URLs pending: $countdown"
if [ $checkTor -eq 1 ]
then
        echo -e "Sending request through TOR network."                                                                                  ### Remembers the user that the requests will be made through TOR network
fi

for crawl in $(cat "$dict")
        do
                if [ "$checkTor" -eq 1 ]
                then
                        EXIT_CODE=$(torify curl -sI -w '%{http_code}' --connect-timeout $tout -o /dev/null $url/$crawl)                 ### Just a check of the HTTP return code, but with TOR protocol

                else
                        EXIT_CODE=$(curl -sI -w '%{http_code}' --connect-timeout $tout -o /dev/null $url/$crawl)                        ### Just a check of the HTTP return code
                fi

                ### The wanted codes are the 200-299 (success), the 300-399 (redirect) and specific 400-499 codes that, even if they are theorically errors, mean that the resource we are looking for does exist in the server
                if [[ $EXIT_CODE = 20* ]] || [[ $EXIT_CODE = 30* ]] || [[ $EXIT_CODE = 401 ]] || [[ $EXIT_CODE = 403 ]] || [[ $EXIT_CODE = 407 ]] || [[ $EXIT_CODE = 423 ]] || [[ $EXIT_CODE = 451 ]]
                then
                        echo -ne "\033[2K\u2713 $url/$crawl, HTTP $EXIT_CODE; URL $count of $countdown\n"                               ### If URL crawled returns a valid code, print the line, then start a new line
                else
                        echo -ne "\033[2K\u2610 $url/$crawl, HTTP $EXIT_CODE; URL $count of $countdown\r"                               ### If URL crawled does not exist, just delete the line, print the url and continue scanning
                fi
                sleep $stealth
                count=$((count+1))
        done
echo

### For any clarification about HTTP return codes, check here: https://thevirusdoublezero.tk/codici-http/
