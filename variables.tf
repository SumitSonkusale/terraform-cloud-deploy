# ---------------------------------------------------------------------------
# Input variables
# All variables have sensible defaults so the project works out of the box
# with a simple `terraform plan -var='aws_region=eu-west-2'`.
# ---------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region to deploy resources into."
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Short project identifier used in resource names and tags."
  type        = string
  default     = "tcdev"
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance. Defaults to Amazon Linux 2023 in eu-west-2."
  type        = string
  default     = "ami-0b45ae66668865cd6"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair for SSH access. Leave empty to skip."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to reach the instance on port 22."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "s3_bucket_name" {
  description = "Globally unique S3 bucket name. If empty, one is auto-generated."
  type        = string
  default     = ""
}
