FROM alpine:3.20

RUN apk add --no-cache bash curl jq coreutils tar findutils

RUN export SHELL=/bin/bash \
    && curl -L https://foundry.paradigm.xyz | bash \
    && /root/.foundry/bin/foundryup \
    && ln -sf /root/.foundry/bin/cast /usr/local/bin/cast

RUN curl -L https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz -o /tmp/kubo.tar.gz \
    && tar -xzf /tmp/kubo.tar.gz -C /tmp \
    && /tmp/kubo/install.sh \
    && rm -rf /tmp/kubo /tmp/kubo.tar.gz

WORKDIR /app
COPY . /app
RUN if [ -f /app/agents/publisher-jay/publish.sh ]; then chmod +x /app/agents/publisher-jay/publish.sh; fi
RUN find /app/scripts -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} \; || true

ENTRYPOINT ["/app/agents/publisher-jay/publish.sh"]
