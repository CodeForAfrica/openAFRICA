FROM ubuntu:16.04
MAINTAINER Code for Africa

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
 && apt-get install -y python-dev \
                       python-pip \
                       build-essential \
                       libxslt1-dev \
                       libxml2-dev \
                       git \
                       libffi-dev
RUN pip install -e git+https://github.com/ckan/datapusher.git#egg=datapusher \
 && pip install gunicorn
RUN pip install -r /src/datapusher/requirements.txt

ENV JOB_CONFIG /src/datapusher/deployment/datapusher_settings.py

EXPOSE 8800

CMD ["python", "/src/datapusher/datapusher/main.py", "/src/datapusher/deployment/datapusher_settings.py"]
