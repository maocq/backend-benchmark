##
## Build
##
FROM golang:1.18.4-alpine3.16 AS build
WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download
 
COPY . .
RUN go build -o /go-ms

 
##
## Deploy
##
FROM alpine:3.16
WORKDIR /

COPY --from=build /go-ms /go-ms
CMD ["/go-ms"]