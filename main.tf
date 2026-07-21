provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  project  = var.project
  env      = terraform.workspace
}

module "subnet" {
  source       = "./modules/subnet"
  vpc_id       = module.vpc.vpc_id
  igw_id       = module.vpc.igw_id
  pri_sub_cidr = var.pri_sub_cidr
  pub_sub_cidr = var.pub_sub_cidr
  project      = var.project
  env          = terraform.workspace
}

module "sg" {
  source  = "./modules/sg"
  vpc_id  = module.vpc.vpc_id
  project = var.project
  env     = terraform.workspace
}

module "ec2" {
  source        = "./modules/ec2"
  ami           = var.image_id
  instance_type = var.instance_type
  subnet_id     = module.subnet.public_subnet_id
  sg_id         = module.sg.sg_id
  key_name      = var.key_pair
  project       = var.project
  env           = terraform.workspace
}
