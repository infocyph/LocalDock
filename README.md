# localhost

This project provides easy to use docker based development environment for your projects. All the modules are selective &
can be enabled based on Environment file (.env)!

>1. This is for local development only!
>2. Don't state both apache & nginx in COMPOSE_PROFILES.
>3. Domain(s) should exist in the hosts file.

## The directory structure

For using your projects with this, you should arrange your projects structure as follows,
```
| application
       |- site1
       |- site2
       |- site3
       |- .....
| localhost (this repository)
```
Now lets look into the localhost structure for where your configuration files should be.

```
| localhost
       |- docker
             |- sites
                  |- apache
                  |- nginx
             |- conf
                  |- php
             |- ssl
             |- data
             |- logs
       |- .env
       |- docker-compose.yml
       |- server
       |- server.bat
```
- The `data` directory holds the data of images for persistence
- The `logs` directory holds the system logs for each of the images
- The `ssl` directory is where you should put your ssl certificates for your sites
- The `conf/php` directory holds the php related configuration files
- The `sites/apache` directory for the apache site configuration/.conf files (example available in directory)
- The `sites/nginx` directory for the nginx site configuration/.conf files (example available in directory)

## Run the server, the easiest way
- Simply, create `.env` file, place your settings.
- Create site configuration file in `localhost/docker/sites/(nginx or apache)`. Example configuration available in those directory as well.
- Don't forget to add in host file entry for your domain(s)
- Run `server start` or `./server start` (on linux you must run `chmod +x server` first)
- Your site(s) will be available in your desired domain(s)

## Usage
_Note: on linux you must run `chmod +x server` first_
- `./server start/relaod` or `server start/reload` to start the server or reload with updated Environment variables
- If you want to enter in PHP container shell, simply run `server cli` or `./server cli`
- To stop the server, simply run `server stop` or `./server stop`
- To restart/reboot the server, simply run `server restart/reboot` or `./server restart/reboot`
- To rebuild the server, simply run `server rebuild <continer_name>` or `./server rebuild <continer_name>`
- Run any php file directly using PHP container, simply run `server php path/to/file.php` or `./server php path/to/file.php`
- In-fact you can run any command inside Core container using `server <command>` or `./server <command>` (except the above-mentioned ones)

## CLI Utility
You can add the `localhost/bin` directory, to your PATH environment variable for global usage of several commands.

_** If you have any other docker container running with the same name as of this docker container names, it will end up in conflict!_

**Available commands:**
- `php`
- `mysql`
- `mysqldump`
- `mariadb`
- `mariadb-dump`
- `psql`
- `pg_dump`
- `pg_restore`
- `redis-cli`

In windows, it is recommended to use [cmder terminal](https://github.com/cmderdev/cmder) for better experience.

## Modules & Other main settings

Modules (Docker Images, Linux Packages, PHP Versions & Extensions, NodeJS) are controlled based on the environment variables.
Checkout the .env.example file for example. To further understand these keep reading further.

### 1. Sync the system user
Sync the internal docker user with the system user using the environment variable `UID`. In case of linux you can get this
using `id -u` command which is the UID of current user. In case of windows, you can get with same command if you use [cmder
terminal](https://github.com/cmderdev/cmder).

```dotenv
UID=1000
```

### 2. Selecting the docker image
To select the docker image, we used the environment variable `COMPOSE_PROFILES`. You will include your required modules
in CSV format (i.e. nginx,mysql). Here are the list of modules you can state here,
- `nginx` loads nginx image with php
- `apache` loads apache with php
- `mysql` or `mariadb` loads mysql/mariadb (depending on env variable; default is mariadb) with phpmyadmin
- `postgresql` loads postgresql & pgadmin
- `mongodb` loads mongodb & mongo express
- `elasticsearch` loads elasticsearch & kibana
- `redis` loads redis & redis insight

_Note: don't include both `nginx` & `apache`_

```dotenv
COMPOSE_PROFILES=nginx,postgresql
```
### 3. PHP version
Select the PHP version using the environment variable `PHP_VERSION`. Supports single PHP version.

```dotenv
PHP_VERSION=8.2
```

### 4. PHP extensions
List your required PHP extensions using the environment variable `PHP_EXTENSIONS`. Supports CSV formatted list. For the list
of available modules please refer to [mlocati docker extension list](https://github.com/mlocati/docker-php-extension-installer#supported-php-extensions).
Latest composer will be installed by default, no need to specify it.

```dotenv
PHP_EXTENSIONS=bcmath,zip,gd
```

### 5. Linux packages
To install additional linux packages we used the environment variable `LINUX_PACKAGES`. 
These extensions are additional not related to your php extensions as those will be auto installed by `PHP_EXTENSIONS`.
Supports CSV formatted values.

```dotenv
LINUX_PACKAGES=git,curl
```

### 6. Node.js
Your project is also using node.js? To install it, we used the environment variable `NODE_VERSION`. Support major version number (i.e. 18/20/...). Also,
supports either of `lts` or `current` as well. Check [node.js debian source](https://github.com/nodesource/distributions#nodejs) for more details.
Leaving this empty, won't install node.js.

```dotenv
NODE_VERSION=lts
```
### 7. Environment variables

In addition to the above, you can define the following environment variables as you see fit.

- `TZ` Timezone _(default: Asia/Dhaka)_

### nginx/apache
- `HTTP_PORT` http port _(default: 80)_
- `HTTPS_PORT` https port _(default: 443)_

### php
- `PHP_VERSION` PHP version _(default: 8.3)_
- `UID` The uid of system user _(default: 1000)_
- `PHP_EXTENSIONS` List of php extensions in csv format
- `LINUX_PACKAGES` List of linux packages in csv format
- `NODE_VERSION` If node.js is required, specify version

### mariadb/mysql
- `MYSQL_IMAGE` What you wanna use? `mariadb` or `mysql` _(default: mariadb)_
- `MYSQL_VERSION` The version for `mariadb` or `mysql` _(default: latest)_
- `MYSQL_PORT` DB port _(default: 3306)_
- `MYSQL_ROOT_PASSWORD` Root user password _(default: 12345)_
- `MYSQL_USER` DB User _(default: devuser)_
- `MYSQL_PASSWORD` DB password _(default: 12345)_
- `MYSQL_DATABASE` DB name _(default: localdb)_

### mariadb/mysql client (PHPMyAdmin)
- `MYADMIN_PORT` The client access port _(default: 3300)_

### postgres
- `POSTGRESQL_VERSION` The version for `PostgreSQL` _(default: latest)_
- `POSTGRESQL_PORT` DB port _(default: 5432)_
- `POSTGRES_USER` DB user _(default: postgres)_
- `POSTGRES_PASSWORD` DB password _(default: postgres)_
- `POSTGRES_DATABASE` DB name _(default: postgres)_

###  postgres client (PgAdmin 4)
- `PGADMIN_PORT` The client access port _(default: 5400)_

### mongodb
- `MONGODB_VERSION` The version for `MongoDB` _(default: latest)_
- `MONGODB_PORT` DB port _(default: 27017)_
- `MONGODB_ROOT_USERNAME` username _(default: root)_
- `MONGODB_ROOT_PASSWORD` password _(default: 12345)_

### mongodb client (Mongo Express)
- `ME_VERSION` App version _(default: latest)_
- `ME_BA_USERNAME` Basic Auth User _(default: root)_
- `ME_BA_PASSWORD` Basic Auth Password _(default: 12345)_

### elasticsearch
- `ELASTICSEARCH_VERSION` ElasticSearch version _(default:8.12.2)_
- `ELASTICSEARCH_PORT` ES port _(default: 9200)_

### elasticsearch client (Kibana)
- `KIBANA_PORT` The client access port _(default: 5601)_

### redis
- `REDIS_VERSION` Redis version _(default: latest)_
- `REDIS_PORT` Redis port _(default: 6379)_

### redis client (Redis Insight)
- `RI_PORT` The client access port _(default: 5540)_

## ToDo
- Tunnel support
- More other images