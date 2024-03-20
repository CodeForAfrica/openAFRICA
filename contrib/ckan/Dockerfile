FROM ckan/ckan-base:2.9

# Install any extensions needed by your CKAN instance
### OpenAfrica ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-openafrica.git#egg=ckanext-openafrica

### Datarequests
RUN pip3 install -e git+https://github.com/qld-gov-au/ckanext-datarequests.git#egg=ckanext-datarequests

### Harvester ###
RUN pip3 install -e git+https://github.com/ckan/ckanext-harvest.git@master#egg=ckanext-harvest && \
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

#3ckan Harvester
RUN pip3 install -e git+https://github.com/ckan/ckanext-harvest.git#egg=ckanext-harvest && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/requirements.txt

# Copy custom initialization scripts
COPY docker-entrypoint.d/* /docker-entrypoint.d/