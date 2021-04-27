# Dataiku dss multi node docker-compose

4 services:
* design (default)
* automation
* apideployer
* api

Features:
* Add DSS_INSTALL_ARGS to docker entrypoint to configure:
  + INSTALL_SIZE per services (big, medium, small)
  + license path per services

Notes:
 * api services need specific license

# Usage

* (opt) create docker-compose-custom.yml to override default value (ex: license)
* (opt) create artifacts to override default value (ex: design port,...)

## Prereq: Build custom dss image
```bash
make build
```


## start all services
```bash
make up
make down
```

## start only one services
```bash
make up-design
make down-design
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
