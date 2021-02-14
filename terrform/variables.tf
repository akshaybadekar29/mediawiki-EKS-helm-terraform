variable "region" {
  default     = "ap-south-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "eks-cluster"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "435312026058"
  ]
}



variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::435312026058:instance-profile/admin-role"
      username = "admin-role"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::435312026058:user/aws-admin"
      username = "aws-admin"
      groups   = ["system:masters"]
    },

  ]
}

