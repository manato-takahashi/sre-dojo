variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "プロジェクト名（リソースの命名に使用）"
  type        = string
  default     = "sre-dojo"
}

variable "app_image" {
  description = "ECSタスクで使用するDockerイメージ"
  type        = string
}

variable "app_port" {
  description = "アプリケーションのポート番号"
  type        = number
  default     = 8080
}

variable "fargate_cpu" {
  description = "Fargateタスクに割り当てるCPU（単位: CPU units）"
  type        = number
  default     = 256
}

variable "fargate_memory" {
  description = "Fargateタスクに割り当てるメモリ（単位: MiB）"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "ECSサービスのタスク数"
  type        = number
  default     = 1
}
