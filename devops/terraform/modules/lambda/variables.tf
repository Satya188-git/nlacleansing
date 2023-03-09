variable "environment" {
  type=string
}

variable "awsAssumeRole" {
  type=string
}

variable "lambdaRole-arn" {
  type=string
}

variable "ccc_unrefined_call_data_bucket-arn" {
  type=string
}
variable "ccc_verified_clean_bucket-arn" {
  type=string
}
# there may be other triggers for macie process