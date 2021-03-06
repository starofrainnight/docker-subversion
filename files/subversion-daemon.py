# -*- coding: utf-8 -*-

import os
import time
import subprocess

# Subversion Server Daemon
#
# Use for check if the server alive, restart if it's dead.
#
# This script just fix an unknow reason lead apache without any response after
# a long run.
print("Starting Subversion Server Daemon ...")

# Wait one minute before doing our check (wait the server startup)
time.sleep(60)

is_ssl_enabled = bool(os.environ.get("SVN_SSL_ENABLED", 0))
if is_ssl_enabled:
    test_url = "https://127.0.0.1"
else:
    test_url = "http://127.0.0.1"

while True:
    time.sleep(10)

    print("Check if server down ...")

    ret = subprocess.call(
        r"wget --timeout=3 --tries=1 %s -qO- > /dev/null" % test_url,
        shell=True)
    # If wget connect failed, it will return 4 .
    # If wget got 404 result, it will return 8 (but it's correct result !)
    if ret == 4:
        print("Server down, restarting apache ...")
        subprocess.call("apachectl restart", shell=True)
    else:
        print("Server alive!")
