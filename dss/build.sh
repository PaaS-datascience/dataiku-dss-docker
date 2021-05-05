#!/bin/bash -e
set -x

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"
# add vertica driver
mkdir -p drivers/jdbc
if [ -n "$VERTICA_VERSION" ]; then
 ( cd drivers/jdbc
 curl -sLO https://www.vertica.com/client_drivers/10.1.x/${VERTICA_VERSION}/vertica-jdbc-${VERTICA_VERSION}.jar
 curl -sLO https://www.vertica.com/docs/Checksums/10.1.1/${VERTICA_VERSION}_sha1sum.txt
 grep vertica-jdbc-${VERTICA_VERSION}.jar ${VERTICA_VERSION}_sha1sum.txt | sha1sum -c
 ) || exit $?
fi

# add python requirements
if [ -f "requirements.txt" -a -s "requirements.txt" ]; then
  [ -z "$PYPI_URL" ] || pip_args=" --index-url $PYPI_URL "
  [ -z "$PYPI_HOST" ] || pip_args="$pip_args --trusted-host $PYPI_HOST "
  echo "$no_proxy" |tr ',' '\n' | sort -u |grep "^$PYPI_HOST$" || \
    [ -z "$http_proxy" ] || pip_args="$pip_args --proxy $http_proxy "
    mkdir -p python
    python3 -m pip download $pip_args -d python -r requirements.txt
fi

# Add DSS_INSTALLER_ARGS
sed -i -e 's/installer.sh/installer.sh $DSS_INSTALLER_ARGS /g' run.sh
# configure monitoring
sed -i -e '/dssadmin/a\
[ -n "$GRAPHITE_HOST" -a -n "$GRAPHITE_PORT" ] && $DSS_DATADIR/bin/dssadmin install-monitoring-integration -graphiteServer $GRAPHITE_HOST:$GRAPHITE_PORT
' run.sh

# Add postinstall.sh at runtime
sed -i -e '/installer.sh/a\
if [ -f /home/dataiku/postinstall.sh ]; then /home/dataiku/postinstall.sh ; fi
' run.sh
chown root. run.sh
