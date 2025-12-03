variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "db_name" {
  type        = string
  description = "Postgres database name"
}

variable "db_user" {
  type        = string
  description = "Postgres username"
}

variable "db_pass" {
  type        = string
  description = "Postgres password"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "route_table_id" {
  type        = string
  description = "Route Table ID"
}
variable "lambda_subnet_id" {
  description = "Subnet ID used for Lambda VPC configuration"
  type        = string
}
