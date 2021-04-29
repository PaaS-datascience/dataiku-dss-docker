#!/bin/bash -e

DKUMONITOR_INSTALLDIR="/home/dkumonitor/dkumonitor-$DKUMONITOR_VERSION"

if [ ! -f "$DKUMONITOR_DATADIR"/bin/env-default ]; then
	# Initialize new data directory
	"$DKUMONITOR_INSTALLDIR"/installer -d "$DKUMONITOR_DATADIR" -p "$DKUMONITOR_PORT" -t server
elif [ $(bash -c 'source "$DKUMONITOR_DATADIR"/bin/env-default && echo "$DKUINSTALLDIR"') != "$DKUMONITOR_INSTALLDIR" ]; then
	# Upgrade existing data directory
	"$DKUMONITOR_INSTALLDIR"/installer -d "$DKUMONITOR_DATADIR" -u
fi

exec "$DKUMONITOR_DATADIR"/bin/dkm run
