# openAFRICA
*The continent's largest volunteer-driven open data portal.*

![CKAN version](https://img.shields.io/badge/CKAN-v2.6.3-brightgreen.svg)

This repo seeks to streamline deployment of the openAFRICA platform by pulling together the different components used for [openAFRICA](https://openafrica.net/) and deploy using [dokku](http://dokku.viewdocs.io/dokku/).

## CKAN

CKAN is an open-source DMS (data management system) for powering data hubs and data portals. CKAN makes it easy to publish, share and use data. It powers datahub.io, catalog.data.gov and data.gov.uk among many other sites.

We use CKAN's own vanilla releases but because they haven't properly adopted Docker and dockerhub (yet) for deployment, we're keeping a stable version (`codeforafrica/ckan:latest`) that we can be sure plays nice with our extenstions.

The ckan extensions we are using include:

- ckanext-openafrica - https://github.com/CodeForAfrica/ckanext-openafrica
- ckanext-harvester - ?
- ckanext-socialite (experimental) - https://github.com/CodeForAfricaLabs/ckanext-socialite
- ckanext-social - https://github.com/CodeForAfricaLabs/ckanext-social


---

## Contributing

Thank you for considering to contribute to this project. You are awesome. :)

To get you started, here are few pointers:

- We have a number of Github issues to work through here:
  - openAFRICA deploy: https://github.com/CodeForAfricaLabs/openAFRICA/issues
  - ckanext-openafrica: https://github.com/CodeForAfrica/ckanext-openafrica/issues
  - ckanext-socialite: https://github.com/CodeForAfricaLabs/ckanext-socialite/issues
  - ckanext-social: https://github.com/CodeForAfricaLabs/ckanext-social/issues
- If you believe an issue is with CKAN core or related extenstions, post them here:
  - CKAN core: https://github.com/ckan/ckan/issues
  - ckanext-harvester: ?

Check out the [development docs](#development) to get started on this repo locally.


### Security Vulnerabilities

Please report on security vulnerabilities to support@codeforafrica.org. These will be promptly acted on.

---

## Development

<!-- We should make a docker-compose.yml for this. -->

To set up your development environment:

?


### Updating Docker Image

To update the `codeforafrica/ckan:latest` Docker image:
```sh
git clone https://github.com/ckan/ckan.git && git checkout ckan-2.6.3 && cd ckan
docker build -t codeforafrica/ckan:latest .
```

You can also push to Docker Hub:
```sh
docker push codeforafrica/ckan:latest
```


### Tests

?

---

## Deployment (Untested)

We use [dokku](http://dokku.viewdocs.io/dokku/) for deployment so you'd need to install and set it up first.

Once installed, we can do the following:
```sh
# Create the Dokku app
dokku apps:create ckan
dokku domains:add ckan http://openafrica.net

# Letsencrypt
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
sudo dokku letsencrypt ckan

# Solr + Redis
sudo dokku plugin:install https://github.com/dokku/dokku-solr.git solr
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git redis
dokku solr:create solr
dokku redis:create redis
dokku solr:link solr ckan
dokku redis:link redis ckan
```

Once done, you can push this repository to dokku:

```sh
git remote add dokku dokku@openafrica.net:ckan
git push dokku
```

---

## License

MIT 
