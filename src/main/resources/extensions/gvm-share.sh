#!/bin/bash

function __gvmtool_share {
    CANDIDATE="$1"
    VERSION="$2"

    if [[ -z "$CANDIDATE" ]]; then
        echo "No candidate provided."
        __gvmtool_share_help
        return 1
    fi

    if [[ -z "$VERSION" ]]; then
        echo "No version provided."
        __gvmtool_share_help
        return 1
    fi

    local src_path="${GVM_DIR}/archives/${CANDIDATE}-${VERSION}.zip"
    if [[ ! -f "$src_path" ]]; then
        echo "Stop! The archive file of ${CANDIDATE} ${VERSION} is not downloaded yet."
        __gvmtool_share_help
        return 1
    fi

    local dest_path=$(__gvmtool_share_${CANDIDATE}_dist_path $VERSION)
    echo "Copying $src_path to $dest_path"
    mkdir -p $(dirname $dest_path)
    cp "$src_path" "$dest_path"
}

function __gvmtool_share_help {
    echo ""
    echo "Usage: gvm share <candidate> [version]"
    echo ""
    echo "   candidate  :"
    echo "      grails  -  share a downloaded archive file with grails as wrapper"
    echo "      gradle  -  share a downloaded archive file with gradle as wrapper"
    echo "   version    :  N.N[.N] (required)"
    echo ""
    echo "eg: gvm share grails 2.2.0"
}

function __gvmtool_share_grails_dist_path {
    local version=$1
    echo "$HOME/.grails/wrapper/grails-${version}-download.zip"
}

function __gvmtool_share_gradle_dist_path {
    local version=$1
    local basename=gradle-${version}-bin
    local uri=http://services.gradle.org/distributions/${basename}.zip
    local hashed_uri_16=$(md5 -qs $uri)
    local hashed_uri_32=$(__gvmtool_share_radix_16_to_32 $hashed_uri_16)
    echo "$HOME/.gradle/wrapper/dists/${basename}/${hashed_uri_32}/${basename}.zip"
}

function __gvmtool_share_radix_16_to_32 {
    local total_16=$1
    local upper_16=$(echo $total_16 | sed -E 's/.{16}$//')
    local lower_16=$(echo $total_16 | sed -E 's/^.{16}//')
    local upper_10=$(__gvmtool_share_radix_16_to_10 $upper_16)
    local lower_10=$(__gvmtool_share_radix_16_to_10 $lower_16)
    local total_32=$(echo "obase=32; $upper_10 * 16^16 + $lower_10" | env BC_LINE_LENGTH=200 bc)
    for t in $total_32; do
        __gvmtool_share_radix_32_to_char $(expr $t + 0)
    done
}

function __gvmtool_share_radix_16_to_10 {
    declare -i l=16#$1
    printf '%u\n' $l
}

function __gvmtool_share_radix_32_to_char {
    declare -i num=$1
      if [ $num -ge 0 ] && [ $num -le 15 ]; then printf '%x' $num
    elif [ $num -eq 16 ]; then echo -n 'g'
    elif [ $num -eq 17 ]; then echo -n 'h'
    elif [ $num -eq 18 ]; then echo -n 'i'
    elif [ $num -eq 19 ]; then echo -n 'j'
    elif [ $num -eq 20 ]; then echo -n 'k'
    elif [ $num -eq 21 ]; then echo -n 'l'
    elif [ $num -eq 22 ]; then echo -n 'm'
    elif [ $num -eq 23 ]; then echo -n 'n'
    elif [ $num -eq 24 ]; then echo -n 'o'
    elif [ $num -eq 25 ]; then echo -n 'p'
    elif [ $num -eq 26 ]; then echo -n 'q'
    elif [ $num -eq 27 ]; then echo -n 'r'
    elif [ $num -eq 28 ]; then echo -n 's'
    elif [ $num -eq 29 ]; then echo -n 't'
    elif [ $num -eq 30 ]; then echo -n 'u'
    elif [ $num -eq 31 ]; then echo -n 'v'
    elif [ $num -eq 32 ]; then echo -n 'w'
    elif [ $num -eq 33 ]; then echo -n 'x'
    elif [ $num -eq 34 ]; then echo -n 'y'
    elif [ $num -eq 35 ]; then echo -n 'z'
    else echo -n '*'
    fi
}

