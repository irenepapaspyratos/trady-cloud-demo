#!/bin/bash

# Update variable file from template
create_crawl_variables() {
    base=$1
    lake=$2
    logs=$3
    shift;shift;shift
    buckets="["
    for b in "$@";
    do
        buckets="$buckets, '$b'"
    done
    buckets="$buckets]"

    cp ../modules/data-crawl/templates/variables.py.template ../modules/data-crawl/variables.py
    echo "S3_BUCKET_SYMBOLBASE = '$base'" >> ../modules/data-crawl/variables.py
    echo "S3_BUCKET_SYMBOL_LAKE = '$lake'" >> ../modules/data-crawl/variables.py
    echo "S3_BUCKET_SYMBOL_LOGS = '$logs'" >> ../modules/data-crawl/variables.py
    echo "SYMBOL_BUCKETS = $buckets"  | sed -r 's/\[, /\[/' >> ../modules/data-crawl/variables.py
}
