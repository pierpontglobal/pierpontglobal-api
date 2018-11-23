FROM docker.elastic.co/logstash/logstash-oss:6.4.0
ADD ./config/logstash.yml /usr/share/logstash/config/
ADD ./pipeline /usr/share/logstash/pipeline
USER root
RUN chown logstash:logstash config/logstash.yml
RUN chown logstash:logstash ./pipeline/*
USER logstash
WORKDIR /usr/share/logstash
EXPOSE 5000

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
