#!/bin/bash

shopt -s globstar && \
TMPSR=$(mktemp -d) && \
zypper --pkg-cache-dir=${TMPSR} download openSUSE-repos-Slowroll && \
zypper modifyrepo --all --disable && \
zypper install -y ${TMPSR}/**/openSUSE-repos-Slowroll*.rpm && \
zypper dist-upgrade -y
