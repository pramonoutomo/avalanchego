FROM debian:bullseye AS base
RUN apt update && apt install wget tini -y && apt clean

FROM base AS download
ENV version=1.7.7
WORKDIR /app
RUN wget https://github.com/ava-labs/avalanchego/releases/download/v${version}/avalanchego-linux-amd64-v${version}.tar.gz
RUN tar xvf avalanchego-linux-amd64-v${version}.tar.gz
RUN mv avalanchego-v${version} bin

FROM base
WORKDIR /app
COPY --from=download /app/bin/ ./bin/
CMD ["tini", "--", "./bin/avalanchego", "--db-dir", "/app/db", "--http-host", "0.0.0.0"]
EXPOSE 9650
