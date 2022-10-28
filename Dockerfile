FROM alpine:3.16 as builder
ARG HITCH_VERSION=1.7.3

# dependencies
RUN apk --update add bash build-base libev libev-dev automake openssl openssl-dev autoconf curl byacc flex
# get & build
RUN cd /tmp && curl -sS -L https://hitch-tls.org/source/hitch-${HITCH_VERSION}.tar.gz | tar xz
RUN mkdir /build
RUN cd /tmp/hitch* && ./configure --with-rst2man=/bin/true --prefix=/build
RUN cd /tmp/hitch* && make && make install


FROM alpine:3.16
LABEL org.opencontainers.image.authors="Adrian Gschwend <adrian.gschwend@zazuko.com>"

# dependencies
RUN apk --update add bash libev openssl

# copy hitch files
COPY --from=builder /build /usr/local

RUN mkdir -p /etc/ssl/hitch
RUN adduser -h /var/lib/hitch -s /sbin/nologin -u 1000 -D hitch

ADD start.sh /start.sh

ENV HITCH_PEM    /etc/ssl/hitch/combined.pem
ENV HITCH_PARAMS "--backend=[localhost]:80 --frontend=[*]:443"
ENV HITCH_CIPHER EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH

CMD /start.sh
EXPOSE 443
