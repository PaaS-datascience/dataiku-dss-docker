#!/bin/bash
[ -n "$DEBUG" ] && set -x

# test if dkumonitor (graphana) is up
ret=1
TEST_NODE="${DKUMONITOR_NODE:-localhost:27600}"
TEST_PATH="/api/health"
# curl localhost:27602/version
TEST_URL="${TEST_NODE}${TEST_PATH}"
echo "# $(basename $0) $TEST_URL"

curl -s -L -X GET -H "Content-Type: application/json" -L "${TEST_URL}" | jq -re '.version'
ret=$?
if [ "$ret" -gt 0 ] ; then
	echo "# ${TEST_URL} error $ret"
	exit $ret
fi
echo "# $TEST_URL success"

# test f dss register in dkumonitor (carbonapi)
ret=1
TEST_PORT=$((DKUMONITOR_PORT+2))
TEST_NODE="localhost:${TEST_PORT}"
#TEST_PATH="/metrics/find?query=dss.*&format=raw"
TEST_PATH="/version"
# curl localhost:27602/version
TEST_URL="${TEST_NODE}${TEST_PATH}"
echo "# $(basename $0) $TEST_URL"

#curl -s -L -X GET "${TEST_URL}" |grep "^dss.*"
curl -s -L -X GET "${TEST_URL}" |egrep "^[0-9]"
ret=$?

if [ "$ret" -gt 0 ] ; then
	echo "# ${TEST_URL} error $ret"
	exit $ret
fi
echo "# $TEST_URL success"
