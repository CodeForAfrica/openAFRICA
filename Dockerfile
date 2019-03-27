FROM openafrica/ckan:2.6.7

EXPOSE 5000/tcp

ADD requirements.txt /requirements.txt
RUN pip install -q -r /requirements.txt && \
    pip install -q -r /src/ckanext-s3filestore/requirements.txt && \
    pip install -q -r /src/ckanext-harvest/pip-requirements.txt && \
    pip install -q -r /src/ckanext-dcat/requirements.txt

# install supervisor
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    supervisor
COPY contrib/ckan_harvesting.conf /etc/supervisor/conf.d/ckan_harvesting.conf

# RUN ln -s ./src/ckan/ckan/config/who.ini /who.ini
ADD ckan.ini /ckan.ini

COPY ./contrib/entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["gunicorn", "--workers", "2", "--worker-class", "gevent", "--paste", "ckan.ini", "-t", "600"]
