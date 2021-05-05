#!/bin/bash
[ -n "$DEBUG" ] && set -x

TEST_NODE="${API_NODE:-localhost:10003}"

# without license, backend api won't start. Test only unauthoried access
#TEST_PATH="/isAlive"
TEST_PATH="/"
TEST_URL="${TEST_NODE}${TEST_PATH}"
echo "# $(basename $0) $TEST_NODE"

curl -s -L -I -X GET -H "Content-Type: application/json" -L "${TEST_URL}" | grep "^HTTP/1.* 403"
ret=$?
if [ "$ret" -gt 0 ] ; then
	echo "# $TEST_NODE error $ret"
	exit $ret
fi
echo "# $TEST_NODE success"
