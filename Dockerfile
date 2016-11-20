FROM ubuntu:14.04
MAINTAINER Hong-She Liang <starofrainnight@gmail.com>

ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    subversion \
    supervisor \
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

ADD files/update_dav_svn_conf.py /usr/local/bin/
ADD files/apache2.conf /etc/supervisor/conf.d/apache2.conf
ADD files/entrypoint.sh /usr/local/bin/

RUN chmod a+x /usr/local/bin/*.sh

VOLUME /var/lib/svn
VOLUME /etc/apache2/dav_svn

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
