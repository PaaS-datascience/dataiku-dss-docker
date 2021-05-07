#!/bin/bash -e
set -x

DSS_INSTALLDIR="/home/dataiku/dataiku-dss-$DSS_VERSION"
mkdir -p drivers/jdbc
# add vertica driver
if [ -n "$VERTICA_VERSION" ]; then
 ( cd drivers/jdbc
 curl -sLO https://www.vertica.com/client_drivers/10.1.x/${VERTICA_VERSION}/vertica-jdbc-${VERTICA_VERSION}.jar
 curl -sLO https://www.vertica.com/docs/Checksums/10.1.1/${VERTICA_VERSION}_sha1sum.txt
 grep vertica-jdbc-${VERTICA_VERSION}.jar ${VERTICA_VERSION}_sha1sum.txt | sha1sum -c
 ) || exit $?
fi
# add mysql driver
if [ -n "$MYSQL_VERSION" ]; then
 ( cd drivers/jdbc
 MYSQL_PKG=mysql-connector-java-${MYSQL_VERSION}
 curl -sOL https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_PKG}.tar.gz \
   && tar -zxvf $MYSQL_PKG.tar.gz $MYSQL_PKG/$MYSQL_PKG.jar \
   && mv  $MYSQL_PKG/$MYSQL_PKG.jar $MYSQL_PKG.jar \
   && rm -rf $MYSQL_PKG $MYSQL_PKG.tar.gz
 ) || exit $?
fi


# add python requirements
if [ -f "requirements.txt" -a -s "requirements.txt" ]; then
  [ -z "$PYPI_URL" ] || pip_args=" --index-url $PYPI_URL "
  [ -z "$PYPI_HOST" ] || pip_args="$pip_args --trusted-host $PYPI_HOST "
  echo "$no_proxy" |tr ',' '\n' | sort -u |grep "^$PYPI_HOST$" || \
    [ -z "$http_proxy" ] || pip_args="$pip_args --proxy $http_proxy "
    # extract pip python2.7 to download offline packages
    su - dataiku -c bash -c "$DSS_INSTALLDIR/installer.sh -d dss -p 10000"
    mkdir -p python
    dss/bin/pip download $pip_args -d python -r requirements.txt
    rm -rf dss
    mkdir dss && chown dataiku:dataiku dss
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
