variable "aws_region" {
    type = string
    default = "us-west-2"
}

variable "s3bucket_terraform" {
    type = string
    default = "trady-cloud-terraform"
}

variable "s3bucket_src" {
    type = string
    default = "trady-cloud-src"
}

variable "compatible_runtimes" {
    type = list
    default = ["python3.9"]
}

variable "symbols" {
    type = list
    default = ["eurusd", "eurgbp"]
}
