# dripstat-jvm

Tiny [Spring Boot](https://spring.io/projects/spring-boot) JVM image meant to appear in [DripStat](https://dropstatgame.solant.me/). The workload is intentional no-op: Spring starts a normal application context while you size the heap with **`-Xmx`/`-Xms`** so the game can read heap capacity.

## Configure heap

| Variable    | Default | Meaning |
|------------|---------|---------|
| `HEAP_MB`  | `512`   | Heap size in **mebibytes** for each JVM (`-Xmx` and `-Xms`). |
| `JVM_COUNT`| `1`     | How many independent Spring Boot processes to run **in this container**. |
| `JAVA_OPTS`| _(empty)_ | Extra JVM flags appended before `-jar`. |

Example:

```bash
docker run --rm -e HEAP_MB=1024 -e JVM_COUNT=3 dripstat-jvm
```

## Multiple JVMs (Docker Compose)

Each replica is one container; scale for several processes with the same heap:

```bash
docker compose up -d --build --scale dripstat-jvm=5
```

Override heap in `docker-compose.yml` or with `environment:` on the service.

## Build

```bash
docker build -t dripstat-jvm .
```

Runtime image is **Eclipse Temurin 21 JRE on Alpine**; the build stage uses Maven and is discarded.
