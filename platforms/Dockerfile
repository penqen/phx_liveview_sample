FROM elixir:1.14.2-alpine as base

ARG PHX_VERSION=1.7.2

RUN apk --no-cache add \
  build-base \
  inotify-tools \
  && mix local.hex --force \
  && mix local.rebar --force

FROM base as dev

RUN mix archive.install hex phx_new ${PHX_VERSION} --force

CMD [ "sh" ]