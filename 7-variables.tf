variable "region" {
  default = "us-east-1"
}

variable "subnet_cidr_public" {
  description = "cidr blocks for the public subnets"
  default     = ["10.0.1.0/28", "10.0.1.16/28", "10.0.1.32/28"]
  type        = list(any)
}

variable "availability_zone_public" {
  description = "availability zones for the public subnets"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list(any)
}


variable "subnet_cidr_private" {
  description = "cidr blocks for the private subnets"
  default     = ["10.0.2.0/28", "10.0.2.16/28", "10.0.2.32/28"]
  type        = list(any)
}

variable "availability_zone_private" {
  description = "availability zones for the private subnets"
  default     = ["us-east-1d", "us-east-1e", "us-east-1f"]
  type        = list(any)
}