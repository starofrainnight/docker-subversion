FROM ubuntu:14.04
MAINTAINER Hong-She Liang <starofrainnight@gmail.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    subversion \
    libapache2-svn \
    apache2-mpm-prefork \
    && apt-get clean

RUN a2enmod dav_svn
RUN a2enmod auth_digest
RUN a2enmod authz_svn
RUN a2dissite 000-default
# Clear files at /var/www, avoid display anything at that directory.
RUN rm -rf /var/www/*

RUN mkdir -p /var/lib/svn
RUN mkdir /etc/apache2/dav_svn

ADD files/dav_svn.conf /etc/apache2/mods-available/dav_svn.conf
ADD files/entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/*.sh

VOLUME /var/lib/svn
VOLUME /etc/apache2/dav_svn

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
