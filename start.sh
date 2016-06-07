#!/bin/bash

set -e

# check if we have a PEM file or it's two components, otherwise generate a self-signed one
if [[ -f $HITCH_KEY && -f $HITCH_CERT ]] && [[ ! ( -z $HITCH_PEM && -f $HITCH_PEM) ]]; then
  HITCH_PEM=/etc/ssl/hitch/combined.pem
  touch $HITCH_PEM
  chmod 440 $HITCH_PEM
  cat $HITCH_KEY $HITCH_CERT > $HITCH_PEM
  echo Combined $HITCH_KEY and $HITCH_CERT
elif [ -f $HITCH_PEM ]; then
  echo Using $HITCH_PEM
else
  # check if $DOMAIN is set, otherwise set to example.com
  if [ -z $DOMAIN ]; then
      export DOMAIN="example.com"
  fi  

  echo "Couldn't find PEM file, creating one for domain $DOMAIN"
  cd /etc/ssl/hitch
  openssl req -newkey rsa:2048 -sha256 -keyout example.com.key -nodes -x509 -days 365 -out example.crt -subj "/C=CH/ST=Zurich/L=Zurich/O=Snakeoil Inc/OU=IT Department/CN=$DOMAIN"
  cat example.com.key example.crt > combined.pem
fi


exec bash -c \
  "exec /usr/local/sbin/hitch --user=hitch \
  $HITCH_PARAMS \
  --ciphers=$HITCH_CIPHER \
  $HITCH_PEM"
