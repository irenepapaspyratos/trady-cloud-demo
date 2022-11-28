#!/bin/bash

# Create variable file from template
create_gh_variables() {
    echo 'AWS_ACCESS_KEY_ID=${{ secrets.AWS_ACCESS_KEY_ID }}
AWS_SECRET_ACCESS_KEY=${{ secrets.AWS_SECRET_ACCESS_KEY }}
AWS_SESSION_TOKEN=${{ secrets.AWS_SESSION_TOKEN }}
AWS_REGION='${1}\ > ../.github/variables/variables.env
}
