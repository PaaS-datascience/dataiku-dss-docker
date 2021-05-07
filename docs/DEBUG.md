# Debug tips

## dkumonitor
* carbonapi
```
# carbonapi
curl -s 'http://127.0.0.1:27602/metrics/find?query=dss.*.*.*collectd.*&format=raw'

curl -s 'http://127.0.0.1:27602/render?target=dss.*.*.collectd.df.vda1.*.*&format=raw&from=-15min'
```
