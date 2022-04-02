variable "apps" {
  type = map(any)
  default = {
    "foo" = {
      "region" = "us-east-1",
    },
    "bar" = {
      "region" = "eu-west-1",
    },
    "baz" = {
      "region" = "ap-south-1",
    },
  }
}


  variable "solr_cluster_size_per_az" {
    description = "Cluster size for Solr per AZ (by workspace)"
    # Note: changing this would result in ASG creating (or potentially destroying) Solr nodes.
    default = {
      "v5-dev"  = {
        "us-east-1a" = 1
        "us-east-1b" = 1
        "us-east-1c" = 2
      }
      "v5-qa"   = {
        "us-east-1a" = 1
        "us-east-1b" = 1
        "us-east-1c" = 2
      }
      "v5-prod" = {
        "us-east-1a" = 43
        "us-east-1b" = 43
        "us-east-1c" = 42
      }
    }
  }

  variable "zookeeper_cluster_size_per_az" {
    description = "Cluster size for Zookeeper per AZ (by workspace)"

    # Note: changing this would result in ASG creating (or potentially destroying) Zookeeper nodes.
    # Also currently every created node has cluster size baked into its userdata, so this should be changed very carefuly if ever.
    default = {
      "v5-dev"  = 1
      "v5-qa"   = 1
      "v5-prod" = 2
    }
  }

  variable "solr_availability_zone_count" {
    description = "Number of availability zones to use for Solr (by workspace)"

    default = {
      "v5-dev"  = 3
      "v5-qa"   = 3
      "v5-prod" = 3
    }
  }

  variable "zookeeper_availability_zone_count" {
    description = "Number of availability zones to use for Zookeeper (by workspace)"

    default = {
      "v5-dev"  = 3
      "v5-qa"   = 3
      "v5-prod" = 3
    }
  }


locals {
  solr_availability_zone_count = var.solr_availability_zone_count["v5-prod"]
  solr_cluster_size_per_az = var.solr_cluster_size_per_az["v5-prod"]
  zookeeper_cluster_size_per_az = var.zookeeper_cluster_size_per_az["v5-prod"]
  zookeeper_availability_zone_count = var.zookeeper_availability_zone_count["v5-prod"]

}

output "len_solr" {
  value = length(local.solr_cluster_size_per_az) 
}

output "avail_count" {
  value = local.solr_availability_zone_count
}

output "solr_cluster_size" {
  value = sum(values(local.solr_cluster_size_per_az))
}



#
#
#resource "null_resource" "dmns_calc_l" {
#  count = "${length(local.num_cntd_and_zero_l) - 1}"
#
#  triggers = {
#    num_calc_l = "${local.num_cntd_and_zero_l[count.index] + local.num_cntd_and_zero_l[count.index + 1]}"
#  }
#}
#
