#!/bin/sh

# build
apk --update add build-base
apk add libev
apk add libev-dev
apk add automake
apk add openssl
apk add openssl-dev
apk add bash
apk add autoconf
apk add curl
apk add byacc
apk add flex
cd /tmp
curl -L https://api.github.com/repos/varnish/hitch/tarball/hitch-1.2.0 | tar xz
cd varnish-hitch*
./bootstrap
./configure --with-rst2man=/bin/true

# install
make
make install
mkdir /etc/ssl/hitch
adduser -h /var/lib/hitch -s /sbin/nologin -u 1000 -D hitch

# cleanup
cd /
rm -rf /tmp/*
apk del git build-base libev-dev automake autoconf openssl-dev flex byacc 
rm -rf /var/cache/apk/*
