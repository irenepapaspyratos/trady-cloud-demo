variable "lambda_name" {
    description = "Namebase for lambdas, has to be completed with symbol-name or number"
    type = string
    default = "data_crawl_hour"
}

variable "lambda_src" {
    description = "Path to .zip"
    type = map
    default = {
        "function": {
            "hour": "data-crawl-hour.zip"
        },
        "layer": {
            "hour": "data-crawl-hour-layer.zip"
        }
    }
}

variable "comp_runtimes" {
    type = list
}
variable "s3bucket_source" {
    type = string
}

variable "symbol_current" {
    type = string
}

variable "caller_account" {
    type = string
} 
