FROM golang:1.22.1-bullseye as deploy-builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -trimpath -ldflag "-w -s" -o app

FROM debian:bullseye-slim as deploy

RUN apt-get update

COPY --from=deploy-builder /app/app .

CMD ["./app"]

FROM golang:1.22.1 as dev

WORKDIR /app

RUN go install github.com/cosmtrek/air@latest

CMD ["air"]
