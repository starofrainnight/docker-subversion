#!/bin/bash

# Subversion Server Daemon
#
# Use for check if the server alive, restart if it's dead.
#
# This script just fix an unknow reason lead apache without any response after
# a long run.
echo "Starting Subversion Server Daemon ..."

# Wait one minute before doing our check (wait the server startup)
sleep 60

while true; do
    sleep 10
    echo "Check if server down ..."
    wget --timeout=3 --tries=1 http://127.0.0.1 -qO- > /dev/null
    # If wget connect failed, it will return 4 .
    # If wget got 404 result, it will return 8 (but it's correct result !)
    if [ "$?" -eq "4" ]
    then
        echo "Server down, restarting apache ..."
        apachectl restart
    else
        echo "Server alive!"
    fi
done
