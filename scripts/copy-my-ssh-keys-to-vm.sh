#!/usr/bin/env bash
set -x

BASE_DIR=$(cd "`dirname "$0"`"; pwd)

cd "$BASE_DIR"
tar cvfz ../tmp/ssh-keys.tar.gz -C ~/.ssh id_rsa{,.pub}

cd "$BASE_DIR"/..
vagrant ssh -c 'tar xvfz /vagrant/tmp/ssh-keys.tar.gz -C ~/.ssh'
