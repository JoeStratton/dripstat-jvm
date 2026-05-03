# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-25-alpine AS builder
WORKDIR /workspace

COPY pom.xml .
COPY src ./src

RUN mvn -q -B -DskipTests package

FROM eclipse-temurin:25-jre-alpine

LABEL org.opencontainers.image.title="dripstat-jvm" \
      org.opencontainers.image.description="Minimal Spring Boot JVM for DripStat heap registration" \
      org.opencontainers.image.source="https://github.com/JoeStratton/dripstat-jvm" \
      org.opencontainers.image.url="https://github.com/JoeStratton/dripstat-jvm"

RUN addgroup -S drip && adduser -S -G drip -u 65532 drip

WORKDIR /app

COPY --from=builder /workspace/target/dripstat-jvm.jar /app/dripstat-jvm.jar
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
    && chown -R drip:drip /app

USER drip:drip

ENV HEAP_MB=512
ENV JVM_COUNT=1

ENTRYPOINT ["/entrypoint.sh"]
