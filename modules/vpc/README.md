# The Network Module IAC

### Intro:
The main intention behind having this module is to enable users to create network in a matter of minutes

### Usage:
The Module usage is fairly simple! Let's look at the snippet below

```json
module "vpc" {
  source = "git::ssh://bitbucketURL/my_repo.git?ref=BranchName"

  project-id               = "odin-thirteen"
  is-network-created       = false
  regions                  = ["us-central1"]
  ip-cidrs                 = ["10.0.130.0/24"]
  source-tags              = []
  target-tags              = []
  enable-advanced-features = true
}
```
##### Variable Reference
1. project-id : The GCP Project ID
2. is-network-created : by default its "false" 
3. regions : list of regions e.g ["us-central1", "us-west1"]
4. ip-cidrs : List of IP ranges
5. source-tags : source tag list for firewall rules
6. target-tsgs : target tag list for firewall rules
7. enable-advanced-features : true
