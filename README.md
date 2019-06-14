A simple web crawler programmed in BASH.
It took me less than a morning to program this, just to test myself and commit another repo :P

This crawler works with the requests made by the CURL command, taking the HTTP response code and checking if a URL is valid or not.
That's all.

In order to use it:

```
$ ./spidervacuum.sh

 _____       _     _           _   _
/  ___|     (_)   | |         | | | |
\ `--. _ __  _  __| | ___ _ __| | | | __ _  ___ _   _ _   _ _ __ ___
 `--. \ '_ \| |/ _` |/ _ \ '__| | | |/ _` |/ __| | | | | | | '_ ` _ \
/\__/ / |_) | | (_| |  __/ |  \ \_/ / (_| | (__| |_| | |_| | | | | | |
\____/| .__/|_|\__,_|\___|_|   \___/ \__,_|\___|\__,_|\__,_|_| |_| |_|
      | |
      |_|

Dictionary file path: [where you saved the dictionary, relative path or absolute path]
URL: http://example.org
Timeout: [the timeout to set for each request. if not specified, it will be 3 seconds]
Stealth: [the seconds you want to wait between each request. if not specified, every request will be sent ASAP]

Scanning URL http://example.org with dictionary located in /home/user/WebScanDirectories.txt...

```

The rest is magic.
