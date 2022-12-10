#!/bin/bash

# Create variable file from template
create_crawl_variables() {
    cp ../data-crawl/templates/variables.py.template ../data-crawl/variables.py
    BUCKETS_STRING=${1/\' /\'} 
    echo SYMBOL_BUCKETS = [${BUCKETS_STRING// /\', \'}] >> ../data-crawl/variables.py
}
