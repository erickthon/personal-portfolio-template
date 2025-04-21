module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = ["your-ipv4-address/32"]




  enable_irsa = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      max_size     = 1
      min_size     = 1

      instance_types = ["t3.small"]
    }
  }

  tags = {
    "Environment" = "dev"
    "Project"     = "portfolio"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "portfolio-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

resource "aws_ecr_repository" "portfolio" {
  name                 = "portfolio"
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "portfolio"
    Environment = "dev"
  }
}

resource "aws_ecr_lifecycle_policy" "portfolio_policy" {
  repository = aws_ecr_repository.portfolio.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire images older than 14 days",
        selection    = {
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 14
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "github_deployer" {
  name = "github-deployer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:your-github-username>/<your-repo-name:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "github_deployer_policy" {
  role = aws_iam_role.github_deployer.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeRepositories"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::812643146929:role/github-deployer"
        username = "github-deployer"
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::812643146929:role/default-eks-node-group-20250419132131490100000001"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      },
    ])
  }
}
