# variable "azs" {
#   type        = list(string)
#   description = "Availability Zones"
#   default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
# }

# variable "key_name" {
#  type        = string
#  description = "key-pair to access the EC2 instance"
#  default     = "dem02-key"
# }

# variable "public_key" {
#  type        = string
#  description = "public key for the EC2 instance"
#  default     = "file("${path.module}/aws-tf.pub")"
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

# variable "subnet" {
#  type        = string
#  description = "Subnet ID for network interface"
#  default     = "subnet-76a8163a"
# }

# variable "ami" {
#  type        = string
#  description = "AMI ID for the EC2 instance"
#  default     = "dem02-key"

#  validation {
#    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
#    error_message = "Please provide a valid value for variable AMI."
#  }
# }

# variable "public_key" {
#  type        = string
#  description = "public key for the EC2 instance"
#  default     = "t2.micro"
#  sensitive   = true
# }
