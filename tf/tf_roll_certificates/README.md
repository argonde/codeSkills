# Why better TF without Provissioners #

This is an example of using Terraform on a existing, manually-created deployment, that uses AWS infrastructure. In a pipeline an Ansible job has already copied the contents of an instance into another on a Prod environment, inside an Autoscaling Group and under a Load Balancer. That machine, with its updated contents, needs to become now the tamplate to use by the ASG. 
Besides having been created manually, the person did an even sloppier job by tagging all machines the same, leaving them to be identical but on their assigner private_IP and their ressource_ID. The only piece of information available is an artifact dropped by Ansible with the private_IP it connected to do its job.

* Manually created deployment
* Tagged with non-unique identifiers
* Autoscaled 
* Secured by SSL
* Accessible by SSH

The deployment consists of four machines. Two placed on the public subnets and the other two on private subnets, with access through a bastion using SSH protocol, the usual standard setup.
The bastion is also the host of certbot and, through its public internet access, it will take care of the automatic renovation of SSL certificates, which must later be updated on the other HAproxy Machines that do the redicts to a manifold of domains, both in the security of the private subnet.

### Preliminaries ###
Since the infrastructure has been created by other means than `terraform apply, it is unknow to its state file, as well as out of boundaries, as Terraform does not manipulate ressources it does not own.
In order to gain ownership you need to create an empty resource on the code, which will be referred to by name (e.g. resource "aws_instance" "ec2" {}) when using the command import on the console together with its originl resource id:
```
terraform import  aws_instance.ec2  i-0r2df62eyeba16cfa
```
Furthermore, since the IP of the machine (where the Ansible update job has taken place) is dropped on the directory as an artifact, its can be retrieved by Terraform to be used as identifier of the template for the autoscaling group.

```
# get the updated instance identity by picking up first its private IP from the directory
data "aws_instance" "ip" {
  filter {
    name   = "network-interface.addresses.private-ip-address"
    values = [file("./ip_artifact.txt")]
  }
}
```

## Ways to do the job ##
* The risky way of solving this is by using `Provisioners`.
* The tough way is using an external provider known as [External Data Source](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source)
* The forward way is using `Filters`.

### The risky way ###
Provisioners are used for loading data into a virtual machine or for saving it locally on your system. They are based on scripts, which perform logical steps locally or remotely on a resource. This dependance on the logic implemented by the script breaks the declarative and idempotent model of Terraform. I.e. the execution of that Terraform code, making use of an arbitrary script, *compromises to a certain degree its ability to be atomic or idempotent*. It is thus not advised to use provisioners, 'unless there is absolutely no other way to accomplish your goal'.
These are characterised by using either the `remote-exec` command to connect to a remote machine via WinRM or SSH and run a script remotely; or to use `local-exec` to run a script locally as part of the Terraform configuration code.

### The tough (and risky) way ###
This solution demands to use one of the only attributes that identify it (in this case its resource ID and private IP), to describe the AWS infrastructure by using the AWS CLI functionality, reaching the IDs of the generated instances through the Autoscaling Group that spun them.
* Query the information on Instances (ID) from `describe-auto-scaling-groups`, by filtering by the option --auto-scaling-group-names and --region.
* Then use the information returned from `describe-instances` to filter each instance ID, until one matches the private IP.

This is not straight forward, but it has to also be done by calling a bash/python script using a External Data Source, which should be considered to have the same pitfalls as a provisioner. An advantage is to be able to pass the `program` or script name, as well as its arguments under `query`.

```
# the use a bash script to get from AWS CLI the instance ID: query to match instance ID and private_IP
data "external" "get_instance_id_using_shell" {
  program = ["bash","./getPrivate_IP.sh"]
  query = {
    ip = data.aws_instance.ip
  }
}
```

### The forward way ###
Use a filter block, and pass the instance IP to select an instance that previously has been imported into Terraform.
```
data "aws_instance" "selected-all-doms" {
  instance_tags = {"Name":"rdir-all-doms"}
  filter {
    name = "private-ip-address"
    values = ["data.aws_instance.ip"]
  }
}
```
