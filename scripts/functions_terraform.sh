#!/bin/bash

# Create variable file from template
create_tf_variables {
    sed -e s/REGION/${1}/ -e s/S3_BUCKET_TERRAFORM/${2}/ \
    < ../infrastructure/templates/variables.tf.template > ../infrastructure/variables.tf
}

# Create configuration file for s3 backend from template
create_tf_backend_s3 {
    sed -e s/REGION/${1}/ -e s/S3_BUCKET_TERRAFORM/${2}/ \
    < ../infrastructure/templates/config.s3.tfbackend.template > ../infrastructure/config.s3.tfbackend
}
