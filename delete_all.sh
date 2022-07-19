#! /bin/bash
cd 2-app
terraform destroy -auto-approve
cd ..
cd 1-infra
terraform destroy -auto-approve
cd ..
