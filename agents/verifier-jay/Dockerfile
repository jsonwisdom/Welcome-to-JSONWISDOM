FROM alpine:3.20

RUN apk add --no-cache bash curl coreutils jq git libgcc libstdc++ tar

RUN curl -L https://dist.ipfs.tech/kubo/v0.29.0/kubo_v0.29.0_linux-amd64.tar.gz -o /tmp/kubo.tar.gz \
    && tar -xzf /tmp/kubo.tar.gz -C /tmp \
    && /tmp/kubo/install.sh \
    && rm -rf /tmp/kubo /tmp/kubo.tar.gz

RUN curl -L https://foundry.paradigm.xyz | bash \
    && /root/.foundry/bin/foundryup

ENV PATH="/root/.foundry/bin:${PATH}"

WORKDIR /app
COPY . /app
RUN chmod +x /app/agents/verifier-jay/watch.sh /app/agents/verifier-jay/entrypoint.sh /app/tests/test-integrity.sh /app/scripts/*.sh

ENTRYPOINT ["/app/agents/verifier-jay/entrypoint.sh"]
