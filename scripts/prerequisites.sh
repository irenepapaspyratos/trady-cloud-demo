#!/bin/bash

. ./functions_aws.sh
. ./functions_terraform.sh
. ./functions_github.sh
. ./functions_crawl.sh

NAME_BASE=trady-cloud
SYMBOLS="EURUSD EURGBP"
REGION=us-west-2

S3_BUCKET_SRC=$NAME_BASE-src
S3_BUCKET_TERRAFORM=$NAME_BASE-terraform
S3_BUCKET_SYMBOLBASE=$NAME_BASE-symbol
S3_BUCKET_SYMBOL_LAKE=$S3_BUCKET_SYMBOLBASE-lake
S3_BUCKET_SYMBOL_LOGS=$S3_BUCKET_SYMBOLBASE-logs

# Create build folder
mkdir build 

# Create Environment Variables for Github
create_gh_variables $REGION

# Create string of bucket names for symbols
sym=$(echo "$SYMBOLS" | tr '[:upper:]' '[:lower:]')
for s in $sym;
    do
        SYMBOL_BUCKETS="$SYMBOL_BUCKETS $S3_BUCKET_SYMBOLBASE-$s"
    done
CREATE_BUCKETS="$S3_BUCKET_SRC $S3_BUCKET_TERRAFORM $S3_BUCKET_SYMBOL_LAKE $S3_BUCKET_SYMBOL_LOGS $SYMBOL_BUCKETS"

# Create necessary buckets (for Terraform via script as the sandbox does not allow creating them via Terraform itself)
create_aws_s3bucket_multi $REGION $CREATE_BUCKETS

# Create from terraform-templates with variables: config.backend & variables
create_tf_variables $REGION $S3_BUCKET_TERRAFORM
create_tf_backend_s3 $REGION $S3_BUCKET_TERRAFORM

# Create Lambda-Layers for all modules
create_aws_lambda_layer

# Create from data-crawler-templates: variables.py
create_crawl_variables $S3_BUCKET_SYMBOLBASE $S3_BUCKET_SYMBOL_LAKE $S3_BUCKET_SYMBOL_LOGS $SYMBOL_BUCKETS

# Fill build-directory
mv ../infrastructure/modules/lambdas/lambda-layers/**/*.zip build

# Upload build-directory to src-bucket
aws s3 cp build s3://$S3_BUCKET_SRC/ --recursive
