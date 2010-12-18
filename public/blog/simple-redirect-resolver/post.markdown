Did you know that curl has an option to automatically follow HTTP redirects?
Combined with the HEAD method, this can be used to quickly trace the end
destination in a chain of redirecting URLs:

    #!/bin/sh
    (echo $1 && curl -LIs "$1" | grep '^Location' | cut -d' ' -f2) | cat -n

The meat of the work is in the curl options:

 * -L: if redirected, issue an identical request to the new location.
 * -I: issues a HEAD command, which allows the server to omit the body.
 * -s: no progress bar of failure indication
 
The subsequent grep/cut/cat combo serve to dice up the headers that are sent
back and turn them into a pretty list of redirect locations.
