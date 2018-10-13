#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )/.env"



if [ "$#" -ne 1 ]; then
    echo "No type defined"
    exit 1
fi

case "$1" in
    ###################################
    ## Magento2 permissions
    ###################################
    "permissions")
        dockerExec sh -c "chmod -R 777 /app/public/pub/static/"
        dockerExec sh -c "chmod -R 777 /app/public/generated/"
#        dockerExec sh -c "chown -R application:application /app/public/"
        echo "Permissions set for developer mode"
    ;;

    ###################################
    ## Magento2 bin/magento
    ###################################
    "m2")
        dockerExec sh -c "php /app/public/bin/magento"
    ;;

    ###################################
    ## Magento2 cache clean
    ###################################
    "m2")
        dockerExec sh -c "php /app/public/bin/magento cache:clean"
    ;;

    ###################################
    ## Magento2 Deploy
    ###################################
    "deploy")
        dockerExec sh -c "rm -rf /app/public/var/view_preprocessed/css/frontend/Magento/blank"
        dockerExec sh -c "rm -rf /app/public/pub/static/frontend/Magento/blank/de_DE/css"
        dockerExec sh -c "/app/public/bin/magento setup:static-content:deploy -t Magento/blank --no-javascript --no-html --no-fonts --no-images --no-misc --no-html-minify en_US de_DE -j1000"
        dockerExec sh -c "/app/public/bin/magento cache:clean"
    ;;

     ###################################
    ## Magento2 Common install tasks
    ###################################
    "setup")
        source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/restore.sh" mysql
        source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/m2.sh" setconfig
        dockerExecApplication sh -c "cd /app/public && composer install"
        dockerExec sh -c "php /app/public/bin/magento cache:clean"
        dockerExec sh -c "php /app/public/bin/magento deploy:mode:set developer"
        dockerExec sh -c "php /app/public/bin/magento cache:enable"
        source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/grunt.sh" install
        source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/m2.sh" permissions
        source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/m2.sh" url
        dockerExec sh -c "php /app/public/bin/magento setup:upgrade"
        dockerExec sh -c "php /app/public/bin/magento cache:clean"
        source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/m2.sh" permissions
    ;;

    ###################################
    ## Magento2 Base URL
    ###################################
    "url")
        logMsg "Update Base URL in Mysql"

        if [[ -n "$(dockerContainerId mysql)" ]]; then
            logMsg "Updating MySQL Base URLs..."
            MYSQL_ROOT_PASSWORD=$(dockerExecMySQL printenv MYSQL_ROOT_PASSWORD)
            PROJECT_URL="http://${PROJECT_NAME}.lvh.me"
            SQL_UPDATE_URL_UNSECURE="UPDATE core_config_data SET value = '"${PROJECT_URL}"' WHERE core_config_data.config_id = 2;"
            SQL_UPDATE_URL_SECURE="UPDATE core_config_data SET value = '"${PROJECT_URL}"' WHERE core_config_data.config_id = 3;"
            dockerExecMySQL sh -c "MYSQL_PWD=\"${MYSQL_ROOT_PASSWORD}\" mysql -uroot db -e \"${SQL_UPDATE_URL_UNSECURE}\""
            dockerExecMySQL sh -c "MYSQL_PWD=\"${MYSQL_ROOT_PASSWORD}\" mysql -uroot db -e \"${SQL_UPDATE_URL_UNSECURE}\""
            dockerExec sh -c "/app/public/bin/magento cache:clean"
            logMsg "Finished"
        else
            echo " * Skipping update base URL, no such container"
        fi

    ;;


    ###################################
    ## Magento2 Set config files(env.php,config.php)
    ###################################
    "setconfig")
    # Create env.php if not exists
    envSampleFile="${PUBLIC_DIR}/app/etc/env.php.sample"
    envFile="${PUBLIC_DIR}/app/etc/env.php"

    if [ ! -f "${envFile}" ]
    then
        if [ -f "${envSampleFile}" ]
        then
            cp "${envSampleFile}"  "${envFile}"
            echo "env.php created"
        else
            echo "${envSampleFile} not found"
        fi
    else
        echo "env.php already exits!"
    fi

    # Create config.php if not exists
    configSampleFile="${PUBLIC_DIR}/app/etc/config.php.sample"
    configFile="${PUBLIC_DIR}/app/etc/config.php"

    if [ ! -f "${configFile}" ]
    then
        if [ -f "${configSampleFile}" ]
        then
            cp "${configSampleFile}"  "${configFile}"
            echo "config.php created"
        else
            echo "${configSampleFile} not found"
        fi
    else
        echo "config.php already exits!"
    fi

    ;;

esac
