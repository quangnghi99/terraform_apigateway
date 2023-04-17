variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "lambda_name" {
  type    = list(any)
  default = ["get_function", "delete_function", "post_function", "update_function"]
}

variable "python_file" {
  type    = list(any)
  default = ["get_function", "delete_function", "post_function", "update_function"]
}
variable "api_res_path" {
  type    = string
  default = "student"
}
variable "api_method" {
  type    = list(any)
  default = ["GET", "DELETE", "POST", "PUT"]
}