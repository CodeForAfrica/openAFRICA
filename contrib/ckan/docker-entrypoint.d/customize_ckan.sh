#!/bin/bash

#Setup CKAN Datarequests (Init DB)
if [[ $CKAN__PLUGINS == *"datarequests"* ]]; then
    ckan -c /srv/app/ckan.ini datarequests initdb
else
    echo "Datarequests extension not available"
fi

if [[ $CKAN__PLUGINS == *"openafrica"* ]]; then
   ckan config-tool ${CKAN_INI} -s app:main -e ckan.site_title="openAFRICA"
   ckan config-tool ${CKAN_INI} -s app:main -e ckan.site_description=""Africa's largest independent source for open data" 
else
   echo "Not appliyng OpenAfrica customizations"
fi