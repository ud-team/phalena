#!/bin/bash

if [[ $# -eq 0 ]]; then
    flags=(--dirty="+")
else
    flags=("$@")
fi

version=$(git describe --tags --match="v*" "${flags[@]}" | sed -e 's@-\([^-]*\)-\([^-]*\)$@+\1.\2@;s@^v@@;s@%@~@g')

if grep '#define ForRelease 0' MobilePhalena.mm &>/dev/null; then
    version=${version}~srk
fi

define="#define PHALENA_VERSION \"${version}\""
before=$(cat Version.h 2>/dev/null)

if [[ ${before} != ${define} ]]; then
    echo "${define}" >Version.h
fi

echo "${version}"
