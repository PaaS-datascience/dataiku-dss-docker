# TODO
* dkumonitor: fix dashboard monitoring in graphana
* dss: add python requirements at buildtime
* dss: add optionnal db driver and service (vertica,mongo,mysql,postgresql,elastic)
* dss: add dssadmin install options (install-R-integration, install-spark-integration ...)
* dss: add event server (audit)
* dss: understand dssadmin build-base-image and build-container-exec-code-env-images 
* dss: create user/group use dsscli command to create user/group, api key, bundle project.
* dss: use api python to interact with dss node
* dss: auto add api key from api node
* dss: include docker package to make DinD  worked
* dss: add sample mini flow test
* db add sample docker db (vertica/postgresql/mysql/mongo/elastic)

# Done
* add compose with 4 services
* add docker image based on debian (cf https://doc.dataiku.com/dss/latest/installation/custom/initial-install.html#debian-ubuntu-linux-distributions)
* add minimal ci test for sandbox
* add dkumonitor: monitoring integration (graphite/graphana, collectd, dkumonitor)
* dss: add optionnal db driver and service (vertica,mongo,mysql,postgresql,elastic)

# Warnings
* postinstall at first container boot (try to make staff in build time not at run time)
* at runtime, environnement may not be connected to internet 
* reverseproxy and prefix path :(see notes about Data Science Studio does not currently support being remapped to a base URL with a non-empty path prefix (that is, to http://HOST:PORT/PREFIX/ where PREFIX is not empty  https://doc.dataiku.com/dss/latest/installation/custom/reverse-proxy.html#http-deployment-behind-a-nginx-reverse-proxy)   try traefik as reverse proxy in front of node 
* about logs, stored as files and not send as stream (https://doc.dataiku.com/dss/latest/installation/custom/advanced-customization.html#configuring-log-file-rotation)
# Interesting links
* https://towardsdatascience.com/mlops-w-dataiku-dss-on-kubernetes-505ee9a2e15a
