#!/bin/bash
set -e

#
# test http app
#
function test_app {
  echo "# Test $1 "
  set +e
  ret=0
  timeout=120;
  test_result=1
  until [ "$timeout" -le 0 -o "$test_result" -eq 0 ] ; do
      eval $1
      test_result=$?
      echo "Wait $timeout seconds: APP coming up ($test_result)";
      (( timeout-- ))
      sleep 1
  done
  if [ "$test_result" -gt 0 ] ; then
       ret=$test_result
       echo "ERROR: APP down"
       return $ret
  fi

  return $ret
}

echo "# $(basename $0) started"

echo "# prepare artifacts tests"
cat <<EOF > artifacts
COMPOSE_PROJECT_NAME=ci
EOF

echo "# clean env"
make down clean-data-dir

echo "# build image"
make build-all

echo "# up all services"
make up-design

sleep 10
echo "# test all services"
test_app "make test-design"

echo "# clean env"
make down clean-data-dir
