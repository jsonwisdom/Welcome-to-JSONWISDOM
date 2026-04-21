FROM alpine:3.20

RUN apk add --no-cache bash jq curl coreutils tar

RUN curl -L https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz -o /tmp/kubo.tar.gz \
    && tar -xzf /tmp/kubo.tar.gz -C /tmp \
    && /tmp/kubo/install.sh \
    && rm -rf /tmp/kubo /tmp/kubo.tar.gz

WORKDIR /app
COPY . /app
RUN chmod +x /app/agents/producer-jay/produce.sh /app/scripts/*.sh /app/tests/test-integrity.sh

ENTRYPOINT ["/app/agents/producer-jay/produce.sh"]
