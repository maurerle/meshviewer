FROM library/node:20-alpine as build

ADD package.json /build/
ADD yarn.lock /build/
WORKDIR /build
RUN yarn

ADD . /build/
RUN touch /build/config.json && \
    node_modules/.bin/gulp && \
    rm /build/build/config.json

FROM nginx:1.23-alpine

COPY --from=build /build/build/ /usr/share/nginx/html/
ADD docker/nginx-check-config.sh /docker-entrypoint.d/00-check-config.sh
