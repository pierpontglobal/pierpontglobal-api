FROM docker.elastic.co/kibana/kibana-oss:6.4.0
ADD ./config/kibana.yml /usr/share/kibana/config/
USER root
RUN chown kibana:kibana config/kibana.yml
USER kibana
WORKDIR /usr/share/kibana
EXPOSE 5601