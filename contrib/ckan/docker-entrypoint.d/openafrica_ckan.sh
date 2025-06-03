#!/bin/bash

#OpenAfrica Custom
if [[ $CKAN__PLUGINS == *"openafrica"* ]]; then
   ckan config-tool ${CKAN_INI} -s app:main -e ckan.site_title="openAFRICA"
   ckan config-tool ${CKAN_INI} -s app:main -e ckan.site_description='"Africa'\''s largest independent source for open data"'
else
   echo "Not appliyng OpenAfrica customizations"
fi

#BS3 Templates
# ckan config-tool ${CKAN_INI} -s app:main -e ckan.base_public_folder=public-bs3
# ckan config-tool ${CKAN_INI} -s app:main -e ckan.base_templates_folder=templates-bs3

#Auth settings
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.create_user_via_web=true
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.public_user_details=true
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.create_default_api_keys=true

#Auth settings, limit actions to sysadmin users
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.user_create_organizations=false
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.user_create_groups=false
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.user_delete_groups=false
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.user_delete_organizations=false


#Dataset Settings
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.public_activity_stream_detail=true
ckan config-tool ${CKAN_INI} -s app:main -e ckan.auth.allow_dataset_collaborators=false

# Customize which text formats the text_view plugin will show
ckan config-tool ${CKAN_INI} -s app:main -e ckan.preview.json_formats='json'
ckan config-tool ${CKAN_INI} -s app:main -e ckan.preview.xml_formats='xml rdf rdf+xml owl+xml atom rss'
ckan config-tool ${CKAN_INI} -s app:main -e ckan.preview.text_formats='text plain text/plain'

# Customize which image formats the image_view plugin will show
ckan config-tool ${CKAN_INI} -s app:main -e ckan.preview.image_formats='png jpeg jpg gif'

# reCAPTCHA
ckan config-tool ${CKAN_INI} -s app:main -e ckan.recaptcha.publickey=${CKAN_RECAPTCHA_PUBLIC_KEY}
ckan config-tool ${CKAN_INI} -s app:main -e ckan.recaptcha.privatekey=${CKAN_RECAPTCHA_PRIVATE_KEY}

# Site Settings

# Default requests.timeout value 5 seconds
ckan config-tool ${CKAN_INI} -s app:main ckan.requests.timeout=${CKAN_REQUESTS_TIMEOUT}
ckan config-tool ${CKAN_INI} -s app:main ckan.resource_proxy.timeout=${CKAN_RESOURCE_PROXY_TIMEOUT}

ckan config-tool ${CKAN_INI} -s DEFAULT "debug = false"
