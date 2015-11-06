FROM gliderlabs/alpine
MAINTAINER Adrian Gschwend <adrian.gschwend@zazuko.com>

ADD build.sh /tmp/build.sh
RUN sh /tmp/build.sh

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENV HITCH_PEM    /etc/ssl/hitch/combined.pem
ENV HITCH_PARAMS "--backend=[localhost]:80 --frontend=[*]:443"
ENV HITCH_CYPHER EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH

CMD /start.sh
EXPOSE 443
