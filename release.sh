#!/usr/bin/env bash

export VERSION="2.3.0"

make release IMAGE_NAME=sakuli-s2i TAG_VERSION=${VERSION}
make release IMAGE_NAME=sakuli-s2i-remote-connection TAG_VERSION=${VERSION}