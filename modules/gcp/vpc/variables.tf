provider "google" {
  project     = "multicloud-kubernetes"
  region    =   "us-east1"
}


variable "cloud" {
    description = "Cloud platform on which we need to the deployment"
    type        = list(string)
    default = ["AWS"]
}

variable "region" {
  description = "AWS region in which we need to deploy."
  type        = "map"
  default     = {
      northvirginia =   "us-east-1"
      singapore =   "ap-southeast-1"
  }
}

variable "CIDR" {
    description = "CIDR block for VPC"
    type    = "map"
    default =  {
        vpc_one = "10.0.0.0/16"
        vpc_two =   "10.1.0.0/16"
        vpc_three = "10.2.0.0/16"
    }
}

variable "netnum_size" {
    description = "Map the friendly name to our subnet bit mask"
    type    =   "map"
    default = {
        controller  =   "1"
        worker  =   "2"
    }
}

variable "Project" {
    description =   "Name of project for which deployment is being done."
    type    = "string"
    default =   "dlos"
}

variable "Owner" {
    description =   "email ID of a person who will be decision maker for deployment which is being done."
    type    = "string"
    default =   "chitender-kumar"
}

variable "Environment" {
    description =   "Name of the deployment. Production/Development/Staging/UAT"
    type    = "string"
    default =   "development"
}

variable "TechnologyUnit" {
    description =   "Name of the department under which this project falls."
    type    = "string"
    default =   "infrastructure"
}

variable "BusinessUnit" {
    description =   "Name of the Business division under which this project falls."
    type    = "string"
    default =   "dlos"
}