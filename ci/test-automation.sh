#!/bin/bash
TEST_NODE="${AUTOMATION_NODE:-localhost:10001}"

echo "# $(basename $0) $TEST_NODE"
curl -s -L -I -X GET -H "Content-Type: application/json" -L "$TEST_NODE/public/api/internal-metrics" | grep "^DSS"
ret=$?
if [ "$ret" -gt 0 ] ; then
	echo "# $TEST_NODE error $ret"
	exit $ret
fi
echo "# $TEST_NODE success"