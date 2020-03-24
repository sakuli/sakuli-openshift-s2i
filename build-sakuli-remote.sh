#!/bin/bash

make build test prepare-release \
    IMAGE_NAME=sakuli-s2i-remote-connection \
    BASE_IMAGE=sakuli-remote-connection \
    BASE_IMAGE_VERSION=2.3.0 \
    TAG_VERSION=2.3.0-1