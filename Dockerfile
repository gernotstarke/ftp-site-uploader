# build with "docker build -t ftp-uploader --force-rm ."
FROM alpine

LABEL version="0.8.0"
LABEL description="upload generated (usually jekyll) site to ftp server"
LABEL vendor="Gernot Starke"

COPY upload.sh .

RUN apk update && \
    apk add bash ncftp ncurses

ENTRYPOINT ["./upload.sh"]
