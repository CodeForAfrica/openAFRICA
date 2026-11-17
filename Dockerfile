FROM ckan/ckan-base:2.11.4

# https://github.com/ckan/ckan-docker/issues/196
USER root
RUN mkdir -p /srv/app/.local && chown ckan /srv/app/.local
USER ckan

ENV APP_DIR=/srv/app

### OpenAfrica ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-openafrica.git#egg=ckanext-openafrica

### Datarequests (CodeForAfrica fork) ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-datarequests.git#egg=ckanext-datarequests

### Harvester ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-harvest.git#egg=ckanext-harvest && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

### S3 Filestore (qld-gov-au fork — has CKAN 2.11 support) ###
# Pinned to 0.9.0 (what production runs). Later master moved to pyproject.toml
# and dropped requirements.txt, which breaks the -r line below.
RUN pip3 install -e git+https://github.com/qld-gov-au/ckanext-s3filestore.git@0.9.0#egg=ckanext-s3filestore && \
    pip3 install -r ${APP_DIR}/src/ckanext-s3filestore/requirements.txt

### Google Analytics ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-googleanalytics.git#egg=ckanext-googleanalytics && \
    pip3 install -r ${APP_DIR}/src/ckanext-googleanalytics/requirements.txt

### Showcase ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-showcase.git#egg=ckanext-showcase && \
    pip3 install -r ${APP_DIR}/src/ckanext-showcase/requirements.txt

# Copy custom initialization scripts
COPY contrib/ckan/docker-entrypoint.d/* /docker-entrypoint.d/
