##############################################
# WARNING : THIS FILE SHOULDN'T BE TOUCHED   #
#    FOR ENVIRONNEMENT CONFIGURATION         #
# CONFIGURABLE VARIABLES SHOULD BE OVERRIDED #
# IN THE 'artifacts' FILE, AS NOT COMMITTED  #
##############################################

# default values
include Makefile.mk

# override default values
dummy               := $(shell touch artifacts)
include ./artifacts

export

install-prerequisites:
ifeq ($(UNAME),Linux)
ifeq ("$(wildcard /usr/bin/docker)","")
	@echo install docker-ce, still to be tested
	sudo apt-get update ; \
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
	curl -fsSL https://download.docker.com/linux/${ID}/gpg | sudo apt-key add -
	sudo add-apt-repository \
                "deb https://download.docker.com/linux/ubuntu \
                `lsb_release -cs` \
                stable"
	sudo apt-get update
	sudo apt-get install -y docker-ce
	sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
endif
endif



# build custom dss image with custom args installer
build-all: build build-dkumonitor
build:
	docker-compose ${DC_DSS_BUILD_CONF} build --force-rm --no-cache build_dss
build-debian:
	docker-compose ${DC_DSS_BUILD_CONF} build --force-rm --no-cache build_dss_debian
build-dkumonitor:
	docker-compose ${DC_DSS_BUILD_CONF} build --force-rm --no-cache build_dkumonitor


# up/down
network:
	@docker network create ${COMPOSE_PROJECT_NAME} 2> /dev/null; true

# default start all services
up: up-all

up-all: pre-up
	docker-compose ${DC_DSS_RUN_CONF} up  --no-build -d

down:
	docker-compose ${DC_DSS_RUN_CONF} down

restart: down up

restart-%: down-% up-%
	echo "# $* restarted"

#
# create data dir if not exist/ clean data dir if exist
#
pre-up: pre-up-design pre-up-automation pre-up-api pre-up-apideployer pre-up-dkumonitor

pre-up-design: create-data-dir-design
	echo "# pre up design"
create-data-dir-design:
	if [ ! -d "${DESIGN_DATA_DIR}" ] ; then mkdir -p ${DESIGN_DATA_DIR} ; chown ${ID_U}:${ID_G} ${DESIGN_DATA_DIR} ; fi
clean-data-dir-design:
	if [ -d "${DESIGN_DATA_DIR}" ] ; then rm -rf ${DESIGN_DATA_DIR} ; fi

pre-up-automation: create-data-dir-automation
	echo "# pre up automation"
create-data-dir-automation:
	if [ ! -d "${AUTOMATION_DATA_DIR}" ] ; then mkdir -p ${AUTOMATION_DATA_DIR} ; chown ${ID_U}:${ID_G} ${AUTOMATION_DATA_DIR} ; fi
clean-data-dir-automation:
	if [ -d "${AUTOMATION_DATA_DIR}" ] ; then rm -rf ${AUTOMATION_DATA_DIR} ; fi

pre-up-api: create-data-dir-api
	echo "# pre up api"
create-data-dir-api:
	if [ ! -d "${API_DATA_DIR}" ] ; then mkdir -p ${API_DATA_DIR} ; chown ${ID_U}:${ID_G} ${API_DATA_DIR} ; fi
clean-data-dir-api:
	if [ -d "${API_DATA_DIR}" ] ; then rm -rf ${API_DATA_DIR} ; fi

pre-up-apideployer: create-data-dir-apideployer
	echo "# pre up apideployer"
create-data-dir-apideployer:
	if [ ! -d "${APIDEPLOYER_DATA_DIR}" ] ; then mkdir -p ${APIDEPLOYER_DATA_DIR} ; chown ${ID_U}:${ID_G} ${APIDEPLOYER_DATA_DIR} ; fi
clean-data-dir-apideployer:
	if [ -d "${APIDEPLOYER_DATA_DIR}" ] ; then rm -rf ${APIDEPLOYER_DATA_DIR} ; fi

pre-up-dkumonitor: create-data-dir-dkumonitor
	echo "# pre up dkumonitor"
create-data-dir-dkumonitor:
	if [ ! -d "${DKUMONITOR_DATADIR}" ] ; then mkdir -p ${DKUMONITOR_DATADIR} ; chown ${ID_U}:${ID_G} ${DKUMONITOR_DATADIR} ; fi
clean-data-dir-dkumonitor:
	if [ -d "${DKUMONITOR_DATADIR}" ] ; then rm -rf ${DKUMONITOR_DATADIR} ; fi

# clean data dir if exist
clean-data-dir: clean-data-dir-design clean-data-dir-automation clean-data-dir-api clean-data-dir-apideployer clean-data-dir-dkumonitor

#
# manage db mysql
#
pre-up-db-mysql: create-data-dir-db-mysql
	echo "# pre up mysql"
create-data-dir-db-mysql:
	if [ ! -d "${MYSQL_DATADIR}" ] ; then mkdir -p ${MYSQL_DATADIR} ; chown ${ID_U}:${ID_G} ${MYSQL_DATADIR} ; fi
clean-data-dir-db-mysql:
	if [ -d "${MYSQL_DATADIR}" ] ; then sudo rm -rf ${MYSQL_DATADIR} ; fi
up-db-%: | pre-up-db-%
	docker-compose ${DC_DSS_RUN_CONF_DB} up  --no-build -d $*
stop-db-%:
	docker-compose ${DC_DSS_RUN_CONF_DB} stop $*
rm-db-%:
	docker-compose ${DC_DSS_RUN_CONF_DB} rm -s -f $*
down-db-%: | stop-db-% rm-db-%
	@echo "# down $*"
restart-db-%: | down-db-% up-db-%
	@echo "# restart db $*"

#
# manage only one service (design,automation,api,apideployer)
#
config:
	docker-compose ${DC_DSS_RUN_CONF} config

up-%: | pre-up-%
	docker-compose ${DC_DSS_RUN_CONF} up  --no-build -d $*

stop-%:
	docker-compose ${DC_DSS_RUN_CONF} stop $*
rm-%:
	docker-compose ${DC_DSS_RUN_CONF} rm -s -f $*
down-%: | stop-% rm-%
	@echo "# down $*"
#
# test
#
test-all: test-design test-automation test-apideployer test-api test-dkumonitor
	@echo "# test all success"
test-%:
	@ci/test-$*.sh

test-up-%:
	@ci/test-up-$*.sh
