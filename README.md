A simple web crawler programmed in BASH.
It took me less than a morning to program this, just because i needed this in a short time and test myself.
This crawler works with the requests made by the CURL command, taking the HTTP response code and checking if a URL is valid or not.
That's all.

```
$ ./spidervacuum.sh

 _____       _     _           _   _
/  ___|     (_)   | |         | | | |
\ `--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___
 `--. \ '_ \| |/ _` |/ _ \ '__| | | |/ _` |/ __| | | | | | | '_ ` _ \
/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |
\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_|  by Frankie McEyes
      | |
      |_|

```

### Features
* Check if a dictionary has spaces inside and abort if there are, coz URLs should not contain spaces
* Check if the requested URL is alive with `host` command, because some sites could block `ping` requests
* Can send packets through TOR network
* A customizable timeout
  * If the inserted timeout is less than 3 seconds and the TOR setting is enabled, there could be an abnormal amount of false negatives, due to the TOR network nature, so a warning message will be shown to confirm the inserted value 
* A stealth feature, which will wait for the amount of seconds specified between each request, to avoid IDS/flooding issues
  * If the TOR settings is enabled, there will be no stealth, due to the nature of the TOR network nature
* A countdown of pending URLs
* The spider just checks the HTTP status code of the web page, so there's no check on the **content** of the page

### Accepted HTTP status codes
* Every 200-299 code (Success)
* Every 300-399 code (Redirect)
* 401 (Unauthorized)
* 403 (Forbidden)
* 407 (Proxy Authentication required)
* 423 (Locked)
* 451 (Unavailable for legal reasons)

For any clarification about HTTP status code, you can check here: https://thevirusdoublezero.com/codici-http/

### Example of TOR crawl
```
$ ./spidervacuum.sh TOR
 _____       _     _           _   _
/  ___|     (_)   | |         | | | |
\ `--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___
 `--. \ '_ \| |/ _` |/ _ \ '__| | | |/ _` |/ __| | | | | | | '_ ` _ \
/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |
\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_| by Frankie McEyes
    | |
    |_|
Dictionary file path: /home/wordlist.txt
URL: thevirusdoublezero.com
        Checking if URL is alive... OK
Timeout: 2
        Warning! You choose to send the packets over the TOR protocol, but you typed a timeout of 2 seconds, which could cause timeouts too often due to the nature of the TOR network.
        Do you want to maintain this value? (N/y) y
TOR option enabled, bypassing stealth.


Scanning URL thevirusdoublezero.com with dictionary located in /home/wordlist.txt. Total URLs pending: 45563
Sending request through TOR network.
```

### Example of regular crawl
```
$ ./spidervacuum.sh
 _____       _     _           _   _
/  ___|     (_)   | |         | | | |
\ `--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___
 `--. \ '_ \| |/ _` |/ _ \ '__| | | |/ _` |/ __| | | | | | | '_ ` _ \
/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |
\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_| by Frankie McEyes
    | |
    |_|
Dictionary file path: /home/wordlist.txt
URL: thevirusdoublezero.com
        Checking if URL is alive... OK
Timeout:
        Timeout not specified. Using the default 3 seconds.
Stealth:
        Stealth not specified. Every packet will be sent ASAP.

Scanning URL thevirusdoublezero.com with dictionary located in /home/wordlist.txt. Total URLs pending: 45563
```
