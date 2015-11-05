FROM alpine

RUN apk --update add build-base && \
    apk add libev-dev && \
    apk add automake && \
    apk add openssl && \
    apk add bash && \
    apk add autoconf && \
    apk add openssl-dev && \
    apk add git && \
    cd /tmp && \
    git clone https://github.com/ktk/hitch.git && \
    cd hitch/ && \
    ./bootstrap && \
    ./configure && \
    sed -i.bak 's/rst2man --halt=2/touch/g' Makefile && \
    make && \
    make install && \
    mkdir /etc/ssl/hitch

#ADD config/certs/gontch-all.pem /etc/ssl/hitch/combined.pem

#ADD start.sh /start.sh

ENV HITCH_PEM      /etc/ssl/hitch/combined.pem
ENV HITCH_PARAMS "-p default_ttl=3600 -p default_grace=3600 --backend=[localhost]:80 --frontend=[*]:443"
ENV HITCH_CYPHER EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH

#CMD /start.sh
#EXPOSE 443
