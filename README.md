# docker-subversion

## Volumes

To use this container, you should prepare these volumes:

### /etc/apache2/dav_svn

Contained 2 files:

    authz
        a authz file to control the access to your subversion repositories

    htpasswd
        a htpasswd file to manage the users for this subversion system

### /var/lib/svn

All svn data is stored in this volume

### /etc/apache2/ssl

Only check while environment variable "SVN_SSL_ENABLED" be set to "1".

There have openssl generated certificate files: `cert.pem` and `cert.key`.

## Start command

    docker run --restart=always -d -p 80:80 -v /root/docker-subversion/dav_svn:/etc/apache2/dav_svn -v /root/docker-subversion/svn:/var/lib/svn starofrainnight/subversion
