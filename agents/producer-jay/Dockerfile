FROM alpine:3.20

RUN apk add --no-cache bash jq curl coreutils tar findutils

RUN curl -L https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz -o /tmp/kubo.tar.gz \
    && tar -xzf /tmp/kubo.tar.gz -C /tmp \
    && /tmp/kubo/install.sh \
    && rm -rf /tmp/kubo /tmp/kubo.tar.gz

WORKDIR /app
COPY . /app
RUN test -f /app/agents/producer-jay/produce.sh && chmod +x /app/agents/producer-jay/produce.sh
RUN find /app/scripts -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} \; || true
RUN find /app/tests -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} \; || true

ENTRYPOINT ["/app/agents/producer-jay/produce.sh"]
