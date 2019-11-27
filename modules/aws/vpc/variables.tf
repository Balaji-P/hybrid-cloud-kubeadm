provider "google" {
  project     = "multicloud-kubernetes"
  region    =   "us-east1"
}

provider "aws" {
  region = "us-east-1"
}


provider "aws" {
  region = "us-east-2"
  alias = "ohio"
}

variable "cloud" {
    description = "Cloud platform on which we need to the deployment"
    type        = list(string)
    default = ["AWS"]
}

variable "gcp_region" {
    description = "GCP region in which we need to deploy"
    type    =   string
    default =   "us-east1"
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

variable GCP_TUN1_VPN_GW_ASN {
  description = "Tunnel 1 - Virtual Private Gateway ASN, from the AWS VPN Customer Gateway Configuration"
  default = "64512"
}

variable GCP_TUN1_CUSTOMER_GW_INSIDE_NETWORK_CIDR {
  description = "Tunnel 1 - Customer Gateway from Inside IP Address CIDR block, from AWS VPN Customer Gateway Configuration"
  default = "30"
}

variable GCP_TUN2_VPN_GW_ASN {
  description = "Tunnel 2 - Virtual Private Gateway ASN, from the AWS VPN Customer Gateway Configuration"
  default = "64512"
}

variable GCP_TUN2_CUSTOMER_GW_INSIDE_NETWORK_CIDR {
  description = "Tunnel 2 - Customer Gateway from Inside IP Address CIDR block, from AWS VPN Customer Gateway Configuration"
  default = "30"
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
    default =   "chitender_kumar"
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