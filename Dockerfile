# Base stage for shared dependencies and extensions
FROM ckan/ckan-base:2.10.4 as base

ENV PYTHONPATH=/usr/lib/python3.10/site-packages/
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

# Development stage
FROM ckan/ckan-dev:2.10.4 as dev
ENV PYTHONPATH=/usr/lib/python3.10/site-packages/
ENV APP_DIR=/srv/app

# Copy the base extensions installation from the base image
COPY --from=base ${PYTHONPATH} ${PYTHONPATH}/
COPY --from=base ${APP_DIR} ${APP_DIR}/

RUN chown -R ckan:ckan ${APP_DIR}

# Clone the extension(s) you are writing for your own project in the `src` folder
# to get them mounted in this image at runtime
COPY ckanext-openafrica/ ${APP_DIR}/src/ckanext-openafrica
RUN cd ${APP_DIR}/src/ckanext-openafrica && python3 setup.py develop

COPY ckanext-datarequests/ ${APP_DIR}/src/ckanext-datarequests
RUN cd ${APP_DIR}/src/ckanext-datarequests && python3 setup.py develop

# Copy custom initialization scripts for development
COPY contrib/ckan/docker-entrypoint.d/* /docker-entrypoint.d/

# Production stage
FROM base as prod

### OpenAfrica ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-openafrica.git#egg=ckanext-openafrica

### Datarequests
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-datarequests.git#egg=ckanext-datarequests

# Copy custom initialization scripts for production
COPY contrib/ckan/docker-entrypoint.d/* /docker-entrypoint.d/
