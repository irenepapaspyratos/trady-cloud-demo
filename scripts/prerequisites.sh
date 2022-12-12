#!/bin/bash

. ./functions_aws.sh
. ./functions_terraform.sh
. ./functions_github.sh
. ./functions_crawl.sh

S3_BUCKET_SRC=trady-cloud-src
S3_BUCKET_TERRAFORM=trady-cloud-terraform
S3_BUCKET_LOGS=trady-cloud-logs
S3_BUCKET_SYMBOLBASE=trady-cloud-symbol
REGION=us-west-2
SYMBOLS='EURUSD EURGBP'

mkdir build 

# Create Environment Variables for Github
create_gh_variables $REGION

# Create string of bucket names for symbols
for s in $SYMBOLS;
    do
        lower=$(echo "$s" | tr '[:upper:]' '[:lower:]')
        SYMBOL_BUCKETS="$SYMBOL_BUCKETS $S3_BUCKET_SYMBOLBASE-$lower"
    done
SYMBOL_BUCKETS="$SYMBOL_BUCKETS $S3_BUCKET_LOGS"

# Create necessary buckets (for Terraform via script as the sandbox does not allow creating them via Terraform itself)
create_aws_s3bucket_multi $REGION $S3_BUCKET_SRC $S3_BUCKET_TERRAFORM $SYMBOL_BUCKETS

# Create from terraform-templates with variables: config.backend & variables
create_tf_variables $REGION $S3_BUCKET_TERRAFORM
create_tf_backend_s3 $REGION $S3_BUCKET_TERRAFORM

# Create Lambda-Layers
#create_aws_lambda_layer crawl

# Create from data-crawler-templates: variables.py
create_crawl_variables "$SYMBOL_BUCKETS"

# Fill build-directory
#mv ../infrastructure/lambda-layer/**/*.zip build

# Upload build-directory to src-bucket
aws s3 cp build s3://$S3_BUCKET_SRC/ --recursive
