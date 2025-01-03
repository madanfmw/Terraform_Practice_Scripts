variable "aws_region" {
  description = "The AWS region to deploy the instance"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment for the instance (test, int, prod)"
  type        = string
  validation {
    condition     = var.environment == "test" || var.environment == "int" || var.environment == "prod"
    error_message = "Environment must be one of: test, int, prod."
  }
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-01816d07b1128cd2d" # Replace with a valid AMI ID
}

variable "instance_type" {
  description = "The instance type based on the environment"
  type        = string
  default     = "t2.micro"
}

locals {
  instance_types = {
    test = "t2.micro"
    int  = "t2.medium"
    prod = "t2.medium"
  }

  storage_sizes = {
    test = 10
    int  = 15
    prod = 20
  }

  instance_type = local.instance_types[var.environment]
  storage_size  = local.storage_sizes[var.environment]
}
