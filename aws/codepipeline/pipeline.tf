resource "aws_codepipeline" "codepipeline" {
    provider = aws.default

    name = var.pipeline_name
    role_arn = aws_iam_role.codepipeline_pipeline_role.arn

    artifact_store {
        location = module.bucket_codepipeline_artifacts.bucket
        type = "S3"
    }

    stage {
        name = "Source"
        action {
            category = "Source"
            owner = "AWS"
            name = "Source"
            provider = "CodeCommit"
            version = "1"
            output_artifacts = [ "SourceArtifact" ]

            configuration = {
              "RepositoryName" = var.stage_source_config.RepositoryName
              "BranchName" = var.stage_source_config.BranchName
              "PollForSourceChanges" = "true"
            }
        }
    }

    stage {
        name = "Build"
        action {
            category = "Build"
            owner = "AWS"
            name = "Build"
            provider = "CodeBuild"
            version = "1"
            input_artifacts = [ "SourceArtifact" ]
            output_artifacts = [ "BuildArtifact" ]

            configuration = {
              "ProjectName" = var.stage_build_config.ProjectName
            }
        }
    }

    dynamic "stage" {
        for_each = var.deploy_to == "elasticbeanstalk" ? [1] : []
        content {
            name = "Deploy"
            action {
                category = "Deploy"
                owner = "AWS"
                name = "Deploy"
                provider = "ElasticBeanstalk"
                version = "1"
                input_artifacts = [ "BuildArtifact" ]

                configuration = {
                "ApplicationName" = var.stage_deploy_config_elasticbeanstalk.ApplicationName
                "EnvironmentName" = var.stage_deploy_config_elasticbeanstalk.EnvironmentName
                }
            }
        }
    }

    dynamic "stage" {
        for_each = var.deploy_to == "s3" ? [1] : []
        content {
            name = "Deploy"
            action {
                category = "Deploy"
                owner = "AWS"
                name = "Deploy"
                provider = "S3"
                version = "1"
                input_artifacts = [ "BuildArtifact" ]

                configuration = {
                    "BucketName" = var.stage_deploy_config_s3.BucketName
                    "Extract" = var.stage_deploy_config_s3.Extract
                }
            }
        }
    }

    tags = var.tags
}