module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.asg_name

  # Launch configuration
  lc_name = "${var.asg_name}-lc"

  image_id = data.aws_ami.ecs_ami.image_id
  instance_type = var.instance_type
  security_groups = var.security_groups

  root_block_device = [
    {
      volume_size = "50"
      volume_type = "gp2"
    },
  ]

  iam_instance_profile = module.iam_role.iam_instance_profile

  user_data = var.user_data

  # Auto scaling group
  asg_name = "${var.asg_name}-asg"
  vpc_zone_identifier = var.subnets
  health_check_type = "EC2"
  min_size = var.min_asg_size
  max_size = var.max_asg_size
  desired_capacity = var.desired_capacity
  wait_for_capacity_timeout = 0

  tags = [
    {
      key = "Environment"
      value = "dev"
      propagate_at_launch = true
    },
    {
      key = "Project"
      value = "compute"
      propagate_at_launch = true
    },
  ]

}

module "iam_role" {
  source = "github.com/barundel/terraform-iam/aws"

  role_name                 = "ECSRole"

  create_role = true
  iam_instance_profile = true

  assume_role_policy        = data.aws_iam_policy_document.trust_profile.json

  inline_policies_to_create = {
    "ECSAccess" = data.aws_iam_policy_document.permissions.json
  }
}