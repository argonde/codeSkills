# Terraform 'for_each' loop example, to deploy uniquely tagged instances on AWS #

This is an simple example on how to deploy, using Terraform, aws instances, each of which being uniquely tagged. It uses of an AMI to template the machines that will be deployed. In this case these are ubuntu machines, deployed in a VPC, with a single subnet. They will be secured  by SSH keys, (if necessary), and a VPC security group (or firewall), configured for SSH protocol. The exercise is here to simply provide them with different tags. So the AWS infrastructure to be created is:

* Isolation in a VPC
* Security by SG and SSL
* Restricted to traffic from a single IP addresses
* Accessible by SSH
* Uniquely tagged

