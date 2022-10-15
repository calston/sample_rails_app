FROM node:16-alpine AS node
WORKDIR /sample_rails_application
COPY package.json /sample_rails_application/package.json
COPY yarn.lock /sample_rails_application/yarn.lock
RUN yarn install --check-files

FROM ruby:2.7-alpine
RUN apk update && apk add --no-cache \
    tzdata \
    build-base \
    git \
    shared-mime-info \
    openssl \
    build-base \
    libpq-dev \
    postgresql-client \
    sqlite-dev
RUN gem install bundler -v '2.2.15'
RUN mkdir /sample_rails_application
WORKDIR /sample_rails_application

COPY Gemfile /sample_rails_application/Gemfile
COPY Gemfile.lock /sample_rails_application/Gemfile.lock
COPY --from=node /sample_rails_application/node_modules ./node_modules

RUN bundle install

COPY . /sample_rails_application

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
