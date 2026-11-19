FROM ckan/ckan-base:2.11.4
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

ENV APP_DIR=/srv/app

# Pin every Python dependency to the versions production runs, so a rebuild
# doesn't silently pull untested upgrades. Regenerate when upgrading on purpose.
COPY constraints.txt ${APP_DIR}/constraints.txt
ENV PIP_CONSTRAINT=${APP_DIR}/constraints.txt

### OpenAfrica ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-openafrica.git#egg=ckanext-openafrica

### Datarequests (CodeForAfrica fork) ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-datarequests.git@352fd304ee684aed9196948817a7c230f6aca05a#egg=ckanext-datarequests

### Harvester ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-harvest.git@34bbcdbd65fa31a798b9ad688ea591ba72ffa7bd#egg=ckanext-harvest && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt

### S3 Filestore (qld-gov-au, supports CKAN 2.11) ###
# See ckanext.s3filestore.acl.async_update in openafrica_ckan.sh
RUN pip3 install ckanext-s3filestore==0.11.3

### Google Analytics ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-googleanalytics.git@7716578ea4c58a870e6a2a1648597d32ff71a426#egg=ckanext-googleanalytics && \
    pip3 install -r ${APP_DIR}/src/ckanext-googleanalytics/requirements.txt

### Showcase ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-showcase.git@ebd9143be19d0a6557b8a434e7f9e62cbd66164f#egg=ckanext-showcase && \
    pip3 install -r ${APP_DIR}/src/ckanext-showcase/requirements.txt

# Copy custom initialization scripts
COPY contrib/ckan/docker-entrypoint.d/* /docker-entrypoint.d/
