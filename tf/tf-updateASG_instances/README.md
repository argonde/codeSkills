# Terraform AWS VPC Example #

This is an example a Terraform deployment using AWS infrastructure that is:

* Isolated in a VPC
* Load balanced
* Autoscaled (and scheduled to roll updates by scaling out and in)
* Secured by SSL
* Accessible on custom port 8080
* Restricted on traffic private subnets 
* Capability to update the private infrastructure by NAT gateway and EIP
* Accessible by SSH

The deployment consistes of four machines. Two placed on the public subnets and ready to be access on port 8080 (a usual port for a Tomcat Apache Server to be listeninig and serving content using javaScript). The other two are placed on private subnets (which do not have direct access to the internet). The instances placed here are usually useful for databases, or holding SSL certificates.
These machines are load balanced and autoscaled, for the purpose of High Availability. Also the ASG (Autoscaling Group) can be triggered by an external event, like renewal and insertion of certificates or other content, and then scheduled to roll in the changes by scaling out and in.

## Deployment ##

### Plan the deployment ###

`terraform plan`

### Apply the deployment ###

`terraform apply`
