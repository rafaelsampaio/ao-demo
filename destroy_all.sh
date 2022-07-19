#! /bin/bash
cd 3-as3
terraform destroy -auto-approve
cd ..
cd 2-app
terraform destroy -auto-approve
cd ..
cd 1-infra
terraform destroy -auto-approve
cd ..
