ARG ELK_VERSION
FROM docker.elastic.co/beats/filebeat-oss:${ELK_VERSION}
RUN filebeat modules enable postgresql
RUN filebeat modules enable nginx
RUN filebeat modules enable redis