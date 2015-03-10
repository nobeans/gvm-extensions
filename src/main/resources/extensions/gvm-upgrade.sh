#!/bin/bash

function __gvmtool_upgrade {
    gvm outdated | grep -E "^[a-zA-Z_-]+ \(.+\)$" | awk '{print $1}' | xargs -I{} sh -c ". ~/.gvm/bin/gvm-init.sh; yes | gvm install {}"
}
