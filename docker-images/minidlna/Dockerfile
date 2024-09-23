FROM alpine

RUN apk add minidlna

COPY minidlna_run.sh /usr/sbin
RUN chmod +x /usr/sbin/minidlna_run.sh

ENV FRIENDLY_NAME=Media\ Server

VOLUME /opt

EXPOSE 1900/udp 8200/tcp

ENTRYPOINT ["sh", "-c", "/usr/sbin/minidlna_run.sh"]
