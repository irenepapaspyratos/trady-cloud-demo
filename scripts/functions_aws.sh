#!/bin/bash

# Create a single bucket in AWS S3
create_aws_s3bucket() {
    if 
        aws s3 ls "s3://$2" 2>&1 | grep -q 'An error occurred.'
    then
        aws s3api create-bucket --bucket $2 --region $1 --create-bucket-configuration LocationConstraint=$1
    else
        echo "Bucket '$2' already exists."
    fi
}

# Create many buckets in AWS S3 in the same region
create_aws_s3bucket_multi() {
    local region=$1
    shift
    #local buckets=("$@")
    for b in "$@";
        do
            create_aws_s3bucket $region $b | cat
        done
}

# Create layer for Lambdas
create_aws_lambda_layer() {
    requirementsbase=modules
    layerbase=infrastructure/modules/lambdas/lambda-layers
    
    cd ../modules
    for dir in */;
        do
            name=$(sed 's/.$//' <<< "$dir")
            echo $name/requirements.txt
            ls ./$name
            layer=../$layerbase/$name-layer
            target=$layer/python         
            mkdir -p $target
            cp ./$name/requirements.txt $layer
            cd $target
            pip3 install -r ../requirements.txt -t .
            cd ..
            zip -r $name-layer.zip python    
            rm -rf python
            cd ../../../../../modules
            ls
        done
    cd ../scripts
}
