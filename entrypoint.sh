#!/bin/bash
groupmod --gid $GID user
usermod --uid $UID --gid $GID user
export HOME=/home/user
chown -R user:user /home/user
mkdir -p /workdir
chown -R user:user /workdir

exec gosu user "$@"