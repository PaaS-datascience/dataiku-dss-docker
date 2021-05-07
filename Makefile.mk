EDITOR=vim
SHELL = /bin/bash
UNAME = $(shell uname -s)

ifeq ($(UNAME),Linux)
include /etc/os-release
endif
ID_U = $(shell id -un)
ID_G = $(shell id -gn)
# enable trace in shell
DEBUG ?= 

#
# docker-compose options
#
DOCKER_USE_TTY := $(shell test -t 1 && echo "-t" )
DC_USE_TTY     := $(shell test -t 1 || echo "-T" )


# global docker prefix
COMPOSE_PROJECT_NAME ?= latelier

DC_DSS_DEFAULT_CONF ?= docker-compose.yml

DC_DSS_BUILD_CONF ?= -f docker-compose-build.yml
# detect custom docker-compose file
ifeq ("$(wildcard docker-compose-custom.yml)","")
DC_DSS_RUN_CONF ?= -f ${DC_DSS_DEFAULT_CONF}
else
DC_DSS_RUN_CONF ?= -f ${DC_DSS_DEFAULT_CONF} -f docker-compose-custom.yml
endif

#
# dss
#
DSS_VERSION ?= 8.0.2
DKUMONITOR_VERSION ?= 0.0.5
VERTICA_VERSION ?= 10.1.1-0
MYSQL_VERSION ?= 8.0.24

#
# NODETYPE=design automation api apideployer
# INSTALL_SIZE=auto big medium small
INSTALL_SIZE ?= auto
DSS_INSTALLER_ARGS ?= # -P python3.6 -l /home/dataiku/license.json
#
# design
#
DESIGN_NODETYPE           = design
DESIGN_DATA_DIR           ?= ./data-design
DESIGN_PORT               ?=10000
DESIGN_INSTALL_SIZE       ?= ${INSTALL_SIZE}
DESIGN_DSS_INSTALLER_ARGS ?= -t ${DESIGN_NODETYPE} ${DSS_INSTALLER_ARGS} -s ${DESIGN_INSTALL_SIZE}
DESIGN_NODE               ?= localhost:${DESIGN_PORT}
#
# automation
#
AUTOMATION_NODETYPE           = automation
AUTOMATION_DATA_DIR           ?= ./data-automation
AUTOMATION_PORT               ?= 10001
AUTOMATION_INSTALL_SIZE       ?= ${INSTALL_SIZE}
AUTOMATION_DSS_INSTALLER_ARGS ?= -t ${AUTOMATION_NODETYPE} ${DSS_INSTALLER_ARGS} -s ${AUTOMATION_INSTALL_SIZE}
AUTOMATION_NODE               ?= localhost:${AUTOMATION_PORT}
#
# apideployer
#
APIDEPLOYER_NODETYPE           = apideployer
APIDEPLOYER_DATA_DIR           ?= ./data-apideployer
APIDEPLOYER_PORT               ?= 10002
APIDEPLOYER_INSTALL_SIZE       ?= ${INSTALL_SIZE}
APIDEPLOYER_DSS_INSTALLER_ARGS ?= -t ${APIDEPLOYER_NODETYPE} ${DSS_INSTALLER_ARGS} -s ${APIDEPLOYER_INSTALL_SIZE}
APIDEPLOYER_NODE               ?= localhost:${APIDEPLOYER_PORT}
#
# api
#
API_NODETYPE           = api
API_DATA_DIR           ?= ./data-api
API_PORT               ?=10003
API_INSTALL_SIZE       ?= ${INSTALL_SIZE}
API_DSS_INSTALLER_ARGS ?= -t ${API_NODETYPE} ${DSS_INSTALLER_ARGS} -s ${API_INSTALL_SIZE}
API_NODE               ?= localhost:${API_PORT}
#
# dkumonitor
#
DKUMONITOR_DATADIR           ?= ./data-dkumonitor
DKUMONITOR_PORT   ?= 27600
DKUMONITOR_NODE               ?= localhost:${DKUMONITOR_PORT}

#
# mysql
#
MYSQL_DATADIR ?= ./data-db-mysql
MYSQL_PORT ?= 3306
MYSQL_NODE ?= localhost:${MYSQL_PORT}
MYSQL_ROOT_PASSWORD ?= changeme
MYSQL_USER ?= dssuser
MYSQL_PASSWORD ?= dsschangeme
MYSQL_DATABASE ?= dss

DC_DSS_DEFAULT_CONF_MYSQL ?= docker-compose-db-mysql.yml
DC_DSS_CUSTOM_CONF_MYSQL ?= docker-compose-custom-db-mysql.yml
DC_DSS_RUN_CONF_DB ?= -f ${DC_DSS_DEFAULT_CONF_MYSQL}
# detect custom db docker-compose file
ifeq ("$(wildcard ${DC_DSS_CUSTOM_CONF_MYSQL})","")
DC_DSS_RUN_CONF ?= -f ${DC_DSS_DEFAULT_CONF_MYSQL}
else
DC_DSS_RUN_CONF ?= -f ${DC_DSS_DEFAULT_CONF_MYSQL} -f ${DC_DSS_CUSTOM_CONF_MYSQL}
endif

