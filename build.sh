#!/bin/bash
GOLANG="1.11-alpine"
VERSION="v1.3.1"

function build {
	if [[ ! -e ${1} ]]; then
		docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e CGO_ENABLED=0 -e GOOS=${GOOS} -e GOARCH=${GOARCH} golang:${GOLANG} /bin/sh -x -c "apk add --no-cache git gcc musl-dev; go build -ldflags='-s -w' -v -o ${1}"
	fi
}

for GOOS in linux darwin windows; do
	for GOARCH in 386 amd64; do
			build terraform-provider-influxdb_${VERSION}.${GOOS}_${GOARCH} &
	done
done
for GOOS in linux; do
	for GOARCH in arm; do
		build terraform-provider-influxdb_${VERSION}.${GOOS}_${GOARCH} &
	done
done
wait
