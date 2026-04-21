FROM alpine:3.20

RUN apk add --no-cache bash curl coreutils jq tar findutils

RUN curl -L https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz -o /tmp/kubo.tar.gz \
    && tar -xzf /tmp/kubo.tar.gz -C /tmp \
    && /tmp/kubo/install.sh \
    && rm -rf /tmp/kubo /tmp/kubo.tar.gz

WORKDIR /app
COPY . /app
RUN if [ -f /app/agents/verifier-jay/watch.sh ]; then chmod +x /app/agents/verifier-jay/watch.sh; fi
RUN if [ -f /app/agents/verifier-jay/entrypoint.sh ]; then chmod +x /app/agents/verifier-jay/entrypoint.sh; fi
RUN find /app/scripts -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} \; || true
RUN find /app/tests -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} \; || true

ENTRYPOINT ["/app/agents/verifier-jay/entrypoint.sh"]
