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

variable "ami_ids" {
  description = "Mapping of instance types to their respective AMI IDs"
  type        = map(string)
  default = {
    "t2.micro"  = "ami-01816d07b1128cd2d"  # Replace with actual AMI ID for t2.micro
    "t2.medium" = "ami-01816d07b1128cd2d"  # Replace with actual AMI ID for t2.medium
    "t2.large"  = "ami-01816d07b1128cd2d"  # Replace with actual AMI ID for t2.large
  }
}

locals {
  # Instance type based on environment
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

  # Resolve instance type and AMI ID dynamically based on environment
  instance_type = local.instance_types[var.environment]
  ami_id        = var.ami_ids[local.instance_type]
  storage_size  = local.storage_sizes[var.environment]
}
