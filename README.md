## AWS Apache Server Terraform Module
---

This Terraform module sets up an Apache server in AWS. It creates an EC2 instance, configures security groups, and installs Apache on the instance.

**Note**: This module is not intended for production use.

#### Usage

To use this module, include the following code in your Terraform configuration:

```hcl
module "apache" {
  source = "github.com/soficx/terraform-aws-apache-demo"
  vpc_id = "vpc-000000000"
  public_key = "ssh-rsa AAAAB...."
  server_name = "terraform-apache-demo-server"
  instance_type = "t2.micro"
  my_ip = "YOUR_OWN_IP/3"
}

output "public_ip" {
  value = module.apache.public_ip
}
```
##### Inputs
This module accepts the following inputs:
- vpc_id : The ID of the VPC to launch the instance in.
- public_key : The public SSH key to use to authenticate to the instance.
- server_name : The name of the server. 
- instance_type : The type of EC2 instance to launch.
- ip_address : The IP address of the control machine (so you can access to the instance through ssh)

##### Outputs 

This module outputs the following values: 
- public_ip: The public IP address of the EC2 instance.
- public_dns: The public DNS name of the EC2 instance.

##### License

This module is licensed under the Apache License. See the LICENSE file for details.

