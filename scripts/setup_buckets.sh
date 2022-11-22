S3_BUCKET_SRC=trady-cloud-src
S3_BUCKET_TERRAFORM=trady-cloud-terraform
REGION=us-west-2

if aws s3 ls "s3://$S3_BUCKET_SRC" 2>&1 | grep -q 'An error occurred.'
then
    aws s3api create-bucket --bucket $S3_BUCKET_SRC --region $REGION --create-bucket-configuration LocationConstraint=$REGION
else
    echo "Bucket '$S3_BUCKET_SRC' already exists."
fi

if aws s3 ls "s3://$S3_BUCKET_TERRAFORM" 2>&1 | grep -q 'An error occurred.'
then
    aws s3api create-bucket --bucket $S3_BUCKET_TERRAFORM --region $REGION --create-bucket-configuration LocationConstraint=$REGION
else
    echo "Bucket '$S3_BUCKET_TERRAFORM' already exists."
fi
