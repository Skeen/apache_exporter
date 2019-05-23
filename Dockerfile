FROM golang:1.11

WORKDIR $GOPATH/src/github.com/Skeen/apache_exporter
COPY . .

RUN go get -d -v .
RUN go install -v .

EXPOSE 9117

ENTRYPOINT ["apache_exporter"]
