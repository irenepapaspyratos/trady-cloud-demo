variable "default_timestamp" {
    type = map
    default = {
        "eurusd": "2003-05-04T00:01:01Z"
        "eurgbp": "2003-08-03T00:01:01Z"
    }
}

variable "lambda_src" {
    type        = map
    default     = { "function": "data-crawl-hour.zip", "layer": "data-crawl-hour-layer.zip" }
}

variable "crawl_handler" {
    type = string
    default = "crawl.handler"
}

variable "symbol_ranges_hour" {
    type = map(number)
    default = {"eurusd":172069, "eurgbp":169885}
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
