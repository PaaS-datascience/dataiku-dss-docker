# TODO
* add dssadmin install options (install-R-integration, install-spark-integration ...)
* add event server
* add monitoring integration (graphite/graphan, collectd, dkumonitor)
* understand dssadmin build-base-image and build-container-exec-code-env-images 
* create user/group use dsscli command to create user/group, api key, bundle project.
* use api python to interact with dss node
* auto add api key from api node
* warnings: postinstall at first container boot (try to make thnign in build time not a t run time)
* warnings: at runtime, env may not be connected to net 
* warnings: reversrproxy and prefix path :(see notes about Data Science Studio does not currently support being remapped to a base URL with a non-empty path prefix (that is, to http://HOST:PORT/PREFIX/ where PREFIX is not empty  https://doc.dataiku.com/dss/latest/installation/custom/reverse-proxy.html#http-deployment-behind-a-nginx-reverse-proxy)   try traefik as reverse proxy in front of node 
* warnings: about logs, stored as files and not send as stream (https://doc.dataiku.com/dss/latest/installation/custom/advanced-customization.html#configuring-log-file-rotation)
