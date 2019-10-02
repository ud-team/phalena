#!/bin/bash

declare -a phalena
phalena=($PHALENA)

if [[ ${PHALENA+@} ]]; then
    eval "echo 'finish:$1' >&${phalena[0]}"
fi
