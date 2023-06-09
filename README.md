1. Create provider.tf file to access aws account

2. Create Virtual Private Cloud(VPC) in AWS using terraform.

# Create VPC

# Create subnets
we have create two subnets. public and private.

# Internet Gateway

# Create Route Table

# Associating Public and Private Subnets to the Route Table


3. Attach security group to vpc for allow port in aws

4. Create ssh-key to access ec2 instance.

5. Create ec2 instance and install apache on it.

6. Get output of IP address of aws ec2 instance.

7. Attach elastic ip to ec2 instance.
if use elastic ip, it is chargable in aws. 

8. Add application load balancer to ec2.

9. Assign variables to define centrally controlled reusable values.

10. Please apply ca-key.tf after above resource creation, afterwards apply acm.tf file.