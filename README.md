# openAFRICA
*The continent's largest volunteer-driven open data portal.*

![CKAN version](https://img.shields.io/badge/CKAN-v2.6.5-brightgreen.svg)

This repo seeks to streamline deployment of the openAFRICA platform by pulling together the different components used for [openAFRICA](https://openafrica.net/) and deploy using [dokku](http://dokku.viewdocs.io/dokku/).

## CKAN

CKAN is an open-source DMS (data management system) for powering data hubs and data portals. CKAN makes it easy to publish, share and use data. It powers datahub.io, catalog.data.gov and data.gov.uk among many other sites.

We use CKAN's own vanilla releases but because they haven't properly adopted Docker and dockerhub (yet) for deployment, we're keeping a stable version (`codeforafrica/ckan:latest`) that we can be sure plays nice with our extenstions.

The ckan extensions we are using include:

- ckanext-openafrica - https://github.com/CodeForAfrica/ckanext-openafrica
- ckanext-datarequests - https://github.com/CodeForAfricaLabs/ckanext-datarequests
- ckanext-harvester - https://github.com/ckan/ckanext-harvest
- ckanext-socialite (experimental) - https://github.com/CodeForAfricaLabs/ckanext-socialite
- ckanext-social - https://github.com/CodeForAfricaLabs/ckanext-social
- ckanext-notify - https://github.com/CodeForAfricaLabs/ckanext-notify
- ckanext-s3filestore - https://github.com/CodeForAfricaLabs/ckanext-s3filestore
- ckanext-showcase - https://github.com/ckan/ckanext-showcase
- ckanext-googleanalytics - https://github.com/ckan/ckanext-googleanalytics
- ckanext-issues - https://github.com/ckan/ckanext-issues
- ckanext-gdoc - https://github.com/OpenUpSA/ckanext-gdoc


---

## Development


To set up your development environment:

```sh
$ git clone https://github.com/CodeForAfricaLabs/openAFRICA.git

$ cd openAFRICA
```

Run this command (found on the docker-compose.yml):

```sh
docker-compose build && docker-compose up
```

### Updating CKAN Docker Image

To update the `openafrica/ckan:latest` Docker image, edit `Makefile` and then run:

```sh
make ckan
```

### Tests

?

---

## Deployment

We use [dokku](http://dokku.viewdocs.io/dokku/) for deployment so you'd need to install and set it up first;

```
 # for debian systems, installs dokku via apt-get
 $ wget https://raw.githubusercontent.com/dokku/dokku/v0.11.3/bootstrap.sh
 $ sudo DOKKU_TAG=v0.11.3 bash bootstrap.sh
 # go to your server's IP and follow the web installer
```


### Install + Create Dependencies

Once installed, we can do the following:

1. Create the Dokku app and add a domain to it

```
dokku apps:create ckan
dokku domains:add ckan openafrica.net
```

2. Add letsencrypt for free `https` certificate

Install the [dokku-letsencrypt](https://github.com/dokku/dokku-letsencrypt) plugin and set the config variables

```
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
dokku config:set --no-restart ckan DOKKU_LETSENCRYPT_EMAIL=support@codeforafrica.org
```

3. Create CKAN Solr Instance

CKAN uses a special schema for Solr so you should deploy `openafrica/solr`

```
dokku apps:create ckan-solr

sudo docker volume create --name ckan-solr
dokku docker-options:add ckan-solr run,deploy --volume ckan-solr:/opt/solr/server/solr/ckan

sudo docker pull openafrica/solr:latest
sudo docker tag openafrica/solr:latest dokku/ckan-solr:latest

dokku tags:deploy ckan-solr latest

```

4. Create Redis Instance

Install the [redis](https://github.com/dokku/dokku-redis) plugin.

```
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git redis
dokku redis:create ckan-redis

```

5. Create CKAN DataPusher Instance

[DataPusher](https://github.com/ckan/datapusher) is a standalone web service that automatically downloads any CSV or XLS (Excel) data files from a CKAN site's resources when they are added to the CKAN site, parses them to pull out the actual data, then uses the DataStore API to push the data into the CKAN site's DataStore.

```
dokku apps:create ckan-datapusher

sudo docker pull openafrica/ckan-datapusher:latest
sudo docker tag openafrica/ckan-datapusher:latest dokku/ckan-datapusher:latest

dokku tags:deploy ckan-datapusher latest

```

6. Install Postgres (Optional)

This is an optional step if you'd like to have Postgres installed locally;

```
sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
dokku postgres:create ckan-postgres

```

7. Install RabbitMQ

Install the [RabbitMQ](https://github.com/dokku/dokku-rabbitmq) plugin (The harvest extension uses this as its backend)

```
sudo dokku plugin:install https://github.com/dokku/dokku-rabbitmq.git rabbitmq
dokku rabbitmq:create ckan-rabbitmq
```

8. Set up S3

Create a bucket and a programmatic access user, and grant the user full access to the bucket with the following policy

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::openafrica/*",
                "arn:aws:s3:::openafrica"
            ]
        }
    ]
}
```

9. Create CKAN filestore volume

Create a named docker volume and configure ckan to use the volume just so we can configure an upload path. It should be kept clear by the s3 plugin.

```
sudo docker volume create --name ckan-filestore
dokku docker-options:add ckan run,deploy --volume ckan-filestore:/var/lib/ckan/default
```

### Configuration

Now we configure to pull the dependencies together:

Get the Redis Dsn (connection details) for setting in CKAN environment in the next step with /0 appended.

```
dokku redis:info ckan-redis
```
Get the RabbitMQ Dsn (connection details) and extract the `username`, `password`, `hostname`, `virtualhost` and `port`. You need these details because the harvester extension in its current form does not support configuration using RabbitMQ URI scheme. The URI is in the form

```
amqp://username:password@hostname:port/virtualhost
```


Set CKAN environment variables, replacing these examples with actual producation ones

- REDIS_URL: use the Redis Dsn
- SOLR_URL: use the alias given for the docker link below
- BEAKER_SESSION_SECRET: this must be a secret long random string. Each time it changes it invalidates any active sessions.
- S3FILESTORE__SIGNATURE_VERSION: use as-is - no idea why the plugin requires this.


```
dokku config:set ckan CKAN_SQLALCHEMY_URL=postgres://ckan_default:password@host/ckan_default \
                      CKAN_DATASTORE_READ_URL=postgresql://ckan_default:pass@localhost/datastore_default \
                      CKAN_DATASTORE_WRITE_URL=postgresql://datastore_default:pass@localhost/datastore_default \
                      CKAN_REDIS_URL=.../0 \
                      CKAN_INI=/ckan.ini \
                      CKAN_SOLR_URL=http://solr:8983/solr/ckan \
                      CKAN_SITE_URL=https://openafrica.net/ \
                      CKAN___BEAKER__SESSION__SECRET= \
                      CKAN_SMTP_SERVER= \
                      CKAN_SMTP_USER= \
                      CKAN_SMTP_PASSWORD= \
                      CKAN_SMTP_MAIL_FROM=hello@openafrica.net \
                      CKAN___CKANEXT__S3FILESTORE__AWS_BUCKET_NAME=openafrica \
                      CKAN___CKANEXT__S3FILESTORE__AWS_ACCESS_KEY_ID= \
                      CKAN___CKANEXT__S3FILESTORE__AWS_SECRET_ACCESS_KEY= \
                      CKAN___CKANEXT__S3FILESTORE__HOST_NAME=http://s3-eu-west-1.amazonaws.com \
                      CKAN___CKANEXT__S3FILESTORE__REGION_NAME=eu-west-1 \
                      CKAN___CKANEXT__S3FILESTORE__SIGNATURE_VERSION=s3v4 \
                      CKAN__HARVEST__MQ__VIRTUAL_HOST=ckan-rabbitmq \
                      CKAN__HARVEST__MQ__PORT=5672 \
                      CKAN__HARVEST__MQ__HOSTNAME=dokku-rabbitmq-ckan-rabbitmq \
                      CKAN__HARVEST__MQ__PASSWORD=912abee9882be7ca8718d3cab7263cfd \
                      CKAN__HARVEST__MQ__USER_ID=ckan-rabbitmq \
```

Link CKAN with Redis, Solr, and CKAN DataPusher;
```
dokku redis:link ckan-redis ckan  #noqa
dokku docker-options:add ckan run,deploy --link ckan-solr.web.1:solr
dokku docker-options:add ckan run,deploy --link ckan-datapusher.web.1:ckan-datapusher
```

### Scheduled Jobs
For openAFRICA to work perfectly, some jobs have to run at certain times e.g. updating tracking statistics and rebuilding the search index for newly uploaded datasets. To create a scheduled job that is executed by a Dokku application, follow these steps:

```sh
sudo su dokku
crontab -e
```

Add the following entries

```sh
0 * * * * echo '{}' | dokku --rm run ckan paster --plugin=ckan post -c /ckan.ini /api/action/send_email_notifications > /dev/null

0 * * * * dokku --rm run ckan paster --plugin=ckan tracking update -c /ckan.ini

*/15 * * * * dokku --rm run ckan paster --plugin=ckanext-harvest harvester run --config=/ckan.ini
```

### Deploy CKAN


Once done with installing and configuring, you can push this repository to dokku:

```
git remote add dokku dokku@openafrica.net:ckan
git push dokku
```

### Initialize Database

Before you can run CKAN for the first time, you need to run `db init` to initialize your database

```
dokku enter ckan
cd src/ckan
paster db init -c /ckan.ini
```

Lastly, let's make sure we encrypt traffic:

```
dokku letsencrypt ckan
```


***NOTE:** Make sure to have the [appropriate permissions to push to dokku](http://dokku.viewdocs.io/dokku/deployment/user-management/).*

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

Please report on security vulnerabilities to security@codeforafrica.org. These will be promptly acted on.

---

## License

GNU General Public License

openAFRICA aims to be the largest independent repository of open data on the African continent.
Copyright (C) 2017  Code for Africa

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
