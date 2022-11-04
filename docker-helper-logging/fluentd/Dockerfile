# fluentd/Dockerfile
#FROM fluent/fluentd:v0.12-debian
#FROM fluent/fluentd:v0.12
##RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "1.9.2"]
#RUN gem install faraday-net_http -v 2.1.0
#RUN gem install faraday -v 1.10.2
#RUN gem install fluent-plugin-elasticsearch --no-rdoc --no-ri --version 1.9.5
#RUN gem install elasticsearch -v 7.5.0.pre.pre
    #RUN gem install fluent-plugin-grok-parser --no-rdoc --no-ri --version 1.0.0

#gem install fluent-plugin-elasticsearch  && \



#FROM fluent/fluentd:v1.15-debian-1
##RUN gem install faraday-net_http -v 3.0.1
#RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-rdoc", "--no-ri", "--version", "1.9.2"]

#FROM fluent/fluentd:v1.11-1
#
## Use root account to use apk
#USER root
#
## below RUN includes plugin as examples elasticsearch is not required
## you may customize including plugins as you wish
#RUN apk add --no-cache --update --virtual .build-deps \
#        sudo build-base ruby-dev \
# && sudo gem install fluent-plugin-elasticsearch -v 4.3.2 \
# && sudo gem sources --clear-all \
# && apk del .build-deps \
# && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem
#
#USER fluent

FROM fluent/fluentd:v1.12.0-debian-1.0
USER root
RUN gem uninstall -I elasticsearch && gem install elasticsearch -v 7.17.0
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "5.0.3"]
USER fluent