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
chown -R www-data:www-data "/var/lib/svn/"

service apache2 start 

exec bash
