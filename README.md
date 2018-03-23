# ![](./icon.png | width=100) Upload a locally created website to ftp server

Provides a Docker container which can upload a local directory tree to
a remote ftp server.

It's used e.g. for static sites generated by Jekyll

## How it works

* provide a Docker container with [ncftp]() - a powerful ftp client
that can handle directory trees

* this container expects ftp username and password to be given upon startup.

## Prerequisites
