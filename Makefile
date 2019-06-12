##############################################
# WARNING : THIS FILE SHOULDN'T BE TOUCHED   #
#    FOR ENVIRONNEMENT CONFIGURATION         #
# CONFIGURABLE VARIABLES SHOULD BE OVERRIDED #
# IN THE 'artifacts' FILE, AS NOT COMMITTED  #
##############################################

EDITOR=vim

include /etc/os-release

export PORT=10000
export COMPOSE_PROJECT_NAME=latelier
export COMPOSE=docker-compose -f docker-compose.yml -f docker-compose-custom.yml


dummy               := $(shell touch artifacts)
dummy               := $(shell touch docker-compose-custom.yml)
include ./artifacts

install-prerequisites:
ifeq ("$(wildcard /usr/bin/docker)","")
        @echo install docker-ce, still to be tested
        sudo apt-get update
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

vertica:
ifeq ("$(wildcard data/lib/jdbc/vertica-jdbc-9.0.1-0.jar)","")
	@sudo cp jdbc/vertica-jdbc-9.0.1-0.jar data/lib/jdbc/
endif

network: 
	@docker network create latelier 2> /dev/null; true

requirements: up
	docker exec -it dss /home/dataiku/dss/bin/pip install --proxy ${http_proxy} -r requirements.txt

up: network 
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

stop:
	$(COMPOSE) stop

restart: down up

clean: down
	sudo rm -rf data jdbc

logs:
	$(COMPOSE) logs --tail 50 -f dss

exec:
	$(COMPOSE) exec dss bash
