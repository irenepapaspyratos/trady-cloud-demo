S3_BUCKET_SRC=trady-cloud-src
S3_BUCKET_TERRAFORM=trady-cloud-terraform
REGION=us-west-2

# Create buckets necessary for Terraform via script as the sandbox does not allow creating them via Terraform itself
sh setup_buckets.sh $REGION $S3_BUCKET_SRC $S3_BUCKET_TERRAFORM 
