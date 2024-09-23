FROM alpine:3.20 as build

ARG SOFTETHER_VER=v4.42-9798
ARG SOFTETHER_REL=rtm
ARG SOFTETHER_DATE=2023.06.30
ARG SOFTETHER_ARCHIVE=softether-src-$SOFTETHER_VER-$SOFTETHER_REL.tar.gz
ARG INSTALL_DIR=/opt/softethervpn

WORKDIR /tmp

ADD https://www.softether-download.com/files/softether/$SOFTETHER_VER-$SOFTETHER_REL-$SOFTETHER_DATE-tree/Source_Code/$SOFTETHER_ARCHIVE /tmp/
RUN tar -xf $SOFTETHER_ARCHIVE -C ./

RUN apk update \
    && apk upgrade \
    && apk add binutils gcc make build-base readline-dev openssl-dev ncurses-dev make gnu-libiconv zlib-dev musl-dev

RUN cd $SOFTETHER_VER \
    && mkdir -p $INSTALL_DIR \
    && ./configure \
    && make \
    && make INSTALL_VPNSERVER_DIR=$INSTALL_DIR/ INSTALL_VPNCMD_DIR=$INSTALL_DIR/ \
       INSTALL_BIN_DIR=$INSTALL_DIR/ INSTALL_VPNBRIDGE_DIR=$INSTALL_DIR/ INSTALL_VPNCLIENT_DIR=$INSTALL_DIR/ install

WORKDIR /opt
RUN tar -czf softethervpn.tar.gz softethervpn

# --------------------------------------

FROM alpine:3.20

ARG CONFIG_DIR=/etc/softethervpn
ARG INSTALL_DIR=/opt/softethervpn
ARG LOG_DIR=/var/log/softethervpn

WORKDIR /opt
COPY --from=build /opt/softethervpn.tar.gz .
RUN apk update \
    && apk upgrade \
    && apk add ca-certificates readline gnu-libiconv zlib dhclient
RUN tar -xf softethervpn.tar.gz \
    && rm softethervpn.tar.gz \
    && mkdir -p $CONFIG_DIR \
    && touch $CONFIG_DIR/vpn_client.config && ln -sf $CONFIG_DIR/vpn_client.config $INSTALL_DIR/vpn_client.config \
    && touch $CONFIG_DIR/vpn_server.config && ln -sf $CONFIG_DIR/vpn_server.config $INSTALL_DIR/vpn_server.config \
    && touch $CONFIG_DIR/vpn_bridge.config && ln -sf $CONFIG_DIR/vpn_bridge.config $INSTALL_DIR/vpn_bridge.config \
    && mkdir -p $LOG_DIR/packet_log && ln -sf $LOG_DIR/packet_log $INSTALL_DIR/packet_log \
    && mkdir -p $LOG_DIR/security_log && ln -sf $LOG_DIR/security_log $INSTALL_DIR/security_log \
    && mkdir -p $LOG_DIR/client_log && ln -sf $LOG_DIR/client_log $INSTALL_DIR/client_log \
    && mkdir -p $LOG_DIR/server_log && ln -sf $LOG_DIR/server_log $INSTALL_DIR/server_log \
    && mkdir -p $LOG_DIR/bridge_log && ln -sf $LOG_DIR/bridge_log $INSTALL_DIR/bridge_log

WORKDIR $INSTALL_DIR
VOLUME $CONFIG_DIR $LOG_DIR

EXPOSE 500/udp 1194/tcp 1194/udp 1701/udp 4500/udp 5555/tcp

CMD ["/opt/softethervpn/vpnserver", "execsvc"]
