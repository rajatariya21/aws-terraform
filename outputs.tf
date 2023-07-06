# Output of IP address of aws ec2 instance
output "ec2_global_ips" {
  value = [aws_instance.web.*.public_ip, aws_instance.web.*.tags]
}


# output "ec2_machines" {
#  # Here * indicates that there are more than one arn because count is 4   
#   value = aws_instance.web.*.arn 
# }

# output "public_subnets" {
#   value = aws_subnet.public_subnets.*.id
# }