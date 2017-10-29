FROM ubuntu:16.04
MAINTAINER Code for Africa <support@codeforafrica.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update 
RUN apt-get -qq dist-upgrade -y
RUN apt-get -qq install -y python-dev libpq-dev python-pip \
                       git-core

RUN pip install -q --upgrade pip && pip install -q --upgrade setuptools

RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.4#egg=ckan'
RUN pip install -r /src/ckan/requirements.txt
