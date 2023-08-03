FROM codeforafrica/ckan:2.9.0

EXPOSE 5000/tcp

WORKDIR /

ADD requirements.txt /requirements.txt
RUN pip install -q -r /requirements.txt && \
    pip install -q -r /src/ckanext-s3filestore/requirements.txt && \
    pip install -q -r /src/ckanext-harvest/pip-requirements.txt && \
    pip install -q -r /src/ckanext-dcat/requirements.txt

ADD ckan.ini /ckan.ini

ADD wsgi.py /wsgi.py

ADD Procfile /Procfile

CMD ["gunicorn", "--workers", "3", "-b", ":5000", "wsgi.py", "-t", "600"]

