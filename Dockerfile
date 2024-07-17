ARG TARGETOS
ARG TARGETARCH

FROM quay.io/projectquay/golang:1.20 as builder
WORKDIR /go/src/app
COPY . .
RUN TARGETOS=${TARGETOS} TARGETARCH=${TARGETOS} make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT [ "./kbot", "start" ]
