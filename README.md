# Trady Cloud Demo

This project is the final project of the AWS Cloud Development Certification of 2022 at *Neue Fische*.

It contains a demo application, which requests 1-hour-delayed tick-data for various symbols serverless from *Dukascopy* to create a database for backtesting of trading strategies. The infrastructure is generated with Terraform while CI/CD principles are followed via Github Workflows. As certain functions cannot be used in the sandbox of AWS, this project was created adhering to those restrictions.

# Usage

- Copy the project
- Place credentials etc. locally
- Run start_script.sh

**If you want to change some code using Github:** 

- Place your credentials etc. as secrets in your Github account  

**ATTENTION:**   
!! Due to CD, any changes of the code will be automatically applied via terraform to your AWS infrastructure by pushing to Github !!
