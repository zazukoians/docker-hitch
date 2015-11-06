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
apk add git
cd /tmp
git clone https://github.com/ktk/hitch.git
cd hitch/
./bootstrap
./configure
sed -i.bak 's/rst2man --halt=2/touch/g' Makefile

# install
make
make install
mkdir /etc/ssl/hitch
adduser -h /var/lib/hitch -s /sbin/nologin -u 999 -D hitch

# cleanup
cd /
rm -rf /tmp/hitch
apk del git build-base libev-dev automake autoconf openssl-dev
rm -rf /var/cache/apk/*