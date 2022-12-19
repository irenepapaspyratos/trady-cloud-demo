#!/bin/bash

. ./functions_aws.sh
. ./functions_terraform.sh
. ./functions_github.sh
. ./functions_crawl.sh
. ./ranges.sh

NAME_BASE=trady-cloud
SYMBOLS='EURUSD eurgbp'
REGION=us-west-2
COMPATIBLE_RUNTIMES_LAMBDA='python3.9'


S3_BUCKET_SRC=$NAME_BASE-src
S3_BUCKET_TERRAFORM=$NAME_BASE-terraform
S3_BUCKET_SYMBOLBASE=$NAME_BASE-symbol
S3_BUCKET_SYMBOL_LAKE=$S3_BUCKET_SYMBOLBASE-lake
S3_BUCKET_SYMBOL_LOGS=$S3_BUCKET_SYMBOLBASE-logs
SYMBOLS_LOWER=$(echo "$SYMBOLS" | tr '[:upper:]' '[:lower:]')
RANGES_DICT="$(create_ranges)"


# Create build folder
mkdir -p ../build 

# Create Environment Variables for Github
create_gh_variables $REGION

# Create string of bucket names for symbols
for s in $SYMBOLS_LOWER;
    do
        SYMBOL_BUCKETS="$SYMBOL_BUCKETS $S3_BUCKET_SYMBOLBASE-$s"
    done
CREATE_BUCKETS="$S3_BUCKET_SRC $S3_BUCKET_TERRAFORM $S3_BUCKET_SYMBOL_LAKE $S3_BUCKET_SYMBOL_LOGS $SYMBOL_BUCKETS"

# Create necessary buckets (for Terraform via script as the sandbox does not allow creating them via Terraform itself)
create_aws_s3bucket_multi $REGION $CREATE_BUCKETS

# Create from terraform-templates with variables: config.backend & variables
create_tf_variables $REGION $S3_BUCKET_TERRAFORM $S3_BUCKET_SRC $COMPATIBLE_RUNTIMES_LAMBDA $RANGES_DICT $SYMBOLS_LOWER
create_tf_backend_s3 $REGION $S3_BUCKET_TERRAFORM

# Create Lambda and Layers
create_aws_lambda_layer
create_aws_lambda

# Create from data-crawler-templates: variables.py
create_crawl_variables $S3_BUCKET_SYMBOLBASE $S3_BUCKET_SYMBOL_LAKE $S3_BUCKET_SYMBOL_LOGS $SYMBOL_BUCKETS

# Fill build-directory
mv ../infrastructure/source/lambda-layers/**/*.zip ../build
mv ../modules/**/*.zip ../build

# Upload build-directory to src-bucket
aws s3 cp ../build s3://$S3_BUCKET_SRC/ --recursive
