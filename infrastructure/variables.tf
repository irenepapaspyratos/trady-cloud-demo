variable "start_timestamp" {
    type = map(string)
    default = {
        "eurusd": "2003-05-04T00:01:01Z"
        "eurgbp": "2003-08-03T00:01:01Z"
    }
}

variable "start_timestamp_number" {
    type        = map(number)
    default     = { "eurusd": 1051999200, "eurgbp": 1059861600 }
}

variable "lambda_src" {
    type        = map(string)
    default     = { "function": "data-crawl-hour.zip", "layer": "data-crawl-hour-layer.zip" }
}

variable "crawl_handler" {
    type = string
    default = "crawl.handler"
}

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
