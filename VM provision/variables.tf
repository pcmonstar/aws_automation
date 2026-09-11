variable "aws_region" {
  description = "AWS region where the instance will be created."
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance and security group."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type. t2.micro is eligible for many free-tier plans."
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name. Leave null to create the instance without SSH key access."
  type        = string
  default     = null
  nullable    = true
}

variable "allowed_ssh_cidr" {
  description = "Optional CIDR allowed to SSH to the instance. Leave null to disable SSH ingress."
  type        = string
  default     = null
  nullable    = true
}

variable "allowed_http_cidr" {
  description = "CIDR allowed to access the Apache web server over HTTP."
  type        = string
  default     = "0.0.0.0/0"
}

variable "root_volume_size_gb" {
  description = "Encrypted root volume size in GiB."
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size_gb >= 8
    error_message = "root_volume_size_gb must be at least 8 GiB."
  }
}

variable "common_tags" {
  description = "Tags applied to created resources."
  type        = map(string)
  default     = {}
}