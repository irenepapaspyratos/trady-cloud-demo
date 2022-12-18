variable "lambda_name" {
    description = "Namebase for lambdas, has to be completed with symbol-name or number"
    type        = string
    default     = "data_crawl_hour"
}

variable "crawl_handler" {
    description = "Start of lambda function"
    type = string
}

variable "lambda_src_function" {
    description = "Path to .zip"
    type        = string
}

variable "lambda_src_layer" {
    description = "Path to .zip"
    type        = string
}

variable "symbol_current" {
    description = "Symbol to crawl data"
    type = string
}

variable "hour" {
    description = "Earliest day to crawl data from current symbol or, if invocation: hour to actual crawl"
    type = string
}

variable "invocation" {
    description = "Wether this is an invocation call or an hourly call"
    type = bool
}

variable "compatible_runtimes" {
    type = list
}
variable "s3bucket_source" {
    type = string
}

variable "caller_account" {
    type = string
} 

variable "target_rule" {
  type = string
}

variable "target_id" {
  type = string
}

variable "cloudwatch_name" {
  type = string
}
