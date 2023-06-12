web: gunicorn --workers 5 --worker-class gevent --ckan ckan.ini -t 10800

ckan_gather_consumer: ckan --config=ckan.ini --plugin=ckanext-harvest harvester gather_consumer

ckan_fetch_consumer: ckan --config=ckan.ini --plugin=ckanext-harvest harvester fetch_consumer
