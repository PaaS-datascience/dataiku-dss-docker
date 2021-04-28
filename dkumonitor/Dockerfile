FROM debian:buster
ENV DKUMONITOR_DATADIR="/home/dkumonitor/data" \
    DKUMONITOR_PORT=10000

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

RUN cd /home/dkumonitor \
    && latest_version=$(curl -s https://cdn.downloads.dataiku.com/latest_dkumonitor.json|jq -r '.version')  \
    && curl -O https://cdn.downloads.dataiku.com/public/dkumonitor/$latest_version/dkumonitor-$latest_version.tar.gz \
    && tar xf dkumonitor-$latest_version.tar.gz \
    && rm -rf dkumonitor-$latest_version.tar.gz

# Entry point
WORKDIR /home/dkumonitor
USER dkumonitor
EXPOSE $DKUMONITOR_PORT

COPY run.sh /home/dkumonitor/

EXPOSE $DKUMONITOR_PORT

# TODO: fix dku version 
CMD [ "/home/dkumonitor/run.sh" ]
