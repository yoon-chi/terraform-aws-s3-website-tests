variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  default     = "yoon-test-2"
  /* default     = null */
  type        = string
}

variable "existing_bucket_name" {
  description = "bucket name of existing resource"
  type        = string
  default     = null
}