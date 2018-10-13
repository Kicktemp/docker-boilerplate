#!/usr/bin/env bash

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

case "$1" in
    ###################################
    ## Grunt Exec
    ###################################
    "exec")
        dockerExecApplication sh -c "cd /app/public/ && grunt exec:schuelbe"
    ;;

    ###################################
    ## Grunt Clean
    ###################################
    "clean")
        dockerExecApplication sh -c "cd /app/public/ && grunt clean:schuelbe"
    ;;

    ###################################
    ## Grunt Less
    ###################################
    "less")
        dockerExecApplication sh -c "cd /app/public/ && grunt less:schuelbe"
    ;;

    ###################################
    ## Grunt Watch
    ###################################
    "watch")
        dockerExecApplication sh -c "cd /app/public/ && grunt watch:schuelbe"
    ;;

    ###################################
    ## Grunt Install
    ###################################
    "install")
        # Create Gruntfile if not exists
    gruntSampleFile="${PUBLIC_DIR}/Gruntfile.js.sample"
    gruntFile="${PUBLIC_DIR}/Gruntfile.js"

    if [ ! -f "${gruntFile}" ]
    then
        if [ -f "${gruntSampleFile}" ]
        then
            cp "${gruntSampleFile}"  "${gruntFile}"
            echo "Gruntfile created"
        else
            echo "${gruntSampleFile} not found"
        fi
    else
        echo "Gruntfile already exits!"
    fi

    # Create Package if not exists
    packageSampleFile="${PUBLIC_DIR}/package.json.sample"
    packageFile="${PUBLIC_DIR}/package.json"

    if [ ! -f "${packageFile}" ]
    then
        if [ -f "${packageSampleFile}" ]
        then
            cp "${packageSampleFile}"  "${packageFile}"
            echo "Package.json created"
        else
            echo "${packageSampleFile} not found"
        fi
    else
        echo "Package.json already exits!"
    fi

    # Install grunt
    dockerExec sh -c "cd /app/public/ && curl -sL https://deb.nodesource.com/setup_8.x | bash -"
    dockerExec sh -c "apt-get install -y nodejs"
    dockerExec sh -c "cd /app/public/ && npm install -g grunt-cli"
    dockerExec sh -c "cd /app/public/ && npm install grunt --save-dev"
    dockerExec sh -c "cd /app/public/ && npm install"
    dockerExec sh -c "cd /app/public/ && npm update"
    ;;

esac