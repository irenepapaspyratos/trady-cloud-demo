#!/bin/bash

source functions_aws.sh
source functions_terraform.sh

S3_BUCKET_SRC=trady-cloud-src
S3_BUCKET_TERRAFORM=trady-cloud-terraform
REGION=us-west-2

# Create buckets necessary for Terraform via script as the sandbox does not allow creating them via Terraform itself
create_aws_s3bucket_multi $REGION $S3_BUCKET_SRC $S3_BUCKET_TERRAFORM

# Create from terraform-templates with variables: config.backend & variables
create_tf_variables $REGION $S3_BUCKET_TERRAFORM
create_tf_backend_s3 $REGION $S3_BUCKET_TERRAFORM
