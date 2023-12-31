.ONESHELL:

build:
	# echo Building rekdoc ...
	source venv/bin/activate
	mkdir -p target/local > /dev/null 2>&1
	pip install pyinstaller pillow mysql.connector click python-docx python-dotenv
	pyinstaller --strip --clean -F src/rekdoc/core.py src/rekdoc/doc.py src/rekdoc/fetch.py src/rekdoc/const.py src/rekdoc/tools.py \
		--add-binary src/oswbba.jar:. \
		-n rekdoc --distpath target/local
	deactivate

build-debian:
	mkdir -p target/docker/debian > /dev/null 2>&1
	docker build -t rek3000/rekdoc:1.0-deb -f dockerfiles/debian.dockerfile .
	docker run --rm -it \
		--mount type=bind,source="$(PWD)/target/",target="/home/py/target" \
		--name rekdoc-gcc rek3000/rekdoc:1.0-deb /bin/bash -ci 'cp /usr/bin/rekdoc target/docker/debian/'

build-alpine:
	mkdir -p target/docker/alpine > /dev/null 2>&1
	docker build -t rek3000/rekdoc:1.0-alpine -f dockerfiles/alpine.dockerfile .
	docker run --rm -it \
		--mount type=bind,source="$(PWD)/target/",target="/home/py/target" \
		--name rekdoc-gcc rek3000/rekdoc:1.0-alpine /bin/bash -ci 'cp /usr/bin/rekdoc target/docker/alpine/'

build-alpine-glibc:
	mkdir -p target/docker/alpine-glibc > /dev/null 2>&1
	docker build -t rek3000/rekdoc:1.0-alpine-glibc -f dockerfiles/alpine-glibc.dockerfile .
	docker run --rm -it \
		--mount type=bind,source="$(PWD)/target/",target="/home/py/target" \
		--name rekdoc-gcc rek3000/rekdoc:1.0-alpine-glibc /bin/bash -ci 'cp /usr/bin/rekdoc target/docker/alpine-glibc/'

build-ol:
	mkdir -p target/docker/ol > /dev/null 2>&1
	docker build -t rek3000/rekdoc:1.0-ol -f dockerfiles/ol.dockerfile .
	docker run --rm -it \
		--mount type=bind,source="$(PWD)/target/",target="/home/py/target" \
		--name rekdoc-gcc rek3000/rekdoc:1.0-ol /bin/bash -ci 'cp /usr/bin/rekdoc target/docker/ol/'

run:
	docker run -it -v $(pwd)/sample:/home/py/sample/ --name rekdoc --rm rekdoc "$@"
	
init:
	python -m venv venv

# clean:
# 	rm -rf temp/*
# 	rm -rf output/*
# 	rm -f *.spec
purge-build: 
	rm -rf build 
	rm -rf *.egg-info
purge-target:
	rm -rf dist target
	rm -rf *.egg-info
purge-all: 
	rm -rf build dist target
	rm -rf *.egg-info
	rm -rf *.spec
tree:
	tree -I venv -I build -I dist -I __pycache__ -I *.egg-info -I test_env -I mysql-data 
 PHONY: build
