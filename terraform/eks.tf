module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.8.0"

  name               = "my-cluster-eks"
  kubernetes_version = "1.30"

  endpoint_public_access  = true

  vpc_id     = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id,
    aws_subnet.subnet_3.id
  ]
  control_plane_subnet_ids = [
    aws_subnet.subnet_1.id,
    aws_subnet.subnet_2.id,
    aws_subnet.subnet_3.id
  ]

  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
}
