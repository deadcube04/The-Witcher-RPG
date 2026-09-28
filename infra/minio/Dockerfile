FROM golang:1.26.6-bookworm AS build
ARG MINIO_REVISION=7aac2a2c5b7c882e68c1ce017d8256be2feea27f
WORKDIR /src
RUN --mount=type=secret,id=build_ca,required=false if [ -f /run/secrets/build_ca ]; then cat /run/secrets/build_ca >> /etc/ssl/certs/ca-certificates.crt; fi
RUN curl -fsSL https://codeload.github.com/minio/minio/tar.gz/${MINIO_REVISION} | tar -xz --strip-components=1
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build CGO_ENABLED=0 go build -trimpath -o /minio .
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*
COPY --from=build /minio /usr/local/bin/minio
COPY --from=build /src/LICENSE /licenses/minio-LICENSE
EXPOSE 9000 9001
ENTRYPOINT ["minio"]
