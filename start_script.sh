#!/bin/bash

echo "\n"\
Hello Backtester! "\n""\n"\
As this application is still in development-state, you cannot yet change the settings. "\n"\
The parameters are set like follows: "\n"\
'NAME_BASE for buckets etc. = trady-cloud' "\n"\
'SYMBOLS to request data for = EURUSD & EURGBP' "\n"\
'REGION for buckets = us-west-2' "\n""\n"\
If you want to start, you need to have your credentials stored in place. "\n"\
Would you like to start the programm? '(Y/N)'
read answer1
if [[ $answer1 == "Y" || $answer1 == "y" ]]; then
    cd ./scripts
    aws sts get-caller-identity | cat
    aws configure list
    echo Creating buckets etc... "n"\
    sh prerequisites.sh
    cd ..
    cd ./infrastructure
    terraform init -backend-config=./production_env/config.s3.tfbackend
    terraform plan
    echo Would you like to apply? '(Y/N)'
    read answer2
    if [[ $answer2 == "Y" || $answer2 == "y" ]]; then
        terraform apply -auto-approve
        exit
    else
        echo "Good bye, have a nice day!"
        exit
    fi
else
    echo "Good bye, have a nice day!"
    exit
fi
