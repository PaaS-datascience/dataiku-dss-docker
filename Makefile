##############################################
# WARNING : THIS FILE SHOULDN'T BE TOUCHED   #
#    FOR ENVIRONNEMENT CONFIGURATION         #
# CONFIGURABLE VARIABLES SHOULD BE OVERRIDED #
# IN THE 'artifacts' FILE, AS NOT COMMITTED  #
##############################################

EDITOR=vim

export PORT=10000
export COMPOSE_PROJECT_NAME=latelier

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

	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
	sudo add-apt-repository \
   		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   		$(lsb_release -cs) \
   		stable"
   	sudo apt-get update
		sudo apt-get install -y docker-ce
endif

vertica:
ifeq ("$(wildcard data/lib/jdbc/vertica-jdbc-9.0.1-0.jar)","")
	@sudo cp jdbc/vertica-jdbc-9.0.1-0.jar data/lib/jdbc/
endif

network: 
	@docker network create latelier 2> /dev/null; true

down:
	docker-compose down

up: network 
	docker-compose -f docker-compose.yml -f docker-compose-custom.yml up -d

restart: down up
