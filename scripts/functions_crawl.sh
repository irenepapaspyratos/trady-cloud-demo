#!/bin/bash

# Update variable file from template
create_crawl_variables() {
    buckets="["
    for s in "$@";
    do
        buckets="$buckets, '$s'"
    done
    buckets="$buckets]"

    cp ../data-crawl/templates/variables.py.template ../data-crawl/variables.py
    echo SYMBOL_BUCKETS = ${buckets/'[, '/'['} >> ../data-crawl/variables.py
}
