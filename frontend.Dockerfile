FROM --platform=linux/amd64 mhart/alpine-node:16 as builder

LABEL \
    org.label-schema.name="frontend" \
    org.label-schema.vcs-url="https://github.com/gseriche/master-container-tema-03.git"


WORKDIR /frontend

COPY . /frontend/.

RUN apk add --no-cache binutils=2.35.2-r1 && \
    npm config set update-notifier false && \
    npm ci --no-audit --production && \
    mkdir -p node_modules/.cache && chmod -R 777 node_modules/.cache


FROM --platform=linux/amd64 node:16-alpine3.16
WORKDIR /frontend
# COPY --from=builder /usr/bin/node /usr/bin/
# COPY --from=builder /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/
COPY --from=builder /frontend /frontend

USER node

ENV PORT=8081 \
    NODE_ENV=${NODE_ENV}} \
    MAX_EVENT_LOOP_DELAY=1000 \
    MAX_RSS_BYTES=0 \
    MAX_HEAP_USED_BYTES=0 \
    MAX_AGE=86400 \
    DB_HOST=${DB_HOST} \
    DB_USER=${DB_USER} \
    DB_PASSWORD=${DB_PASSWORD} \
    DB_NAME=${DB_NAME} \
    DB_PORT=${DB_PORT} \
    NODE_DOCKER_PORT=${NODE_DOCKER_PORT}

EXPOSE $PORT

CMD ["npm", "start"]