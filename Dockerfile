FROM dungvo/java:latest
MAINTAINER Dung Chi Vo [cdung.vo@gmail]

USER root

# noninteractive Debian frontend
ENV DEBIAN_FRONTEND noninteractive

# Elasticsearch version
ENV ES_VERSION elasticsearch-1.4.2
ENV ES_PACKAGE $ES_VERSION.tar.gz

# URL Download
ENV URL https://download.elasticsearch.org/elasticsearch/elasticsearch

# Install gettext
RUN apt-get update && apt-get install -yq gettext procps

# Install ElasticSearch.
RUN wget $URL/$ES_PACKAGE -O /tmp/$ES_PACKAGE \
 && cd /tmp \
 && tar xzf $ES_PACKAGE \
 && rm -f $ES_PACKAGE \
 && mv /tmp/$ES_VERSION /opt/elasticsearch

ENV ES_HOME /opt/elasticsearch
ENV PATH $PATH:$ES_HOME/bin

# Install ES as a service
RUN cd $ES_HOME/bin \
 && git clone https://github.com/elasticsearch/elasticsearch-servicewrapper.git \
 && mv elasticsearch-servicewrapper/service ./ \
 && rm -rf elasticsearch-servicewrapper \
 && ./service/elasticsearch install

# Configure ES service
RUN sed -i "s|set.default.ES_HOME=.*|set.default.ES_HOME=$ES_HOME|" $ES_HOME/bin/service/elasticsearch.conf \
 && sed -i "s|set.default.ES_HEAP_SIZE=.*|set.default.ES_HEAP_SIZE=@ES_HEAP_SIZE|" $ES_HOME/bin/service/elasticsearch.conf \
 && sed -i "s|PIDDIR=\"\.\"|PIDDIR=\"/var/elasticsearch/pids\"|" $ES_HOME/bin/service/elasticsearch \
 && sed -i "s|#RUN_AS_USER=|RUN_AS_USER=root|" $ES_HOME/bin/service/elasticsearch \
 && mkdir $ES_HOME/logs \
 && mkdir -p /var/elasticsearch/pids


# Configure ES
RUN sed -i "s|#cluster.name: elasticsearch|cluster.name: @ES_CLUSTER_NAME|" $ES_HOME/config/elasticsearch.yml \
 && sed -i "s|#path.logs: /path/to/logs|path.logs: /var/log/elasticsearch|" $ES_HOME/config/elasticsearch.yml \
 && sed -i "s|#path.data: /path/to/data|path.data: /var/data/elasticsearch|" $ES_HOME/config/elasticsearch.yml \
 && sed -i -e "0,/#node.name:.*/{s/#node.name:.*/node.name: @ES_NODE_NAME/}" $ES_HOME/config/elasticsearch.yml \
 && sed -i -e "0,/#node.master: true/{s/#node.master: true/node.master: @NODE_MASTER/}" $ES_HOME/config/elasticsearch.yml \
 && sed -i -e "0,/#node.data: true/{s/#node.data: true/node.data: @NODE_DATA/}" $ES_HOME/config/elasticsearch.yml \
 && sed -i -e "0,/#index.number_of_shards: 5/{s/#index.number_of_shards: 5/index.number_of_shards: @NUMBER_OF_SHARDS/}" $ES_HOME/config/elasticsearch.yml \
 && sed -i -e "0,/#index.number_of_replicas: 1/{s/#index.number_of_replicas: 1/index.number_of_replicas: @NUMBER_OF_REPLICAS/}" $ES_HOME/config/elasticsearch.yml \
 && sed -i "s|#bootstrap.mlockall: true|bootstrap.mlockall: @BOOTSTRAP_MLOCKALL|" $ES_HOME/config/elasticsearch.yml \
 && mkdir -p /var/log/elasticsearch \
 && mkdir -p /var/data/elasticsearch

# Define mountable directories.
VOLUME ["/var/data/elasticsearch"]
VOLUME ["/var/log/elasticsearch"]

ADD start-elasticsearch.sh /usr/local/bin/start-elasticsearch.sh
RUN chmod +x /usr/local/bin/start-elasticsearch.sh

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300

WORKDIR $ES_HOME
# Define default command.
CMD start-elasticsearch.sh


