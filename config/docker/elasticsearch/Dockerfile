FROM docker.elastic.co/elasticsearch/elasticsearch-oss:6.4.0
ENV REGION us-east-1
ADD elasticsearch.yml /usr/share/elasticsearch/config/
USER root
RUN chown elasticsearch:elasticsearch config/elasticsearch.yml
USER elasticsearch
WORKDIR /usr/share/elasticsearch
RUN sed -e '/^-Xm/s/^/#/g' -i /usr/share/elasticsearch/config/jvm.options
EXPOSE 9200