#!/bin/bash

os=${PWD##*/}

version=$1
version=${version:-"latest"}

cd ../
app_component=${PWD##*/}
cd $os/

if [[ ! $version =~ ^[0-9]*\.[0-9]*\.[0-9]*$ ]] && [ "$version" != "latest" ]; then
    echo "Incorrect syntax of the version"
    exit 1
fi

if [ "$version" != "latest" ]; then
    VCS_REF=`svn info svn://svn.zabbix.com/tags/$version |grep "Last Changed Rev"|awk '{print $4;}'`
fi

docker build -t zabbix-$app_component:$os-$version --build-arg VCS_REF="$VCS_REF" --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` -f Dockerfile .

#docker rm -f zabbix-$app_component-$app_database

#docker run --name zabbix-$app_component-$app_database -t -d --link postgres-server:mysql zabbix-$app_component-$app_database:$os-$version
