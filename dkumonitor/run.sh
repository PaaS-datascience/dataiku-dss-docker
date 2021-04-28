#!/bin/bash -e

DKUMONITOR_INSTALLDIR="/home/dataiku/dkumonitor-$DKUMONITOR_VERSION"

if [ ! -f "$DKUMONITOR_DATADIR"/bin/env-default.sh ]; then
	# Initialize new data directory
	"$DKUMONITOR_INSTALLDIR"/installer -d "$DKUMONITOR_DATADIR" -p "$DKUMONITOR_PORT"

elif [ $(bash -c 'source "$DKUMONITOR_DATADIR"/bin/env-default.sh && echo "$DKUINSTALLDIR"') != "$DKUMONITOR_INSTALLDIR" ]; then
	# Upgrade existing data directory
	"$DKUMONITOR_INSTALLDIR"/installer -d "$DKUMONITOR_DATADIR" -u -y
fi

exec "$DKUMONITOR_DATADIR"/bin/dkm run
