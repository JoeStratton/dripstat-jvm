#!/bin/sh
set -eu

HEAP_MB="${HEAP_MB:-512}"
JVM_COUNT="${JVM_COUNT:-1}"
OPTS="${JAVA_OPTS:-}"

if ! printf '%s' "$JVM_COUNT" | grep -Eq '^[0-9]+$' || [ "$JVM_COUNT" -lt 1 ]; then
  echo "Invalid JVM_COUNT=${JVM_COUNT} (want positive integer)." >&2
  exit 1
fi

PIDS=""
terminate_children() {
  for pid in $PIDS; do
    kill "$pid" 2>/dev/null || true
  done
  wait || true
}
trap terminate_children TERM INT

if [ "$JVM_COUNT" -eq 1 ]; then
  exec java $OPTS "-Xmx${HEAP_MB}m" "-Xms${HEAP_MB}m" -jar /app/dripstat-jvm.jar "$@"
fi

_i=1
while [ "$_i" -le "$JVM_COUNT" ]; do
  java $OPTS "-Xmx${HEAP_MB}m" "-Xms${HEAP_MB}m" -jar /app/dripstat-jvm.jar "$@" &
  PIDS="$PIDS $!"
  _i=$((_i + 1))
done

wait
