#!/bin/bash

function __gvmtool_determine_outdated_version {
    local candidate="$1"

    # Resolve local versions
    local local_versions="$(echo $(find "${GVM_DIR}/${candidate}" -maxdepth 1 -mindepth 1 -type d -exec basename '{}' \;) | sed -e "s/ /, /g" )"
    if [ ${#local_versions} -eq 0 ]; then
        return # not installed
    fi

    # Resolve remote default version
    local remote_default_version="$(curl -s "${GVM_SERVICE}/candidates/${candidate}/default")"

    # Check outdated or not
    if [ ! -d "${GVM_DIR}/${candidate}/${remote_default_version}" ]; then
        echo "(${local_versions} < ${remote_default_version})"
    fi
}

function __gvmtool_outdated {
    if [ -n "$1" ]; then
        local candidate="$1"
        local outdated="$(__gvmtool_determine_outdated_version "${candidate}")"
        if [ -n "${outdated}" ]; then
            echo "${candidate} ${outdated}"
        else
            echo "Not using any version of ${candidate}"
        fi
    else
        local candidate
        for candidate in ${GVM_CANDIDATES[@]}; do
            local outdated="$(__gvmtool_determine_outdated_version "${candidate}")"
            if [ -n "${outdated}" ]; then
                echo "${candidate} ${outdated}"
            fi
        done
    fi
}
