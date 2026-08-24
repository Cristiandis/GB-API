FROM rust:1-slim AS builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --create-home appuser
WORKDIR /app
COPY --from=builder /app/target/release/GB-API /usr/local/bin/GB-API
USER appuser
EXPOSE 3000
ENTRYPOINT ["GB-API"]
