FROM debian:buster
ARG dkumonitorVersion

ENV DKUMONITOR_VERSION="$dkumonitorVersion" \
    DKUMONITOR_DATADIR="/home/dkumonitor/data" \
    DKUMONITOR_PORT=27600

ARG MIRROR_DEBIAN
ARG DEBIAN_FRONTEND=noninteractive

RUN useradd dkumonitor \
    && mkdir -p /home/dkumonitor ${DKUMONITOR_DATADIR} \
    && chown -Rh dkumonitor:dkumonitor /home/dkumonitor ${DKUMONITOR_DATADIR}

RUN echo "$http_proxy $no_proxy" && set -x && [ -z "$MIRROR_DEBIAN" ] || \
    sed -i.orig -e "s|http://deb.debian.org/debian|$MIRROR_DEBIAN/debian10|g ; s|http://security.debian.org/debian-security|$MIRROR_DEBIAN/debian10-security|g" /etc/apt/sources.list ; cat /etc/apt/sources.list /etc/apt/sources.list.orig ; \
    apt-get -q update \
    && apt-get install -qy --no-install-recommends curl sudo \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        software-properties-common \
        jq \
        python2.7 \
    && rm -rf /var/lib/apt/lists/*

# latest_version=$(curl -s https://cdn.downloads.dataiku.com/latest_dkumonitor.json|jq -r '.version') 
RUN DKUMONITORKIT="dkumonitor-$DKUMONITOR_VERSION" \
    && cd /home/dkumonitor \
    && curl -O https://cdn.downloads.dataiku.com/public/dkumonitor/$DKUMONITOR_VERSION/$DKUMONITORKIT.tar.gz \
    && tar xf $DKUMONITORKIT.tar.gz \
    && rm -rf $DKUMONITORKIT.tar.gz \
    && echo "+ Fix supervisord in foreground" \
    && sed -i -e 's|\(exec python.*\)|\1 -n|g' $DKUMONITORKIT/bin/dkm \
    && chown -Rh dkumonitor:dkumonitor "$DKUMONITORKIT"

# Entry point
WORKDIR /home/dkumonitor
USER dkumonitor
COPY run.sh /home/dkumonitor/
EXPOSE $DKUMONITOR_PORT

# TODO: fix dku version 
CMD [ "/home/dkumonitor/run.sh" ]
