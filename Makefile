#
#   Makefile
#
.PHONY: all
-include Makefile.include
PROJECT_NAME=onkolos
VERSION := $(shell cat .version)
LAST_COMMIT_SHA := $(shell git log -1 --pretty=format:%h -- .)
EXPORT_VERSION := $(VERSION)
PACKAGE_NAME := $(shell basename "$(PWD)")
PYTHON := $(shell which python)
PIP := $(shell which pip)
PYV := $(shell $(PYTHON) -c "import sys;t='{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)")
AWS_CLI := $(shell which aws)
PROJECT_STORAGE := ${HOME}/${PROJECT_NAME}-storage
PACKAGE_STORAGE := ${HOME}/${PROJECT_NAME}-storage/${PACKAGE_NAME}


.DEFAULT_GOAL: help envs

help: ## help - display this help menu
	
	@printf "\n\033[33m%s:\033[1m\n" 'Choose available CLI commands run "$(PROJECT_NAME)"'
	@echo "======================================================"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[32m%-14s		\033[35;1m-- %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\033[33m%s\033[1m\n"
	@echo "======================================================"

envs: ## envs - display envs
	@echo "======================================================"
	@echo "PROJECT_NAME $(PROJECT_NAME)"
	@echo "LAST_COMMIT_SHA $(LAST_COMMIT_SHA)"
	@echo "EXPORT_VERSION $(EXPORT_VERSION)" 
	@echo "PACKAGE_NAME $(PACKAGE_NAME)"
	@echo "PYTHON $(PYTHON)"
	@echo "PIP $(PIP)"
	@echo "PYV $(PYV)"
	@echo "AWS_CLI $(AWS_CLI)"
	@echo "VERSION $(VERSION)"
	@echo "PROJECT_STORAGE $(PROJECT_STORAGE)"
	@echo "PACKAGE_STORAGE $(PACKAGE_STORAGE)"
	@echo "======================================================"
    
.PHONY: run-infra stop-all stop-all restart-all

run-infra: ## docker-compose up infrastructure container 
	@docker-compose -f docker-compose.infra.yml up> /dev/null

start-all: ## docker-compose start all 
	@docker-compose -f docker-compose.infra.yml -f docker-compose.prod.yml -f docker-compose.local.yml up -d> /dev/null

stop-all: ## docker-compose stop all 
	@docker-compose -f docker-compose.infra.yml -f docker-compose.prod.yml -f docker-compose.local.yml down> /dev/null

restart-all: ## docker-compose restart all 
	@docker-compose -f docker-compose.infra.yml -f docker-compose.prod.yml -f docker-compose.local.yml restart> /dev/null


.PHONY: clean-pyc clean-build clean-test clean

clean: clean-pyc clean-build clean-test clean-docs
	
clean-pyc: ## clean-pyc - remove Python file artifacts
	@echo "======================================================"
	@echo "clean-pyc - remove Python file artifacts in $(PACKAGE_NAME)"
	@echo "======================================================"
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-build: ## clean-build - remove build artifacts
	@echo "======================================================"
	@echo "clean-build - remove build artifacts in $(PACKAGE_NAME)"
	@echo "======================================================"
	rm -fr build/
	rm -fr dist/
	rm -fr **.egg-info/
	rm -fr .eggs/

clean-test: ## clean-test - remove test artifacts
	@echo "======================================================"
	@echo "clean-test - remove test artifacts in $(PACKAGE_NAME)"
	@echo "======================================================"
	rm -rf .tox/

clean-docs: ## clean-docs - remove documentation artifacts
	@echo "======================================================"
	@echo "clean-docs - remove documentation artifacts"
	@echo "======================================================"
	rm -rf docs/_build

test: clean-test ## test - run all unit tests located in the tests directory
	@echo "======================================================"
	@echo "test - run all unit tests located in the tests directory"
	@echo "======================================================"
	tox -- -s tests

dist: clean-build clean-pyc
ifdef VERSION
	sed -i 's%<version>.*</version>%<version>$(VERSION)</version>%' metainfo.xml
endif
	python setup.py sdist
	ls -l dist

docs: clean-docs
	$(MAKE) -C docs clean
	$(MAKE) -C docs html

open-docs:
	xdg-open docs/_build/html/index.html

list: ## Makefile target list
	@echo "======================================================"
	@echo Makefile target list
	@echo "======================================================"
	@cat Makefile | grep "^[a-z]" | awk '{print $$1}' | sed "s/://g" | sort