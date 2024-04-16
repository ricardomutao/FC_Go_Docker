# Primeiro estágio que estamos chamando de "builder"
FROM golang:1.22.2 AS builder

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go/go.mod go/go.sum ./
RUN go mod download && go mod verify

COPY go/ .
# Faz com que o resultado se torne um executável
RUN CGO_ENABLED=0 GOOS=linux go build -o api main.go



FROM scratch
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/api ./

EXPOSE 8000

CMD ["./api"]

