FROM docker.elastic.co/beats/filebeat-oss:6.4.0
RUN filebeat modules enable postgresql
RUN filebeat modules enable nginx
RUN filebeat modules enable redis