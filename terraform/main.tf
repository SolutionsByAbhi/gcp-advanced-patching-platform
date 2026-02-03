
---

##  Terraform  –  OS  Config  patching

###  `terraform/main.tf`

```hcl
terraform  {
    required_version  =  ">=  1.5.0"

   required_providers  {
        google  =  {
            source    =  "hashicorp/google"
           version  =  "~>  5.0"
        }
    }
}

provider  "google"  {
   project  =  var.project_id
    region    =  var.region
}

resource  "google_os_config_patch_deployment"  "prod_weekly"  {
    name               =  "prod-weekly-patching"
    project          =  var.project_id
    description  =  "Weekly  patching  for prod  instances"

    instance_filter  {
        group_labels  {
            labels  =  {
               env                  =  "prod"
               patch_group  =  "wave1"
            }
        }
   }

    patch_config  {
        reboot_config  =  "DEFAULT"

        apt  {
           type  =  "DIST"
        }

        yum  {
           security  =  true
        }

        goo  {
           enabled  =  true
        }

        pre_step  {
           linux_exec_step_config  {
                local_path  =  "/usr/local/bin/pre_patch.sh"
            }
       }

        post_step  {
            linux_exec_step_config  {
               local_path  =  "/usr/local/bin/post_patch.sh"
            }
        }
   }

    recurring_schedule  {
        time_zone  =  "Europe/Berlin"

        weekly  {
           day_of_week  =  "SUNDAY"
        }

        time_of_day  {
           hours      =  2
            minutes  =  0
           seconds  =  0
            nanos      =  0
        }
   }
}
