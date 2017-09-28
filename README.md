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

## Deployment

We use [dokku](http://dokku.viewdocs.io/dokku/) for deployment so you'd need to install and set it up first.

Once installed, we can do the following:

1. Create the Dokku app and add a domain to it

``` 
dokku apps:create ckan
dokku domains:add ckan openafrica.net
```

2. Add letsencrypt for free `https` certificate

Install the [dokku-letsencrypt](https://github.com/dokku/dokku-letsencrypt) plugin and set the config variables

```
sudo dokku letsencrypt ckan
```

3. Run Solr + Redis + Postgres

Install the [solr](https://github.com/dokku/dokku-solr), [redis](https://github.com/dokku/dokku-redis), and [postgres](https://github.com/dokku/dokku-postgres) plugins and set the necessary environment variables

```
sudo dokku plugin:install https://github.com/dokku/dokku-solr.git solr
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git redis
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres

dokku solr:create solr
dokku redis:create redis
dokku postgres:create postgres
dokku solr:link solr ckan
dokku redis:link redis ckan
dokku postgres:link postgres ckan
```

Once done, you can push this repository to dokku:

```
git remote add dokku dokku@openafrica.net:ckan
git push dokku
```

***NOTE:** Make sure to have the [appropriate permissions to push to dokku](http://dokku.viewdocs.io/dokku/deployment/user-management/).*

---

## License

MIT License

Copyright (c) 2017 Code for Africa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
