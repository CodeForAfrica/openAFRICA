FROM python:2.7

ENV DEBIAN_FRONTEND noninteractive

ARG CKAN_VERSION=2.8.3

RUN pip install -U -q pip setuptools

RUN pip install -q -e "git+https://github.com/ckan/ckan.git@ckan-${CKAN_VERSION}#egg=ckan"

ADD meta.py /src/ckan/ckan/model/meta.py

RUN pip install -q -r /src/ckan/requirements.txt
RUN pip install -q vdm==0.15 sqlalchemy==1.2.19
