#!/bin/bash -e
# Add DSS_INSTALLER_ARGS
sed -i -e 's/installer.sh/installer.sh $DSS_INSTALLER_ARGS /g' run.sh
# configure monitoring
sed -i -e '/dssadmin/a\
[ -n "$GRAPHITE_HOST" -a -n "$GRAPHITE_PORT" ] && $DSS_DATADIR/bin/dssadmin install-monitoring-integration -graphiteServer $GRAPHITE_HOST:$GRAPHITE_PORT
' run.sh
chown root. run.sh
