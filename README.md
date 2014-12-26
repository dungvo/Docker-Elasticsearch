Docker Elasticsearch
====================

## Usage
```
docker run -d \
       -p 9200:9200 \
       -p 9300:9300  
       -e "ES_HEAP_SIZE=512"  \  
       -e "ES_CLUSTER_NAME=elasticsearch-cluster" \  
       -e "ES_NODE_NAME=node-one" \  
       -e "NODE_MASTER=true" \
       -e "NODE_DATA=true"  \  
       -e "NUMBER_OF_SHARDS=5" \  
       -e "NUMBER_OF_REPLICAS=1" \  
       -e "BOOTSTRAP_MLOCKALL=true" \  
       dungvo/elasticsearch
```

## DONE.
