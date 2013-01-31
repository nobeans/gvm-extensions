#!/bin/bash

function __gvmtool_sync {
    local src_host="$GVM_SYNC_HOST"

    if [[ -z "$src_host" ]]; then
        echo "No host provided."
        __gvmtool_sync_help
        return 1
    fi

    echo "Syncing archives directory from $src_host to localhost"
    rsync -av $src_host:.gvm/archives/ $HOME/.gvm/archives/
}

function __gvmtool_sync_help {
    echo ""
    echo "Usage: gvm sync"
    echo ""
    echo "Environment variables: GVM_SYNC_HOST=[user@]host"
    echo "   user :  user name as source"
    echo "   host :  host address as source"
    echo ""
    echo "eg: GVM_SYNC_HOST=guest@my_notebook; gvm sync"
    echo ""
    echo "  If you once write 'GVM_SYNC_HOST=guest@my_notebook' at ~/.gvm/etc/config,"
    echo "  you can do the above more simply:"
    echo ""
    echo "    gvm sync"
}

