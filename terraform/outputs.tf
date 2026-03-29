output "alb_dns_name" {
  description = "ALBのDNS名（ブラウザでアクセスするURL）"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  description = "ECSクラスター名"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECSサービス名"
  value       = aws_ecs_service.app.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch Logsのロググループ名"
  value       = aws_cloudwatch_log_group.app.name
}
