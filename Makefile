ifneq (,$(wildcard ./.env))
    include .env
    export
    ENV_FILE_PARAM = --env-file .env
endif
start:
	@if [ ! -d ${APP_FOLDER} ]; then mkdir ${APP_FOLDER}; fi
	@echo "🚀🚀🚀 Launching docker containers 🚀🚀🚀"
	@docker-compose up -d > /dev/null 2>&1
	@echo "⏰⏰⏰ Waiting Wordpress to be ready...⏰⏰⏰"
	@while [ ! -f ${APP_FOLDER}/wp-config.php ]; do sleep 1; done
	@echo "✅ Wordpress is ready ✅"
configure: start
	@if [ -f ${APP_FOLDER}/config.ok ]; then echo "✅ Wordpress is already configured ✅" && exit 1; fi
	@echo "🛠🛠🛠 Setting up wordpress...🛠🛠🛠"
	@docker run -it --rm --volumes-from ${APP_CONTAINER_NAME} --network container:${APP_CONTAINER_NAME} wordpress:cli wp core install --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN} --admin_password=${WP_PASSWORD} --admin_email=${WP_MAIL} > /dev/null 2>&1
	@docker run -it --rm --volumes-from ${APP_CONTAINER_NAME} --network container:${APP_CONTAINER_NAME} wordpress:cli wp core language install ${WP_LANGUAGE} > /dev/null 2>&1
	@docker run -it --rm --volumes-from ${APP_CONTAINER_NAME} --network container:${APP_CONTAINER_NAME} wordpress:cli wp site switch-language ${WP_LANGUAGE} > /dev/null 2>&1
	@touch ${APP_FOLDER}/config.ok > /dev/null 2>&1
	@echo "✅ Wordpress has been successfully configured ✅"
down:
	@echo "💥 Stopping and removing containers...💥"
	@docker-compose down > /dev/null 2>&1

clean: down
	@echo "💥💥 Removing wordpress folders/files...💥💥"
	@rm -rf  ${APP_FOLDER}/* && rm ${APP_FOLDER}/.htaccess* > /dev/null 2>&1
	@echo "💥💥💥 cleaning database...💥💥💥"
	@docker run --rm imega/mysql-client mysql --host=${DB_HOST} --user=${DB_USER} -p${DB_PASS} --database=mysql --execute='DROP DATABASE IF EXISTS ${DB_NAME}; CREATE DATABASE IF NOT EXISTS ${DB_NAME};' > /dev/null 2>&1