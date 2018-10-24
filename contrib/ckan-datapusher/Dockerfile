FROM python:2.7

ENV DEBIAN_FRONTEND noninteractive

RUN pip install -U -q pip setuptools

RUN pip install -e git+https://github.com/ckan/datapusher.git#egg=datapusher
RUN pip install -r /src/datapusher/requirements.txt
RUN pip install gunicorn

ENV JOB_CONFIG /src/datapusher/deployment/datapusher_settings.py

EXPOSE 8800

CMD ["python", "/src/datapusher/datapusher/main.py", "/src/datapusher/deployment/datapusher_settings.py"]
