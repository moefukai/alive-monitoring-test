FROM nginx:1.20-alpine
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

ENV TZ='Asia/Tokyo'

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++

# nginx config file
COPY ./infra/docker/production/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./laravel/public /work/laravel/public

WORKDIR /work/laravel