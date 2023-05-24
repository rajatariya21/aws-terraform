# Output of IP address of aws ec2 instance
output "ec2_global_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}

# Output of elastic IP address of ec2 instance
output "ec2_elastic_ips" {
  value = zipmap(aws_instance.web.*.tags.Name, aws_eip.demo-eip.*.public_ip)
}