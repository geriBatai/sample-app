FROM golang:stretch
WORKDIR /go/src/app
COPY . .
ENV CGO_ENABLED=0
RUN go build -o /sample-app

FROM scratch
COPY --from=0 /sample-app /sample-app
ENTRYPOINT ["/sample-app"]
