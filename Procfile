web: gunicorn --workers 2 --worker-class gevent --paste ckan.ini -t 600
ckan_gather_consumer: paster --plugin=ckanext-harvest harvester gather_consumer --config=ckan.ini
ckan_fetch_consumer: paster --plugin=ckanext-harvest harvester fetch_consumer --config=ckan.ini
