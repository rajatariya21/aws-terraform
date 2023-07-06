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

