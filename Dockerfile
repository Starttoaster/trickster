FROM golang:alpine as builder
RUN apk add --no-cache bash gcc musl-dev openssl make;

COPY . /go/src/github.com/starttoaster/trickster
WORKDIR /go/src/github.com/starttoaster/trickster

RUN GOOS=linux GOARCH=${GOARCH} CGO_ENABLED=0 make build

FROM alpine:latest

COPY --from=builder /go/src/github.com/trickstercache/trickster/OPATH/trickster /usr/local/bin/trickster
COPY cmd/trickster/conf/example.conf /etc/trickster/trickster.conf
RUN chown nobody /usr/local/bin/trickster
RUN chmod +x /usr/local/bin/trickster

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

USER nobody
ENTRYPOINT ["trickster"]
