# AWS availablity zones
data "aws_availability_zones" "available_zones" {
  state = "available"
}