variable "key_name" {
    type    = string
    default = "boyeon__j"
}
variable "public_key" {
    type    = string
    default = "./id_rsa.pub"
}
variable "my_region" {
    type    = string
    default = "ap-northeast-2"
}
variable "db_username" {
    type    = string
}
variable "db_password" {
    type    = string
}
variable "my_access_key" {
    type    = string
}
variable "my_secret_key" {
    type    = string
}

variable "image_id_web" {
    type    = string
    default = "ami-00379ec40a3e30f87"
}
variable "image_id_was" {
    type    = string
    default = "ami-00379ec40a3e30f87"
}
variable "target_group_path" {
    type    = string
    default = "/"
}
variable "db_port" {
    type    = string
    default = "3306"
}


