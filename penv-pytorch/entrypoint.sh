#!bin/bash
set -e

exec service ssh restart && \
tini -g --
