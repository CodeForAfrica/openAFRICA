build:
	docker-compose build

web:
	docker-compose up ckan


ckan:
	docker build -t codeforafrica/ckan:latest contrib/ckan

ckan-latest:
	docker build -t codeforafrica/ckan:latest contrib/ckan
	docker push codeforafrica/ckan:latest

ckan-release:
	docker build -t codeforafrica/ckan:2.6.8 contrib/ckan
	docker push codeforafrica/ckan:2.6.8


solr:
	rm -rf ckan
	wget -nc https://github.com/ckan/ckan/archive/ckan-2.6.8.tar.gz
	mkdir ckan && tar -xf ckan-2.6.8.tar.gz -C ckan --strip-components=1
	cd ckan && \
	docker build -t codeforafrica/ckan-solr:latest contrib/docker/solr && \
	docker build -t codeforafrica/ckan-solr:2.3 contrib/docker/solr && \
	docker push codeforafrica/ckan-solr:latest && \
	docker push codeforafrica/ckan-solr:2.3
	rm -rf ckan


datapusher:
	docker build -t codeforafrica/ckan-datapusher:latest contrib/ckan-datapusher


datapusher-release:
	docker build -t codeforafrica/ckan-datapusher:latest -t codeforafrica/ckan-datapusher:0.2 contrib/ckan-datapusher
	docker push codeforafrica/ckan-datapusher:0.2
