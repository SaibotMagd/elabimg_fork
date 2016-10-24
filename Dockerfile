# elabftw in docker, without sql
FROM alpine:edge
MAINTAINER Nicolas CARPi <nicolas.carpi@curie.fr>

# select version or branch here
ENV ELABFTW_VERSION 1.3.1

# install nginx and php-fpm
RUN apk add --update openjdk8-jre nginx openssl php7 php7-openssl php7-pdo_mysql php7-fpm php7-gd php7-curl php7-zip php7-zlib php7-json php7-gettext php7-session php7-mbstring git supervisor && rm -rf /var/cache/apk/*

# get latest stable version of elabftw
RUN git clone --depth 1 -b $ELABFTW_VERSION https://github.com/elabftw/elabftw.git /elabftw && chown -R nginx:nginx /elabftw && chmod -R u+x /elabftw

# only HTTPS
EXPOSE 443

# add files
COPY ./src/nginx/ /etc/nginx/
COPY ./src/supervisord.conf /etc/supervisord.conf
COPY ./src/run.sh /run.sh

# start
ENTRYPOINT exec /run.sh

# define mountable directories
VOLUME /elabftw/uploads
VOLUME /ssl
