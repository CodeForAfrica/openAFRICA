FROM python:2.7

ENV DEBIAN_FRONTEND noninteractive

RUN pip install -U -q pip setuptools

RUN pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.6.7#egg=ckan'
RUN pip install -r /src/ckan/requirements.txt
