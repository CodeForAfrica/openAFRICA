FROM openafrica/ckan:2.6.7

EXPOSE 5000/tcp

WORKDIR /

ADD requirements.txt /requirements.txt
RUN pip install -q -r /requirements.txt && \
    pip install -q -r /src/ckanext-s3filestore/requirements.txt && \
    pip install -q -r /src/ckanext-harvest/pip-requirements.txt && \
    pip install -q -r /src/ckanext-dcat/requirements.txt

# RUN ln -s ./src/ckan/ckan/config/who.ini /who.ini
ADD ckan.ini /ckan.ini

ADD Procfile /Procfile

CMD ["gunicorn", "--workers", "2", "--worker-class", "gevent", "--paste", "ckan.ini", "-t", "600"]
