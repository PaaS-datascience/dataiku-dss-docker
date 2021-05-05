#!/bin/bash
#
# test app
#
set -e
[ -n "$DEBUG" ] && set -x

basename=$(basename $0)
container_name=dkumonitor
APP=$COMPOSE_PROJECT_NAME
DC=docker-compose
echo "# $basename ${app} ${DSS_VERSION}"

ret=0

echo "# Test ${APP}-$container_name up"
set +e
timeout=120;
test_result=1
dirname=$(dirname $0)
until [ "$timeout" -le 0 -o "$test_result" -eq "0" ] ; do
	#${DC} ${DC_DSS_RUN_CONF} exec ${DC_USE_TTY} $container_name curl --retry-max-time 120 --retry-delay 1  --retry 1 --fail -s 127.0.0.1:27602/version | egrep '^[0-9'
	${DC} ${DC_DSS_RUN_CONF} exec ${DC_USE_TTY} $container_name /bin/bash -c 'set -x ; data/bin/dkm status'

	test_result=$?
	echo "Wait $timeout seconds: ${APP}-$container_name up $test_result";
	(( timeout-- ))
	sleep 1
done
if [ "$test_result" -gt "0" ] ; then
	ret=$test_result
	echo "ERROR: ${APP}-$container_name en erreur"
	exit $ret
fi

exit $ret

