variable "instance_tags" {
  description = "Map of project names to configuration."
  type        = map(any)
  default = {
    sandbox-one = {
      ami_id            = "ami-08edbb0e85d6a0a07",
      instance_type     = "t2.micro",
      ami_key_pair_name = "sandbox_id_rsa",
      name              = "sb_01",
      project           = "asen",
      environment       = "test"
    },
    sandbox-two = {
      ami_id            = "ami-08edbb0e85d6a0a07",
      instance_type     = "t2.micro",
      ami_key_pair_name = "sandbox_id_rsa",
      name              = "sb_02",
      project           = "markus",
      environment       = "test"
    }
  }
}
