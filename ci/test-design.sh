#!/bin/bash
[ -n "$DEBUG" ] && set -x

TEST_NODE="${DESIGN_NODE:-localhost:10000}"

TEST_PATH="/public/api/internal-metrics"
TEST_URL="${TEST_NODE}${TEST_PATH}"
echo "# $(basename $0) $TEST_NODE"

curl -s -L -I -X GET -H "Content-Type: application/json" -L "${TEST_URL}" | grep "^DSS"
ret=$?
if [ "$ret" -gt 0 ] ; then
	echo "# $TEST_NODE error $ret"
	exit $ret
fi
echo "# $TEST_NODE success"
