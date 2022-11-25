#!/bin/bash

source functions.sh

S3_BUCKET_SRC=trady-cloud-src
S3_BUCKET_TERRAFORM=trady-cloud-terraform
REGION=us-west-2

# Create buckets necessary for Terraform via script as the sandbox does not allow creating them via Terraform itself
create_s3bucket_multi $REGION $S3_BUCKET_SRC $S3_BUCKET_TERRAFORM

# Create from terraform-templates with variables: main.tf & variables.tf
sed -e s/REGION/${REGION}/ -e s/S3_BUCKET_TERRAFORM/${S3_BUCKET_TERRAFORM}/  < ../infrastructure/templates/main.tf.template > ../infrastructure/main.tf
sed s/REGION/${REGION}/ < ../infrastructure/templates/variables.tf.template > ../infrastructure/variables.tf
