SHELL := /bin/bash

default:
	rm -rf build
	mkdir -p build
	./build-articles.bash
	cp -r lib build
	./build-nav.bash
	./resolve-path.bash
	
