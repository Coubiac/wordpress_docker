# Installing wordpress with Docker and an external database

First, Create an .env file on the same template as the .env.sample file: 

```
# Database configuration
DB_HOST=192.168.1.1
DB_USER=root
DB_PASS=pass
DB_NAME=wordpress

# Wordpress configuration
WP_URL=http://localhost:8787
WP_ADMIN=admin
WP_PASSWORD=password
WP_TITLE="Mon super blog"
WP_MAIL=foo@toto.fr
WP_LANGUAGE=fr_FR

# Docker Configuration
APP_DEFAULT_PORT=8787
APP_FOLDER=./app
APP_CONTAINER_NAME=myWonderfullWP
```
then, 

## to start the stack for the first time:

```
make configure
```

## to stop the stack
```
make down
```
## to clean the stack
```
make clean
```
this command will delete the containers, the wordpress files and empty the database.

## to start an already configured stack
```
make start
```