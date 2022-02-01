module "ec2_instances" {
  source = "./ec2_tags/"

  for_each = var.instance_tags

  ami_id            = each.value.ami_id
  instance_type     = each.value.instance_type
  ami_key_pair_name = each.value.ami_key_pair_name

  name         = each.value.name
  project_name = each.value.project
  environment  = each.value.environment
}
