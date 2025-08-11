resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-project-cluster-sg"
  description = "EKS control-plane SG"
  vpc_id      = var.vpc_id

}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-project-nodes-sg"
  description = "EKS Nodes SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "nodes intra-comm"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "cluster_to_nodes" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  description              = "EKS control-plane to kubelet communication"

}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-project"
  version  = "1.30"
  role_arn = "arn:aws:iam::940622738555:role/eks-project-cluster-role"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "workers"
  node_role_arn   = "arn:aws:iam::940622738555:role/eks-project-node-role"
  subnet_ids      = var.private_subnet_ids

  instance_types = ["t3.medium"]
  disk_size      = 20

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}
