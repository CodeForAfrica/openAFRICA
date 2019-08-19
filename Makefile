build:
	docker-compose build

web:
	docker-compose up web
bash:
	docker-compose exec web bash


paster:
	docker-compose exec web paster --plugin=ckan

db-init:
	docker-compose exec web paster --plugin=ckan db init
db-upgrade:
	docker-compose exec web paster --plugin=ckan db upgrade
rebuild-index:
	docker-compose exec web paster --plugin=ckan search-index rebuild -r
issues-init:
	docker-compose exec web paster --plugin=ckanext-issues issues init_db


ckan:
	docker build --no-cache --build-arg CKAN_VERSION=2.7.0 -t codeforafrica/ckan:latest -t codeforafrica/ckan:2.7.0 contrib/ckan

ckan-publish:
	docker push codeforafrica/ckan:latest
	docker push codeforafrica/ckan:2.7.0

solr:
	docker build --no-cache --build-arg CKAN_VERSION=2.7.0 -t codeforafrica/ckan-solr:latest -t codeforafrica/ckan-solr:2.7 contrib/solr

solr-publish:
	docker push codeforafrica/ckan-solr:latest
	docker push codeforafrica/ckan-solr:2.7


datapusher:
	docker build -t codeforafrica/ckan-datapusher:latest -t codeforafrica/ckan-datapusher:0.0.15 contrib/ckan-datapusher

datapusher-publish:
	docker push codeforafrica/ckan-datapusher:latest
	docker push codeforafrica/ckan-datapusher:0.0.15
