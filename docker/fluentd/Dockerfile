#FROM fluent/fluentd:v0.12
#RUN gem install faraday-net_http -v 2.1.0
#RUN gem install faraday -v 1.10.2
#RUN gem install fluent-plugin-elasticsearch --no-rdoc --no-ri --version 1.9.5
#RUN gem install fluent-plugin-grok-parser --no-rdoc --no-ri --version 1.0.0
#ADD fluent.conf /fluentd/etc
#

FROM fluent/fluentd:v1.12.0-debian-1.0
USER root
RUN gem uninstall -I elasticsearch && gem install elasticsearch -v 7.17.0
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "5.0.3"]
ADD fluent.conf /fluentd/etc
USER fluent
