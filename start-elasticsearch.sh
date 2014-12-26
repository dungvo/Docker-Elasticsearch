#!/bin/bash

ES_HEAP_SIZE=${ES_HEAP_SIZE:-true}
ES_CLUSTER_NAME=${ES_CLUSTER_NAME:-elasticsearch}
ES_NODE_NAME=${ES_NODE_NAME:-localhost}
NODE_MASTER=${NODE_MASTER:-true}
NODE_DATA=${NODE_DATA:-true}
NUMBER_OF_SHARDS=${NUMBER_OF_SHARDS:-5}
NUMBER_OF_REPLICAS=${NUMBER_OF_REPLICAS:-1}
BOOTSTRAP_MLOCKALL=${BOOTSTRAP_MLOCKALL:-false}

elasticsearch_configure='/opt/elasticsearch/config/elasticsearch.yml'
elasticsearch_service_configure='/opt/elasticsearch/config/elasticsearch.yml'

sed -i -e "s|@ES_HEAP_SIZE|${ES_HEAP_SIZE}|g" $elasticsearch_service_configure

sed -i -e "s|@ES_CLUSTER_NAME|${ES_CLUSTER_NAME}|g" $elasticsearch_configure
sed -i -e "s|@ES_NODE_NAME|${ES_NODE_NAME}|g" $elasticsearch_configure
sed -i -e "s|@NODE_MASTER|${NODE_MASTER}|g" $elasticsearch_configure
sed -i -e "s|@NODE_DATA|${NODE_DATA}|g" $elasticsearch_configure
sed -i -e "s|@NUMBER_OF_SHARDS|${NUMBER_OF_SHARDS}|g" $elasticsearch_configure
sed -i -e "s|@NUMBER_OF_REPLICAS|${NUMBER_OF_REPLICAS}|g" $elasticsearch_configure
sed -i -e "s|@BOOTSTRAP_MLOCKALL|${BOOTSTRAP_MLOCKALL}|g" $elasticsearch_configure

service elasticsearch console
