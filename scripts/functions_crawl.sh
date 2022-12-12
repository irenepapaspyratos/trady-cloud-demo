#!/bin/bash

# Create variable file from template
create_crawl_variables() {
    x=$1
    buckets="["
    for s in $1;
    do
        #lower=$(echo "$s" | tr '[:upper:]' '[:lower:]')
        buckets="$buckets, '$s'"
    done
    buckets="$buckets]"

    cp ../data-crawl/templates/variables.py.template ../data-crawl/variables.py
    echo SYMBOL_BUCKETS = ${buckets/'[, '/'['} >> ../data-crawl/variables.py
}
