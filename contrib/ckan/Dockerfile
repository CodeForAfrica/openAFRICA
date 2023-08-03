FROM python:3.8

ENV DEBIAN_FRONTEND noninteractive

ARG CKAN_VERSION=2.9.0

RUN pip install -U -q pip "setuptools<46.0.0"

RUN pip install -q -e "git+https://github.com/ckan/ckan.git@ckan-${CKAN_VERSION}#egg=ckan"

RUN pip install -q -r /src/ckan/requirements.txt
RUN pip install -q vdm==0.15 sqlalchemy==1.2.19
