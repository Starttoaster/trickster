FROM golang:1 AS builder

COPY . /go/src/github.com/trickstercache/trickster
WORKDIR /go/src/github.com/trickstercache/trickster

RUN CGO_ENABLED=0 go build -o ./OPATH/trickster -a -v cmd/trickster/*.go

FROM gcr.io/distroless/static-debian12

COPY --from=builder /go/src/github.com/trickstercache/trickster/OPATH/trickster /usr/local/bin/trickster
COPY cmd/trickster/conf/example.conf /etc/trickster/trickster.conf
ENTRYPOINT ["trickster"]
