FROM alpine as wsdd2-build

WORKDIR /usr/src
RUN apk add binutils gcc make build-base readline-dev openssl-dev ncurses-dev make gnu-libiconv zlib-dev musl-dev linux-headers git && \
    git clone https://github.com/Netgear/wsdd2.git && \
    cd wsdd2 && \
    make

# --------------------------------------

FROM alpine

RUN apk add samba
COPY --from=wsdd2-build /usr/src/wsdd2/wsdd2 /usr/sbin
COPY smb_run.sh /usr/sbin
COPY smb.conf /etc/samba

RUN chmod +x /usr/sbin/smb_run.sh

ENV MACHINE_NAME=SERVER \
    WORKGROUP=WORKGROUP \
    USER_NAME=user \
    USER_PASSWORD=password \
    PUID=1000

EXPOSE 445/tcp 5335/tcp 5335/udp

ENTRYPOINT ["sh", "-c", "/usr/sbin/smb_run.sh"]
