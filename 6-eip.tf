# Create an EIP
# # resource block for eip #
# resource "aws_eip" "demo-eip" {
#   vpc = true
# }


#  EIP to EC2 Instance
# resource "aws_eip" "demo-eip" {
#   count = length(aws_instance.web)
#   # instance = aws_instance.web.id
#   instance = aws_instance.web[count.index].id
#   vpc      = true
# }

# #  EIP to EC2 Instance
# resource "aws_eip" "demo-eip" {
#   instance = aws_instance.web.id
#   vpc      = true
#   }


# #Associate EIP with EC2 Instance
# resource "aws_eip_association" "demo-eip-association" {
#   instance_id   = aws_instance.web.id
#   allocation_id = aws_eip.demo-eip.id
# }