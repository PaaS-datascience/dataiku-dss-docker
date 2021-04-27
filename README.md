# Dataiku dss multi node docker-compose

4 services:
* design (default)
* automation
* apideployer
* api

Features added:
* Add DSS_INSTALL_ARGS variables in docker entrypoint (run.sh) to configure:
  + install node type
  + INSTALL_SIZE per services (big, medium, small)
  + license path per services

Notes:
 * api node need specific license

# Usage

* (opt) create docker-compose-custom.yml to override default value (ex: license) (see sample)
* (opt) create artifacts to override default Makefile value (ex: project_name, design port,...)

## Prereq: Build custom dss image
```bash
make build
```


## start all services
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

## Warning: to clean data dir
```bash
# to clean one data dir
make clean-data-dir-design
```

```bash
# to clean all data dir
make clean-data-dir
```
