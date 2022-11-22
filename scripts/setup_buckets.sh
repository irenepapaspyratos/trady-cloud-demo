# Create bucket for resources in chosen region
if aws s3 ls "s3://$2" 2>&1 | grep -q 'An error occurred.'
then
    aws s3api create-bucket --bucket $2 --region $1 --create-bucket-configuration LocationConstraint=$1
    echo "Bucket '$2' has been created."
else
    echo "Bucket '$2' already exists."
fi

# Create bucket for Terraform in chosen region
if aws s3 ls "s3://$3" 2>&1 | grep -q 'An error occurred.'
then
    aws s3api create-bucket --bucket $3 --region $1 --create-bucket-configuration LocationConstraint=$1
    echo "Bucket '$3' has been created."
else
    echo "Bucket '$3' already exists."
fi
