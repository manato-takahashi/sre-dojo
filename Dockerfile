# ---- ビルドステージ ----
FROM golang:1.26-alpine AS builder

WORKDIR /build
COPY app/go.mod ./
RUN go mod download
COPY app/ ./

RUN CGO_ENABLED=0 go build -ldflags="-s -w -X main.version=1.0.0" -o server .

# ---- 実行ステージ ----
FROM scratch

COPY --from=builder /build/server /server

EXPOSE 8080
ENTRYPOINT ["/server"]
