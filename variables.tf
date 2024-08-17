
variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "eu-west-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "DATABASE_USER" {
  description = "The database username"
  type        = string
}

variable "DATABASE_PASS" {
  description = "The database password"
  type        = string
  sensitive   = true
}

variable "DATABASE_NAME" {
  description = "The name of the database"
  type        = string
  default     = "pythonapp"
}

variable "docker_image_endpoint" {
  description = "The Docker image URL on AWS ECR"
  type        = string
  default     = "pythonapp"
}