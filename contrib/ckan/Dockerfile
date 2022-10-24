FROM python:2.7

ENV DEBIAN_FRONTEND noninteractive

ARG CKAN_VERSION=2.8.3

RUN pip install -U -q pip setuptools

RUN pip install -q -e "git+https://github.com/ckan/ckan.git@ckan-${CKAN_VERSION}#egg=ckan"
# replace SQLAlchemy 1.1.11 with 1.2.19 in requirements.txt
RUN sed -i 's/vdm==0.14/vdm==0.15/' /src/ckan/requirements.txt
RUN sed -i 's/SQLAlchemy==1.1.11/SQLAlchemy==1.2.19/' /src/ckan/requirements.txt
RUN pip install -q -r /src/ckan/requirements.txt
