FROM python:slim-buster as base
RUN apt update -y
RUN apt install python3-lxml libxslt-dev zlib1g-dev binutils libc-dev -y
RUN pip install --no-cache python-dotenv pyinstaller pillow python-docx mysql-connector-python click

RUN mkdir package
WORKDIR /package/
COPY rekdoc/ /package/rekdoc
RUN pyinstaller --clean \
    -F rekdoc/core.py rekdoc/doc.py rekdoc/fetch.py rekdoc/const.py rekdoc/tools.py \
    -n rd

FROM debian:buster-slim as final
COPY --from=base /package/dist/rd /usr/bin/rd
RUN useradd py -u 1000
USER py
WORKDIR /home/py
