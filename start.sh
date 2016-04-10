#!/bin/bash

NGINX=/usr/local/nginx
DATA=/data

cp /app/nginx/nginx.conf ${NGINX}/conf/nginx.conf
cp /app/nginx/docker-registry.default ${NGINX}/conf/docker-registry.default

sed -i 's/registry/'$servicename'/g' ${NGINX}/conf/docker-registry.default
sed -i 's/5000/'$serviceport'/g' ${NGINX}/conf/docker-registry.default
sed -i 's/ldap:\\/\\/54.222.156.183:40389\\/ou=Users,dc=openstack,dc=org?uid?sub?(objectClass=inetOrgPerson)/'$ldap'/g' ${NGINX}/conf/docker-registry.default

if [ ! -f ${DATA}/server.crt ];
then
    echo "use default server certification for demo purpose !!"
	mkdir -p ${DATA}
	mkdir -p /conf
	cp /app/nginx/server.crt ${DATA}/
	cp /app/nginx/server.key ${DATA}/
	cp /app/nginx/docker-registry.htpasswd ${NGINX}/conf
fi

if [ ! -f ${DATA}/docker-registry.htpasswd ];
then
    echo "use default htpasswd for demo purpose !!"
    cp /app/nginx/docker-registry.htpasswd ${DATA}
fi

${NGINX}/sbin/nginx
