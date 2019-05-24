FROM golang:latest AS builder
ENV GOPATH=/go
ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN go get github.com/mholt/caddy/caddy

FROM alpine:latest
WORKDIR /app
RUN apk add libcap
RUN addgroup -S caddy && adduser -S caddy -G caddy
ADD ./Caddyfile /app/
ADD index.html /var/www/html/
COPY --from=builder /go/bin/caddy /app/
RUN setcap cap_net_bind_service=+ep /app/caddy
USER caddy
EXPOSE 80
EXPOSE 443
CMD /app/caddy