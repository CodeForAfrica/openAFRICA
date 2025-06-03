include $(PWD)/.env

build:
	docker compose build

up:
	docker compose up

build-web:
	docker compose build web

web:
	docker compose up web

bash:
	docker compose exec web bash

db-init:
	docker compose exec web ckan -c ckan.ini db init

db-upgrade:
	docker compose exec web ckan -c ckan.ini  db upgrade

rebuild-index:
	docker compose exec web ckan -c ckan.ini search-index rebuild

issues-init:
	docker compose exec web ckan -c ckan.ini issues init_db

ckan:
	docker buildx build --platform linux/amd64 --no-cache --build-arg CKAN_VERSION=$(CKAN_VERSION) --tag codeforafrica/ckan:latest --tag codeforafrica/ckan:$(CKAN_VERSION) .

ckan-publish:
	docker push codeforafrica/ckan:latest
	docker push codeforafrica/ckan:$(CKAN_VERSION)

solr:
	docker buildx build --platform linux/amd64 --no-cache --build-arg CKAN_VERSION=$(CKAN_VERSION) --tag codeforafrica/ckan-solr:latest --tag codeforafrica/ckan-solr:$(CKAN_SOLR_VERSION) contrib/solr

solr-publish:
	docker push codeforafrica/ckan-solr:latest
	docker push codeforafrica/ckan-solr:$(CKAN_SOLR_VERSION)

datapusher:
	docker buildx build --platform linux/amd64 --tag codeforafrica/ckan-datapusher:latest --tag codeforafrica/ckan-datapusher:$(DATAPUSHER_VERSION) contrib/ckan-datapusher

datapusher-publish:
	docker push codeforafrica/ckan-datapusher:latest
	docker push codeforafrica/ckan-datapusher:$(DATAPUSHER_VERSION)
