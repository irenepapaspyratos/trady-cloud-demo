#!/bin/bash

# Create variable file from template
create_tf_variables() {
    region=$1
    terra=$2
    src=$3
    runtime=$4
    ranges=$5
    shift;shift;shift;shift;shift;
    ranges_nice="$(echo $ranges | sed 's/:/: /g')"
    sym=' '
    for s in "$@";
        do
            sym="$sym, \"$s\""
        done
    sed -e s/REGION/${region}/ -e s/S3_BUCKET_TERRAFORM/${terra}/ -e s/S3_BUCKET_SRC/${src}/ -e s/COMPATIBLE_RUNTIMES_LAMBDA/${runtime}/  -e s/SYMBOLSRANGES/"$(echo $ranges | sed 's/,/, /')"/ -e s/SYMBOLSLIST/"$(echo $sym | sed 's/, //')"/ \
    < ../infrastructure/templates/variables.tf.template > ../infrastructure/variables.tf
}

# Create configuration file for s3 backend from template
create_tf_backend_s3() {
    sed -e s/REGION/${1}/ -e s/S3_BUCKET_TERRAFORM/${2}/ \
    < ../infrastructure/templates/config.s3.tfbackend.template > ../infrastructure/production_env/config.s3.tfbackend
}
