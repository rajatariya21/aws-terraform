variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.2.0/24"]
}


# Creating a Variable for ami
variable "ami" {
  type = string
}

# Creating a Variable for instance_type
variable "instance_type" {
  type = string
}

# variable "key_name" {
#  type        = string
#  description = "key-pair to access the EC2 instance"
#  }

# variable "public_key" {
#  type        = string
#  description = "public key for the EC2 instance"
#  default     = "file("${path.module}/aws-key.pub")"
# }

# variable "tags" {
#  type = object({
#    name = string
#    env  = string
#  })
#  description = "Tags for the EC2 instance"
#  default = {
#    name = "My Virtual Machine"
#    env  = "Dev"
#  }
# }

