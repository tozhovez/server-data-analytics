
#
#   Makefile
#
PROJECT_NAME=onkolos

PACKAGE_NAME := $(shell basename "$(PWD)")
PROJECT_STORAGE := ${HOME}/${PROJECT_NAME}-storage
PACKAGE_STORAGE := ${HOME}/${PROJECT_NAME}-storage/${PACKAGE_NAME}


.DEFAULT_GOAL: help

help: ## help - display this help menu
	
	@printf "\n\033[33m%s:\033[1m\n" 'Choose available CLI commands run "$(PROJECT_NAME)"'
	@echo "======================================================"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[32m%-14s		\033[35;1m-- %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@printf "\033[33m%s\033[1m\n"
	@echo "======================================================"
	
    



.PHONY: clean-pyc clean-build clean-test clean

clean: clean-pyc clean-build clean-test clean-docs
	@echo ""
	@echo clean $(PACKAGE_NAME)
	@echo "======================================================"


clean-pyc: ## clean-pyc - remove Python file artifacts
	@echo "======================================================"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "======================================================"
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-build: ## clean-build - remove build artifacts
	@echo "======================================================"
	@echo "clean-build - remove build artifacts"
	@echo "======================================================"
	rm -fr build/
	rm -fr dist/
	rm -fr **.egg-info/
	rm -fr .eggs/

clean-test: ## clean-test - remove test artifacts
	@echo "======================================================"
	@echo "clean-test - remove test artifacts"
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