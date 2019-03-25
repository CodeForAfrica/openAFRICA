build:
	docker-compose build

web:
	docker-compose up ckan


ckan:
	docker build -t openafrica/ckan:latest contrib/ckan

ckan-latest:
	docker build -t openafrica/ckan:latest contrib/ckan
	docker push openafrica/ckan:latest

ckan-release:
	docker build -t openafrica/ckan:2.6.7 contrib/ckan
	docker push openafrica/ckan:2.6.7


solr:
	rm -rf ckan
	wget -nc https://github.com/ckan/ckan/archive/ckan-2.6.7.tar.gz
	mkdir ckan && tar -xf ckan-2.6.7.tar.gz -C ckan --strip-components=1
	docker build -t openafrica/solr:latest ckan/contrib/docker/solr
	docker build -t openafrica/solr:2.3 ckan/contrib/docker/solr
	docker push openafrica/solr:latest
	docker push openafrica/solr:2.3
	rm -rf ckan


datapusher:
	docker build -t openafrica/ckan-datapusher:latest contrib/ckan-datapusher


datapusher-release:
	docker build -t openafrica/ckan-datapusher:latest -t openafrica/ckan-datapusher:0.2 contrib/ckan-datapusher
	docker push openafrica/ckan-datapusher:0.2
