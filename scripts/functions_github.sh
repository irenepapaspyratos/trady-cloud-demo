#!/bin/bash

# Create variable file from template
create_gh_variables() {
    echo 'AWS_REGION='${1} > ../.github/variables/variables.env
}
