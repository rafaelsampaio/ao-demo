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
- terraform 1.2 or later

## Demo

### Part 1 - Building up the infrastructure

In the 1st part of the demo, you will create the infrastructure required by our application, including network resouces, forwarding rules and compute instances. First, clone te repo with Terraform files.

```bash
git clone https://github.com/rafaelsampaio/ao-demo.git
cd 1-infra
```

In ```1-infra```, rename the file [terraform.tfvars.example](1-infra/terraform.tfvars.example) to ```terraform.tfvars``` and set the variable for the blocks *Google Environment*, *Labels*, and *Part 1 - BIG-IP*. Please, use your username as ```prefix```, no capital letters. At this time, please ignore the other blocks.

```hcl
#Google Environment
prefix       = "CHANGE_THIS!!!"
gcp-project  = ""
gcp-region   = ""
gcp-zone     = ""
gcp-svc-acct = "" #use your service account with the email format

#Part 1 - BIG-IP
bigip-passwd   = ""

#Part 2 - App Forwarding Rules
app-target-instance = "" #Get this from Part 1 output
app-target-network  = "" #Get this from Part 1 output

#Part 2 - Server Compute Engine
server-network    = "" #Get this from Part 1 output
server-subnetwork = "" #Get this from Part 1 output

#Part 3 - BIG-IP
bigip-address = "" #Get this from Part 1 output

#Part 3 - AS3
app-address   = ""        #Get this from Part 2 output
app-node-ip   = ""        #Get this from Part 2 output
```

Choose your project from the list:

```bash
gcloud projects list
```

To find the available region, use the command:

```bash
gcloud compute regions list
```

Choose your zone using the command, replacing *YOUR_REGION* with the chosen region:

```bash
gcloud compute zones list | grep YOUR_REGION
```

***Tip***: You can find other BIG-IP images using the command:

```bash
gcloud compute images list --project=f5-7626-networks-public | grep f5-bigip
```

Take a look at the ```.tf``` files, check all the resources that were declared and how the Runtime Init and Declarative Onboarding files. The ```.tpl``` files use variables that will be fulfilled on runtime to relevant values. So, you can use *generic* declarations and let Terraform render your final application declaration. Using a terminal, change to the folder ```1-infra```, and use the command below to init Terraform.

```bash
terraform init
```

Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan.

```bash
terraform plan
```

***NOTE:*** Ignore any *Warning* related to undeclared variable.
Verify that the plan is as expected and start implementation. Type ```yes``` whe asked.

```bash
terraform apply
```

It'll take about 5-10 minutes to finish Declarative Onboarding setup. Look for the ```terraform.tfstate``` and check its content.

***Tip:*** If you want to follow the BIG-IP boot and configuration process, use the command below in another terminal. To disconnect from the serial console, press the *ENTER* key, type ```~.``` (tilde, followed by a period).

```bash
gcloud compute connect-to-serial-port `terraform output -raw console-bigip-name` --zone=`terraform output -raw console-bigip-zone`
```

The output will give you the management IP address and other useful information.
To access Config Utility, you must use the user ``admin``` and the password you defined.
Take note of all outputs, you will need some of them in next step. If you need to print the outputs another time, try the following command:

```bash
terraform output
```

Open the file ```terraform.tfstate``` to see all resources in the state file. To list the resources, use the command:

```bash
terraform state list
```

To show the attributes of a resource in the Terraform state by replacing *RESOURCE_NAME* with the name of the resource:

```bash
terraform state show RESOURCE_NAME
```

### Part 2 - Deploying the app

Copy the ```terraform.tfvars``` from ```1-infra``` to ```2-app``` and update the Part 2 block.
Set the vars ```app-target-instance``` and ```app-target-network``` to the values of the output from previus step.
Set the ```server-network``` and ```server-subnetwork``` to the values of the output from previus step.

```hcl
...
#Part 2 - App Forwarding Rules
app-target-instance = "" #Get this from Part 1 output
app-target-network  = "" #Get this from Part 1 output

#Part 2 - Server Compute Engine
server-network    = "" #Get this from Part 1 output
server-subnetwork = "" #Get this from Part 1 output
...
```

***Tip***: To avoid Terraform having to redeploy the forwarding rule, replace ***v1*** for ***beta*** between ```compute/``` and ```/projects``` in variable ```app-target-network```. Your var will be something like ```https://www.googleapis.com/compute/beta/projects/PROJECT_ID/global/networks/OBJECT_NAME```.

Take a look at the ```.tf``` files, check all the resources that were declared. Using a terminal, change to the folder ```2-app```, and use the command below to init, plan and apply the declarations. Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan. Verify that the plan is as expected and start implementation by confirming with ```yes```.

```bash
cd ../2-app
terraform init
terraform plan
terraform apply
```

### Part 3 - Deploying Application Services

Copy the ```terraform.tfvars``` from ```2-app``` to ```3-as3``` and update the Part 3 block.
Use the BIG-IP management IP address output from the 1st step, as the password that you set.
From the 2nd step, set the application node IP address ```app-node-ip``` and the public IP address ```app-address```.

```hcl
#Part 3 - BIG-IP
bigip-address = "" #Get this from Part 1 output

#Part 3 - AS3
app-address   = ""        #Get this from Part 2 output
app-node-ip   = ""        #Get this from Part 2 output
app-tenant    = "AO-DEMO" #AS3 Tenant
app-name      = "AO-DEMO" #AS3 Application
app-node-port = "8000"
```

#### Part 3a - Basic application service

In this part of the demo, you'll create a simple appication using AS3. Take a look at the ```.tf``` and ```appBasic.json.tpl``` files, check all the resources that were declared.
Using a terminal, change to the folder ```3-as3```, and use the command below to init, plan and apply the declarations. Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan and check it. Take a time to see how is the final version of the AS3 declaration. Apply by confirming with ```yes```.

```bash
cd ../3-as3
terraform init
terraform plan
terraform apply
```

The Terraform will output your application URL. Navigate to that site and test your application.
Go to BIG-IP Configuration Utility and verify the Tenant (Partition), Application (Folder), Virtual Server, Pool and Pool Members.

### Part 3b - TLS, Security and Analytics

In this part of the demo, you will create a set of Application Services with more functionality and features using AS3, including TLS, Analytics, Application and Network Security and Service Discovery.
Take a look at the ```.tf``` and ```appServiceDiscoveryTLS.json.tpl``` files, check all the resources that were declared.
In [as3.tf](3-as3/as3.tf), comment the Part 1 Basic App (line 3 and 15) and remove the comments for the Part 2 (lines 6, 18-21).
Test the plan, take a time to see how is the final version of the AS3 declaration. Check for any errors and fix them. Apply the new AS3 declaration by confirming with ```yes```.

```bash
terraform plan
terraform apply
```

Go to to BIG-IP Configuration Utility and verify the Tenant (Partition), Application (Folder), Virtual Server, Pool and Pool Members, TLS, Analytics Profiles, and Application and Network Security.

Did you notice that there is only one Service in AS3 but two Virtual Servers were created in the same Application? Can you explain why?
And how were the Application Security settings (WAF policies) applied?
Did you notice how pool members were configured? What if the application team increases the number of servers?

Go back to ```2-app``` folder, update the [app.tf](2-app/app.tf) and change the resource counter from 1 to 3.

```hcl
...
resource "google_compute_instance_from_machine_image" "app" {
  count        = 3 #change from 1 to 3
  provider     = google-beta
  name         = "${var.prefix}-server-${count.index}"
...
```

Use ```terraform apply``` in ```2-app``` to update the application declaration and check the Pool Members in the BIG-IP Config Utility how your pool members are updated dynamically.

```bash
terraform apply -auto-approve
```

Go back to your application, create an account, make some purchases, post a comment, and try to attack the application. Then, go back to Config Utility and check the HTTP and TCP analytics and Application Security loggings.

### Final

Don't forget to destroy your resources by the end of the demo. First, destroy your application resources.

```bash
cd 2-app
terraform destroy -auto-approve
cd ..
```

Then, destroy your infrastructure.

```bash
cd 1-infra
terraform destroy -auto-approve
cd ..
```
