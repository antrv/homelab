FROM alpine as wsdd2-build

WORKDIR /usr/src
RUN apk add binutils gcc make build-base readline-dev openssl-dev ncurses-dev make gnu-libiconv zlib-dev musl-dev linux-headers git && \
    git clone https://github.com/Netgear/wsdd2.git && \
    cd wsdd2 && \
    make

# --------------------------------------

FROM alpine

COPY --from=wsdd2-build /usr/src/wsdd2/wsdd2 /usr/sbin

ENV MACHINENAME=SERVER
ENV WORKGROUP=WORKGROUP

ENTRYPOINT ["sh", "-c", "/usr/sbin/wsdd2 -H $MACHINENAME -N $MACHINENAME -G $WORKGROUP"]
