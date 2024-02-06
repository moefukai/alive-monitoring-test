resource "aws_appautoscaling_target" "main" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  #   role_arn           = data.aws_iam_role.ecs_service_autoscaling.arn
  min_capacity = 2
  max_capacity = 5
}

resource "aws_appautoscaling_policy" "main_cpu" {
  name               = "${var.project}-scale-cpu-policy"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 80
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
  }

  depends_on = [aws_appautoscaling_target.main]
}

resource "aws_appautoscaling_policy" "main_memory" {
  name               = "${var.project}-scale-memory-policy"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
  }

  depends_on = [aws_appautoscaling_target.main]
}

# data "aws_iam_role" "ecs_service_autoscaling" {
#   name = "AWSServiceRoleForApplicationAutoScaling_ECSService"
# }
