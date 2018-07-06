#!/bin/bash

if [ ! -f /etc/apache2/dav_svn/authz ]
then
    echo "Generating empty authz file"
    cat <<EOF > /etc/apache2/dav_svn/authz
EOF
fi

if [ ! -f /etc/apache2/dav_svn/htpasswd ]
then
    echo "Generating empty htpasswd file for svn users"
    echo "# no users in this htpasswd file" > /etc/apache2/dav_svn/htpasswd
fi

# Fix dir/files authorities
chown -R www-data:www-data "/etc/apache2/dav_svn/"
chown -R www-data:www-data "/var/lib/svn/"

# Generate dav_svn.conf
python /usr/local/bin/update_dav_svn_conf.py

# Run subversion daemon
python /usr/local/bin/subversion-daemon.py &

# Run at foreground sometimes will exit with result 0 and said :
# "httpd (pid 14) already running"
#
# So we just restart at the beginning and use tail to ensure docker keep
# running.
apachectl restart

tail -f /dev/null
