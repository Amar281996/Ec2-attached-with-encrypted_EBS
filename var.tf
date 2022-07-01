# Input variable declarations.

variable "vpc_name" {
  type        = string
  description = "Name of VPC"
  default     = "ebs-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_azs" {
  type        = list(string)
  description = "Availability zones for VPC"
  default     = ["us-west-2a", "us-west-2b"]
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "Private subnets for VPC"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  type        = list(string)
   description = "Public subnets for VPC"
   default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  type        = bool
  description = "Enable NAT gateway for VPC"
  default     = true
}

variable "vpc_tags" { 
  type        = map(string)
  description = "Tags to apply to resources created by VPC module"
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}
