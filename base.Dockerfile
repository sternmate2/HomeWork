FROM ruby:2.5.5-alpine3.8

RUN mkdir -p /srv/code

WORKDIR /srv/code

RUN apk add --update \
  curl curl-dev \
  libxml2-dev \
  build-base \
  libxml2-dev \
  libxslt-dev \
  mysql-client \
  mysql-dev \
  tzdata \
  nodejs \
  linux-headers \
  pcre pcre-dev
  
COPY . /srv/code


# install default version of bundler
RUN gem install bundler --version 2.0.1 && \
    gem install passenger --version 6.0.2 && \ 
    # passenger-config compile-agent --auto --optimize && \
    passenger-config install-standalone-runtime --auto --url-root=fake --connect-timeout=1 && \ passenger-config build-native-support
# install default version of passenger



#RUN bundle install -j64
    
    
    

expose 9393

RUN rm -rf /srv/code/public/assets && rake assets:precompile
ENTRYPOINT bundle exec passenger start --port 3000 --log-level 3 --min-instances 5 --max-pool-size 5
