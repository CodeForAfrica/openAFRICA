FROM ckan/ckan-base:2.10.8-py3.10
# Install any extensions needed by your CKAN instance
# - Make sure to add the plugins to CKAN__PLUGINS in the .env file
# - Also make sure all provide all extra configuration options, either by:
#   * Adding them to the .env file (check the ckanext-envvars syntax for env vars), or
#   * Adding extra configuration scripts to /docker-entrypoint.d folder) to update
#      the CKAN config file (ckan.ini) with the `ckan config-tool` command
#
# See README > Extending the base images for more details
#

# https://github.com/ckan/ckan-docker/issues/196
USER root
RUN mkdir /srv/app/.local && chown ckan /srv/app/.local
USER ckan

### OpenAfrica ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-openafrica.git#egg=ckanext-openafrica

### Datarequests
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-datarequests.git#egg=ckanext-datarequests

### Harvester ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-harvest.git#egg=ckanext-harvest && \
   pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

## s3filestore
RUN pip3 install -e git+https://github.com/qld-gov-au/ckanext-s3filestore.git#egg=ckanext-s3filestore && \
    pip3 install -r ${APP_DIR}/src/ckanext-s3filestore/requirements.txt

## ckan GoogleAnalytics
RUN pip3 install -e git+https://github.com/ckan/ckanext-googleanalytics.git#egg=ckanext-googleanalytics && \
    pip3 install -r ${APP_DIR}/src/ckanext-googleanalytics/requirements.txt

## ckanext-showcase
RUN pip3 install -e git+https://github.com/ckan/ckanext-showcase.git#egg=ckanext-showcase && \
    pip3 install -r ${APP_DIR}/src/ckanext-showcase/requirements.txt


# Copy custom initialization scripts
COPY contrib/ckan/docker-entrypoint.d/* /docker-entrypoint.d/

ENV APP_DIR=/srv/app
# Install any extensions needed by your CKAN instance
### Harvester ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-harvest.git#egg=ckanext-harvest && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

## s3filestore
RUN pip3 install -e git+https://github.com/qld-gov-au/ckanext-s3filestore.git#egg=ckanext-s3filestore && \
    pip3 install -r ${APP_DIR}/src/ckanext-s3filestore/requirements.txt

## ckan GoogleAnalytics
RUN pip3 install -e git+https://github.com/ckan/ckanext-googleanalytics.git#egg=ckanext-googleanalytics && \
    pip3 install -r ${APP_DIR}/src/ckanext-googleanalytics/requirements.txt

## ckanext-showcase
RUN pip3 install -e git+https://github.com/ckan/ckanext-showcase.git#egg=ckanext-showcase && \
    pip3 install -r ${APP_DIR}/src/ckanext-showcase/requirements.txt

# Copy custom initialization scripts for production
COPY contrib/ckan/docker-entrypoint.d/* /docker-entrypoint.d/
