FROM golang:latest AS build

ARG lambda

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -tags lambda.norpc -o ./main lambda/${lambda}/main.go

# Use clean img for running
FROM public.ecr.aws/lambda/provided:al2023 AS run

COPY --from=build /app/main ./main 

ENTRYPOINT  ["./main"]
