#!/bin/bash

# Update variable file from template
create_crawl_variables() {
    buckets="["
    for s in "$@";
    do
        buckets="$buckets, '$s'"
    done
    buckets="$buckets]"

    cp ../modules/data-crawl/templates/variables.py.template ../modules/data-crawl/variables.py
    echo "SYMBOL_BUCKETS = $buckets"  | sed -r 's/\[, /\[/' >> ../modules/data-crawl/variables.py
}
