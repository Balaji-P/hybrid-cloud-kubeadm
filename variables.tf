variable "cloud" {
    description = "Cloud platform on which we need to the deployment"
    type        = list(string)
    default = ["AWS"]
}

variable "region" {
  description = "AWS region in which we need to deploy."
  type        = list(string)
  default     = ["us-east-2","us-east-1"]
}

variable "CIDR" {
    description = "CIDR block for VPC"
    type    = list(string)
    default =  ["10.0","10.1"]
}

variable "Project" {
    description =   "Name of project for which deployment is being done."
    type    = string
    default =   "DLOS"
}

variable "Owner" {
    description =   "email ID of a person who will be decision maker for deployment which is being done."
    type    = string
    default =   "chitender.kumar@delhivery.com"
}

variable "Environment" {
    description =   "Name of the deployment. Production/Development/Staging/UAT"
    type    = string
    default =   "Development"
}

variable "TechnologyUnit" {
    description =   "Name of the department under which this project falls."
    type    = string
    default =   "Infrastructure"
}

variable "BusinessUnit" {
    description =   "Name of the Business division under which this project falls."
    type    = string
    default =   "DLOS"
}