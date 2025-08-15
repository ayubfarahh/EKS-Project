resource "aws_security_group" "eks_cluster_sg" {
  name        = var.eks_cluster_sg_name
  description = var.eks_cluster_sg_desc
  vpc_id      = var.vpc_id

}

resource "aws_security_group" "eks_nodes_sg" {
  name        = var.eks_nodes_sg_name
  description = var.eks_nodes_sg_desc
  vpc_id      = var.vpc_id

  ingress {
    from_port = var.from_port
    to_port   = var.to_port
    protocol  = var.all_protocols
    self      = true
  }

  egress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = var.all_protocols
    cidr_blocks = var.cidr_blocks
  }
}

resource "aws_security_group_rule" "cluster_to_nodes" {
  type                     = var.sg_rule_type
  security_group_id        = aws_security_group.eks_nodes_sg.id
  from_port                = var.sg_rule_from_port
  to_port                  = var.sg_rule_to_port
  protocol                 = var.tcp_protocol
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  description              = var.sg_rule_description

}

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  version  = var.eks_cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.eks_node_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  instance_types = var.instance_types
  disk_size      = var.disk_size

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}
