FROM alpine:3.20

RUN apk add --no-cache bash curl coreutils jq

WORKDIR /app
COPY watch.sh /app/watch.sh
RUN chmod +x /app/watch.sh

CMD ["/app/watch.sh"]
