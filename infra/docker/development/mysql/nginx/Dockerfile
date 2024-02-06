FROM node:16.13-alpine as node

WORKDIR /build
COPY ./laravel .
COPY ./laravel/.env .env
ARG VITE_APP_URL
RUN npm install

FROM nginx:1.20-alpine
SHELL ["/bin/ash", "-oeux", "pipefail", "-c"]

ENV TZ='Asia/Tokyo'

RUN apk update && \
  apk add --update --no-cache --virtual=.build-dependencies g++

# nginx config file
COPY /infra/docker/production/nginx/default.conf /etc/nginx/conf.d/default.conf

WORKDIR /work/laravel
COPY --from=node /build/public ./public

