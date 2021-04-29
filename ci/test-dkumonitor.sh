#!/bin/bash
TEST_NODE="${DKUMONITOR_NODE:-localhost:27600}"

TEST_PATH="/api/health"
# curl localhost:27602/version
TEST_URL="${TEST_NODE}${TEST_PATH}"
echo "# $(basename $0) $TEST_NODE"

curl -s -L -I -X GET -H "Content-Type: application/json" -L "${TEST_URL}" | jq -re '.version'
ret=$?
if [ "$ret" -gt 0 ] ; then
	echo "# $TEST_NODE error $ret"
	exit $ret
fi
echo "# $TEST_NODE success"
