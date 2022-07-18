# Automation and Orchestration Toolchain

**READ** the instructions before trying the commands.

If you come across any errors, make sure you have read and followed the instructions, in the order they appeared.

## Technology

- [Terraform](https://www.terraform.io/)
- [Google Cloud Platform](https://cloud.google.com/)
- [F5 Automation and Orchestration Toolchain](https://www.f5.com/products/automation-and-orchestration)

## Prepare the demo

It's highly recommended to use WSL in Windows or a Linux Virtual Machine in MacOS. All steps belows are for Linux, if you are using a different OS, make sure that **you** change all commands as needed.

Install all required tools and set your own variable set.

Install these tools using your preferred way (brew, apt, manually, ...):

- git
- terraform

## Demo

### Part 1 - Building up the infrastructure

In the 1st part of the demo, we will create the infrastructure required by our application, including network resouces, forwarding rules and compute instances. First, clone te repo with Terraform files.

```bash
git clone https://github.com/rafaelsampaio/ao-demo.git
cd 1-infra
```

In ```1-infra```, rename the file [terraform.tfvars.example](1-infra/terraform.tfvars.example) to ```terraform.tfvars``` and set your own variables. Please, use your username as ```prefix```, no capital letters.

```hcl
prefix       = ""
gcp-project  = ""
gcp-region   = ""
gcp-zone     = ""
gcp-svc-acct = ""
```

You can find other available images using the command below.

```bash
gcloud compute images list --project=f5-7626-networks-public | grep f5-bigip
```

Don't forget to set you admin password.

```hcl
bigip-passwd   = ""
```

And set these vars with your username.

```hcl
tag-environment = "demo"
tag-owner       = "demo"
tag-group       = "demo"
```

Take a look at the ```.tf``` files, check all the resources that were declared and how the Runtime Init and Declarative Onboarding files. The ```.tpl``` files use variables that will be fulfilled on runtime to relevant values. So, you can use *generic* declarations and let Terraform render your final application declaration. Using a terminal, change to the folder ```1-infra```, and use the command below to init Terraform.

```bash
terraform init
```

Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan.

```bash
terraform plan
```

Verify that the plan is as expected and start implementation, confirming with ```yes```.

```bash
terraform apply
```

It'll take about 5-10 minutes to finish Declarative Onboarding setup. Look for the ```terraform.tfstate``` and check its content.
The output will give you the management IP address and you must use the user ``admin``` with the password you defined.

Take note of all outputs, you will need some of them in next step. If you need to print the outputs another time, try the following command:

```bash
terraform output
```

Open the file ```terraform.tfstate``` to see all resources managed by Terraform. Using CLI, use the command:

```bash
terraform state list
```

or, to show the attributes of a resource in the Terraform state:

```bash
terraform state show RESOURCE_NAME
```

### Part 2 - Deploying the app

In ```2-app```, rename the file [terraform.tfvars.example](2-app/terraform.tfvars.example) to ```terraform.tfvars``` and set your own variables. Please, use your username as ```prefix``` as the previus step.

```hcl
prefix      = ""
gcp-project = ""
gcp-region  = ""
gcp-zone    = ""
```

Set the vars ```app-target-instance``` and ```app-target-network``` to the values of the output from previus step.

```hcl
app-target-instance = ""
app-target-network  = ""
```

Set the ```server-network``` and ```server-subnetwork``` to the values of the output from previus step. The ```server-machine``` and ```server-image``` will be provided to you.

```hcl
server-machine    = ""
server-image      = ""
server-network    = ""
server-subnetwork = ""
```

And set these vars with your username and set your own ```tag-application```.

```hcl
tag-environment = ""
tag-owner       = ""
tag-group       = ""
tag-application = "YOUR_PREFIX-app"
```

Take a look at the ```.tf``` files, check all the resources that were declared. Using a terminal, change to the folder ```2-app```, and use the command below to init, plan and apply the declarations. Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan. Verify that the plan is as expected and start implementation, confirming with ```yes```.

```bash
cd ../2-app
terraform init
terraform plan
terraform apply
```

### Part 3 - Deploying Application Services

In ```3-as3```, rename the file [terraform.tfvars.example](3-as3/terraform.tfvars.example) to ```terraform.tfvars``` and set your own variables.
Use the BIG-IP management IP address output from the 1st step, as the password that you set.

```hcl
bigip-address = ""
bigip-passwd = ""
```

From the 2nd step, set the application node IP address and the public IP address.

```hcl
app-address  = ""
app-node-ip  = ""
````

And set the applications vars. For ```app-region```, use the same of Part 2.

```hcl
app-tenant    = ""
app-name      = ""
app-region    = ""
app-tag       = "YOUR_PREFIX-app"
```

#### Part 3a - Basic application service

In this part of the demo, you'll create a simple appication using AS3. Take a look at the ```.tf``` and ```appBasic.json.tpl``` files, check all the resources that were declared.
Using a terminal, change to the folder ```3-as3```, and use the command below to init, plan and apply the declarations. Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan. Verify that the plan is as expected and start implementation, confirming with ```yes```.

```bash
cd ../3-as3
terraform init
terraform plan
terraform apply
```

The Terraform output will show your application URL. Navigate to that site and test your application.
Navigate to BIG-IP Configuration Utility and verify the Tenant, Virtual Server, Pool and Pool Members.

### Part 3b - TLS, Security and Analytics

In this part of the demo, you'll create a complete Applicatino Services for your appication using AS3, including TLS, Analytics, Application Security and Service Discovery.
Take a look at the ```.tf``` and ```appServiceDiscoveryTLS.json.tpl``` files, check all the resources that were declared.
In [as3.tf](3-as3/as3.tf), comment the Part 1 Basic App and remove the comments for the Part 2.
Using a terminal, apply the declaration. Check for any error and fix them. Test the plan and verify that the plan is as expected and start implementation, confirming with ```yes```.

```bash
terraform plan
terraform apply
```

Navigate to BIG-IP Configuration Utility and verify the Tenant, Virtual Server, Pool and Pool Members, Analytics Profiles, and Network and Application Security.

Go back to ```2-app``` folder, update the [app.tf](2-app/app.tf) and change the resource counter from 1 to 3.

```hcl
resource "google_compute_instance_from_machine_image" "app" {
  count        = 3
  provider     = google-beta
  name         = "${var.prefix}-server-${count.index}"
...
```

Use ```terraform apply``` to update your declaration and check in the BIG-IP Configuration Utility how your pool members are updated dynamically.

```bash
terraform apply
```

### Final

Don't forget to destroy your resources by the end of the demo. First, destroy your application resources.

```bash
cd 2-app
terraform destroy -auto-approve
```

Then, destroy your infrastructure.

```bash
cd 1-infra
terraform destroy -auto-approve
```
