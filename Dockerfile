FROM debian:stable

RUN apt-get update && \
    apt-get -y install apt-utils && \
    apt-get -y install build-essential && \
    apt-get -y install automake && \
    apt-get -y install libev-dev && \
    apt-get -y install libssl-dev && \
    apt-get -y install curl && \
    apt-get -y install python-docutils && \
    apt-get clean && \
    cd /tmp  && \
    curl -sL https://github.com/varnish/hitch/archive/hitch-1.0.1.tar.gz | tar xz && \
    cd hitch-hitch-1.0.1/ && \
    ./bootstrap && \
    ./configure && \
    make && \
    make install && \
    groupadd -g 888 hitch && \
    useradd -M -d /var/lib/hitch -c "Hitch TLS proxy" -s /sbin/nologin -u 888 -g 888 hitch && \
    mkdir /usr/local/etc/hitch

#ADD config/certs/gontch-all.pem /usr/local/etc/hitch/combined.pem

#ADD start.sh /start.sh

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      64m
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600

#CMD /start.sh
#EXPOSE 443