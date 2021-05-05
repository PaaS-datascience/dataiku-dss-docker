# Dataiku dss multi node docker-compose

This stack includes the following dataiku services
* design node (default)
* automation node
* apideployer node
* api node
* dkumonitor: Graphite/Grafana stack (optional)

Added Features:
* Add DSS_INSTALL_ARGS variables in docker entrypoint (run.sh) to configure:
  + install node type (-t option for installer.sh)
  + INSTALL_SIZE per services (big, medium, small)
  + license path per services
  + register dss node in dkumonitor

Sources:
* [official docker image dataiku/dss](https://github.com/dataiku/dataiku-tools/tree/master/dss-docker)
* [requirements for debian](https://doc.dataiku.com/dss/latest/installation/custom/initial-install.html#debian-ubuntu-linux-distributions)
* [dkumonitor](https://github.com/dataiku/dkumonitor)


Notes:
 * api node need specific license
 * dataiku services are running on following port (You can override it in artifacts file)
   - 10000 (design)
   - 10001 (automation)
   - 10002 (apideployer)
   - 10003 (api)
 * dkumonitor services are running on following ports:
   - 27600 (graphana) # UI
   - 27601 (carbon tcp/udp) # DSS monitoring integration port / API nodes QPS for API Deployer
   - 27602 (carbonapi_http) # APIdeployer monitoring
   - 27603 (carbon_carbonserver_port)
   - 27604 (carbon_pickle_port)
   - 27605 (carbon_protobuf_port)
   - 27606 (carbon_http_port)
   - 27607 (carbon_link_port)
   - 27608 (carbon_grpc_port)
   - 27609 (carbon_tags_port)

# Usage

* (opt) create docker-compose-custom.yml to override default value (ex: license) (see sample)
* (opt) create artifacts to override default Makefile value (ex: project_name, design port,...)

## Prereq: Build custom dss image
This step build a custom docker image for dataiku prefixed with `COMPOSE_PROJECT_NAME`_dataiku_dss

```bash
make build
```

## start all services (design,automation,api,apideployer)
```bash
make up
make down
```

## start only one service
* start design node
```bash
make up-design
make down-design
```
* start automation node
```bash
make up-automation
make down-automation
```
* start api node
```bash
make up-api
make down-api
```
* start apideployer node
```bash
make up-apideployer
make down-apideployer
```

## test service is running

```bash
make test-all
# or for one service
make test-design
```

## Warning: to clean data dir
```bash
# to clean one data dir
make clean-data-dir-design
```

```bash
# to clean all data dir
make clean-data-dir
```
