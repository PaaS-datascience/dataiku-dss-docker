#!/bin/bash -e
set -x
echo "# run $(basename $0)"

if [ -n "$VERTICA_VERSION" ]; then
 cp drivers/jdbc/vertica-jdbc-${VERTICA_VERSION}.jar  $DSS_DATADIR/lib/jdbc/
fi

# works with python3.3
if [ -f requirements.txt -a -s requirements.txt -a -d "python" ]; then $DSS_DATADIR/bin/pip install --find-links python -r requirements.txt ; fi
# 
