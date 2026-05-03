# dripstat-jvm

Tiny [Spring Boot](https://spring.io/projects/spring-boot) **4.1.x** (currently `4.1.0-M4` until `4.1.0` GA lands on Maven Central) on **Java 25**, meant to appear in [DripStat](https://dropstatgame.solant.me/). The workload is intentional no-op: Spring starts a normal application context while you size the heap with **`-Xmx`/`-Xms`** so the game can read heap capacity.

- **Source:** [github.com/JoeStratton/dripstat-jvm](https://github.com/JoeStratton/dripstat-jvm)
- **Image:** [hub.docker.com/r/j123ss/dripstat-jvm](https://hub.docker.com/r/j123ss/dripstat-jvm)

## Configure heap

| Variable    | Default | Meaning |
|------------|---------|---------|
| `HEAP_MB`  | `512`   | Heap size in **mebibytes** for each JVM (`-Xmx` and `-Xms`). |
| `JVM_COUNT`| `1`     | How many independent Spring Boot processes to run **in this container**. |
| `JAVA_OPTS`| _(empty)_ | Extra JVM flags appended before `-jar`. |

Example:

```bash
docker run --rm -e HEAP_MB=1024 -e JVM_COUNT=3 j123ss/dripstat-jvm:latest
```

## Multiple JVMs

Increase **`JVM_COUNT`** to run several Java processes in one container, or add more Unraid containers from the same template (each with its own heap settings).

## Build

```bash
docker build -t j123ss/dripstat-jvm:local .
```

Runtime image is **Eclipse Temurin 25 JRE on Alpine**; the build stage uses Maven and is discarded.

## CI and registry

Pushes to **`main`** and version tags **`v*`** build multi-arch images (`linux/amd64`, `linux/arm64`) and push to Docker Hub as **`${DOCKERHUB_USERNAME}/dripstat-jvm`** (same pattern as [quai-node-unofficial](https://github.com/JoeStratton/quai-node-unofficial)). Configure the GitHub repo:

- **Variables → Actions:** `DOCKERHUB_USERNAME` (for example **`j123ss`**)
- **Secrets → Actions:** **`DOCKERHUB_TOKEN`** — a Docker Hub [access token](https://hub.docker.com/settings/security) (or the account password); if this secret is missing or empty, login fails with *password required*.

## Unraid

Use the template URL: [raw.githubusercontent.com/JoeStratton/dripstat-jvm/main/unraid/dripstat-jvm.xml](https://raw.githubusercontent.com/JoeStratton/dripstat-jvm/main/unraid/dripstat-jvm.xml) in *Add Container* → *Install another application*, or import **`unraid/dripstat-jvm.xml`**. There is no Web UI; only environment variables apply.
