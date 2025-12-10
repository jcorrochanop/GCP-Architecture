variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
}

variable "region" {
  description = "Región principal para recursos"
  type        = string
  default     = "us-central1"
}

variable "admin_user_email" {
  description = "Email del usuario administrador"
  type        = string
}

variable "vpc_pro_name" {
  description = "Nombre de la VPC de Producción"
  type        = string
  default     = "vpc-pro"
}

variable "vpc_pro_cidr" {
  description = "CIDR de la VPC PRO"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_pro_subnets" {
  description = "Subredes de VPC PRO"
  type = list(object({
    name   = string
    cidr   = string
    region = string
  }))
  default = [
    {
      name   = "subnet-1-pro"
      cidr   = "10.0.1.0/24"
      region = "us-central1"
    },
    {
      name   = "subnet-2-pro"
      cidr   = "10.0.2.0/24"
      region = "us-central1"
    },
    {
      name   = "subnet-3-pro"
      cidr   = "10.0.3.0/24"
      region = "us-central1"
    }
  ]
}

variable "vpc_dev_name" {
  description = "Nombre de la VPC de Desarrollo"
  type        = string
  default     = "vpc-dev"
}

variable "vpc_dev_cidr" {
  description = "CIDR de la VPC DEV"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_dev_subnets" {
  description = "Subredes de VPC DEV"
  type = list(object({
    name   = string
    cidr   = string
    region = string
  }))
  default = [
    {
      name   = "subnet-1-dev"
      cidr   = "10.1.1.0/24"
      region = "us-central1"
    },
    {
      name   = "subnet-2-dev"
      cidr   = "10.1.2.0/24"
      region = "us-central1"
    },
    {
      name   = "subnet-3-dev"
      cidr   = "10.1.3.0/24"
      region = "us-central1"
    }
  ]
}

variable "kms_keyring_name" {
  description = "Nombre del Key Ring de Cloud KMS"
  type        = string
  default     = "vm-kering-prod"
}

variable "kms_key_name" {
  description = "Nombre de la Crypto Key"
  type        = string
  default     = "vm-disk-key-prod"
}

variable "kms_rotation_period" {
  description = "Periodo de rotación de claves (en segundos, 90 días = 7776000s)"
  type        = string
  default     = "7776000s"
}
