# Dataiku dss multi node docker-compose

This stack includes the following dataiku services
* design node (default)
* automation node
* apideployer node
* api node
* dkumonitor: Graphite/Grafana stack (optional)

Added Features:
* Add custom docker image based on official dataiku/dss image
* Add custom debian docker image based on official dataiku requirements
* Add DSS_INSTALL_ARGS variables in docker entrypoint (run.sh) to configure:
  + install node type (-t option for installer.sh)
  + INSTALL_SIZE per services (big, medium, small)
  + license path per services
* auto register dss nodes in dkumonitor
* install python pip requirements for offline install at runtime (python3.6)
* install jdbc verticat driver

Sources:
* [official docker image dataiku/dss](https://github.com/dataiku/dataiku-tools/tree/master/dss-docker)
* [requirements for debian](https://doc.dataiku.com/dss/latest/installation/custom/initial-install.html#debian-ubuntu-linux-distributions)
* [dkumonitor](https://github.com/dataiku/dkumonitor)

Versions (from `Makefile.mk`):
| Image | Version | Comment | 
| --- | --- | --- |
| dataiku/dss | 8.0.2  | official docker dss is 8.0.2, but last software is 8.0.7 or 9.0.2 |
| dkumonitor| 0.0.5  | |
| jdbc vertica | 10.1.1-0 | |
| jdbc mysql | 8.0.24 | |

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
   - following ports below doesn t need to be exposed
   - 27603 (carbon_carbonserver_port)
   - 27604 (carbon_pickle_port)
   - 27605 (carbon_protobuf_port)
   - 27606 (carbon_http_port)
   - 27607 (carbon_link_port)
   - 27608 (carbon_grpc_port)
   - 27609 (carbon_tags_port)
 * docker version:
   - dataiku/dss:8.0.2
   - official dataiku archive is 8.0.7 and 9.0.2

# Usage

* (opt) create `artifacts` to override default `Makefile.mk` value (ex: COMPOSE_PROJECT_NAME, DESIGN_PORT,...)
* (opt) create `docker-compose-custom.yml` to override default value (ex: license path file) (see sample)

## Prereq: Build custom dss image
Image are  prefixed with `COMPOSE_PROJECT_NAME`_dataiku_dss
2 options:
* step build a custom docker image based on official dataiku/dss image.
* step build a custom docker image based debian and official dataiku requirements

| Description |  command |
| --- | --- |
| build a centos derivated based on official docker dataiku/dss | `make build` |
| build a debian customized dataiku/dss | `make build-debian` |
| build dkumonitor | `make build-dkumonitor` |

## start all services (design,automation,api,apideployer,dkumonitor)
| Description |  command |
| --- | --- |
| start all nodes | `make up` |
| stop all nodes | `make down` |

## start only one service
| Description |  command |
| --- | --- |
| start design node | `make up-design` |
| stop design node | `make down-design` |
| start automation node | `make up-automation` |
| stop automation node | `make down-automation` |
| start apideployer node | `make up-apideployer` |
| stop apideployer node | `make down-apideployer` |
| start api node | `make up-api` |
| stop api node | `make down-api` |
| start dkumonitor node | `make up-dkumonitor` |
| stop dkumonitor node | `make down-dkumonitor` |

## test service is running
| Description |  command |
| --- | --- |
| test all services | `make test-all` |
| test only one service (ex: design) | `make test-design` |

## Warning: to clean/erase data dir
| Description |  command |
| --- | --- |
| clean/erase all data services | `make clean-data-dir` |
| clean/erase only one data service (ex: design)| `make clean-data-dir-design` |
