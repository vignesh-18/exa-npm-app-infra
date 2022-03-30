output "app_pipeline" {
    value = aws_codepipeline.appcodepipeline.arn
}

output "infra_pipeline" {
    value = aws_codepipeline.infracodepipeline.arn
}
