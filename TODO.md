# TODO
* add dssadmin install options (install-R-integration, install-spark-integration ...)
* add event server
* add monitoring integration (graphite/graphan, collectd, dkumonitor)
* understand dssadmin build-base-image and build-container-exec-code-env-images 
* create user/group use dsscli command to create user/group, api key, bundle project.
* use api python to interact with dss node
* auto add api key from api node
* docker image based on debian (cf https://doc.dataiku.com/dss/latest/installation/custom/initial-install.html#debian-ubuntu-linux-distributions)
* include docker package to make DinD  worked
# Warnings
* postinstall at first container boot (try to make staff in build time not at run time)
* at runtime, environnement may not be connected to internet 
* reversrproxy and prefix path :(see notes about Data Science Studio does not currently support being remapped to a base URL with a non-empty path prefix (that is, to http://HOST:PORT/PREFIX/ where PREFIX is not empty  https://doc.dataiku.com/dss/latest/installation/custom/reverse-proxy.html#http-deployment-behind-a-nginx-reverse-proxy)   try traefik as reverse proxy in front of node 
* about logs, stored as files and not send as stream (https://doc.dataiku.com/dss/latest/installation/custom/advanced-customization.html#configuring-log-file-rotation)

# Interesting links
* https://towardsdatascience.com/mlops-w-dataiku-dss-on-kubernetes-505ee9a2e15a
