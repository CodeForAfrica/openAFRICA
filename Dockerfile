FROM ckan/ckan-dev:2.9

# Install any extensions needed by your CKAN instance
# - Make sure to add the plugins to CKAN__PLUGINS in the .env file
# - Also make sure all provide all extra configuration options, either by:
#   * Adding them to the .env file (check the ckanext-envvars syntax for env vars), or
#   * Adding extra configuration scripts to /docker-entrypoint.d folder) to update
#      the CKAN config file (ckan.ini) with the `ckan config-tool` command
#
# See README > Extending the base images for more details
#
# For instance:
#
### OpenAfrica ###
RUN pip3 install -e git+https://github.com/CodeForAfrica/ckanext-openafrica.git@ft/ui-changes#egg=ckanext-openafrica

## s3filestore
RUN pip3 install -e git+https://github.com/qld-gov-au/ckanext-s3filestore.git#egg=ckanext-s3filestore && \
    pip3 install -r ${APP_DIR}/src/ckanext-s3filestore/requirements.txt

### XLoader ###
#RUN pip3 install -e 'git+https://github.com/ckan/ckanext-xloader.git@master#egg=ckanext-xloader' && \ 
#    pip3 install -r ${APP_DIR}/src/ckanext-xloader/requirements.txt && \
#    pip3 install -U requests[security]

### Harvester ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@master#egg=ckanext-harvest' && \
   pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt
# will also require gather_consumer and fetch_consumer processes running (please see https://github.com/ckan/ckanext-harvest)

### Scheming ###
#RUN  pip3 install -e 'git+https://github.com/ckan/ckanext-scheming.git@master#egg=ckanext-scheming'

### Pages ###
#RUN  pip3 install -e git+https://github.com/ckan/ckanext-pages.git#egg=ckanext-pages

### DCAT ###
#RUN  pip3 install -e git+https://github.com/ckan/ckanext-dcat.git@v0.0.6#egg=ckanext-dcat && \
#     pip3 install -r https://raw.githubusercontent.com/ckan/ckanext-dcat/v0.0.6/requirements.txt

# Clone the extension(s) your are writing for your own project in the `src` folder
# to get them mounted in this image at runtime

# Copy custom initialization scripts
# COPY docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
# COPY patches ${APP_DIR}/patches

# RUN for d in $APP_DIR/patches/*; do \
#         if [ -d $d ]; then \
#             for f in `ls $d/*.patch | sort -g`; do \
#                 cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
#             done ; \
#         fi ; \
#     done