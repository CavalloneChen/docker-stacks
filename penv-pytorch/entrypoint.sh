#!bin/bash
set -e

service ssh restart && \
tini -g --
