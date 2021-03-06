variable "artifacts_bucket_name" {type = string}
variable "buildspec_file" {
    type = string
    default = ".devops/buildspec.yml"
}
variable "cache_bucket_name" {type = string}
variable "codebuild_project_name" {type = string}
variable "codebuild_project_description" {type = string}
variable "codebuild_source_version" {
    type = string
    default = "refs/heads/main"
}
variable "codecommit_repository" {type = string}
variable "compute_specs" {type = map}
variable "compute_os" {type = string}
variable "environment_variables_parameter_store" {
    type = map
    default = {}
}
variable "environment_variables_plaintext" {
    type = map
    default = {}
}
variable "environment_variables_secrets_manager" {
    type = map
    default = {}
}
variable "git_repository_https_url" {type = string}
variable "log_group_name" {type = string}
variable "policy_description" {type = string}
variable "policy_name" {type = string}
variable "product_id" {type = string}
variable "service_role_name" {type = string}
variable "tags" {type = map}
variable "timeouts" {
    type = map
    default = {
        build = "15"
        queue = "480"
    }
}
variable "vpc" {
    type = map
    default = {}
}
