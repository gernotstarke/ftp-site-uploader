# ![](./icon.png)Dockerized ftp upload

Provides a Docker container which can upload a local directory tree to
a remote ftp server - also available via [Dockerhub](https://hub.docker.com/r/gernotstarke/ftp-uploader/)

It's used e.g. for static sites generated by Jekyll - for sites that don't offer ssh or scp access.

## How it works

* provide a Docker container with [ncftp]() - a powerful ftp client
that can handle directory trees

* the container is supposed to be started by a command like that:

    docker -it run gernotstarke/ftp-uploader <site> <server> <localdir>

* the container starts the script 'upload.sh' upon startup, that queries
  for username and password.

## How to use

Run the container from a shell or script with the following command:

    docker -it run gernotstarke/ftp-uploader:0.2 <site> <server> <localdir>

## License

Free to use and copy.

## Warning:
No guarantees whatsoever, it might not work, it might crash, fail or copy the wrong files.
Use on your own risk. I told you!

## My own documentation

### Build new version

    docker build -t ftp-uploader --force-rm .

### Upload image to [DockerHub](https://hub.docker.com/r/gernotstarke/ftp-uploader/)

Prerequisites: You need to be logged into Dockerhub in your current shell...

1. Tag the freshly build image:

    `docker tag ftp-uploader gernotstarke/ftp-uploader:0.1
1.`

2. Push to Dockerhub:

    `docker push gernotstarke/ftp-uploader`

Optionally provide a version label:

    `docker push gernotstarke/ftp-uploader:0.8`

3. Find [detailed instructions on pushing to Dockerhub](https://docs.docker.com/docker-cloud/builds/push-images/) 
