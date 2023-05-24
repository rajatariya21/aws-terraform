# Output of IP address of aws ec2 instance
output "ec2_global_ips" {
  value = ["${aws_instance.web.*.public_ip}"]
}