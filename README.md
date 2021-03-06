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

Login to Google Cloud and set the user credentials to use for Application Default Credentials. Follow the instructions from the commands:

```bash
gcloud auth login
gcloud auth application-default login
```

## Demo

### Part 1 - Building up the infrastructure

In the 1st part of the demo, you will create the infrastructure required by our application, including network resouces, forwarding rules and compute instances. First, clone te repo with Terraform files.

```bash
mkdir ~/appservices/
cd ~/appservices/
git clone https://github.com/rafaelsampaio/ao-demo.git
cd ~/appservices/ao-demo/1-infra
echo "Your current folder: `pwd`"
```

In `1-infra`, rename the file [terraform.tfvars.example](1-infra/terraform.tfvars.example) to `terraform.tfvars` and set the variable for the blocks **Google Environment** and **Part 1**. Please, use your username as `prefix`, no capital letters. At this time, please ignore the other blocks.

```hcl
####### Google Environment
prefix       = "CHANGE_THIS!!!"
gcp-project  = ""        #use the project id
gcp-region   = ""
gcp-zone     = ""
gcp-svc-acct = ""        #use your service account with the email format

####### Part 1
#Part 1 - BIG-IP
bigip-passwd   = ""

####### Part 2
#Part 2 - App Forwarding Rules
app-target-instance = "" #Get this from Part 1 output
app-target-network  = "" #Get this from Part 1 output

#Part 2 - Server Compute Engine
server-network    = ""   #Get this from Part 1 output
server-subnetwork = ""   #Get this from Part 1 output

####### Part 3
#Part 3 - BIG-IP
bigip-address = ""       #Get this from Part 1 output

#Part 3 - AS3
app-address   = ""       #Get this from Part 2 output
app-node-ip   = ""       #Get this from Part 2 output
```

Get your project list with the command:

```bash
gcloud projects list
```

To find the available region, use the command:

```bash
gcloud compute regions list
```

Choose your zone using the command, replace *YOUR_REGION* by the chosen region:

```bash
gcloud compute zones list | grep YOUR_REGION
```

***Tip***: You can find other BIG-IP images using the command:

```bash
gcloud compute images list --project=f5-7626-networks-public | grep f5-bigip
```

Take a look at the `.tf` files, check all the resources that were declared and how the Runtime Init ([`startup-script.sh.tftpl`](1-infra/startup-script.sh.tftpl)) and Declarative Onboarding ([`do.json.tftpl`](1-infra/do.json.tftpl)) files use variables for interpolation within the template, the sequences delimited with `${` ... `}`.

Using template file, you can use *generic* declarations and let Terraform render your final application declaration. Using a terminal, in the folder `1-infra`, use the command below to init Terraform. This will download all required providers and modules.

```bash
terraform init
```

Check for any error and fix them. After the Terraform download all required providers and modules, test the plan.
***NOTE:*** Ignore any *Warning* related to undeclared variable.

```bash
terraform plan
```

Verify that the plan is as expected and start the implementation. Type `yes` whe asked.

```bash
terraform apply
```

It'll take about 5-10 minutes to finish Declarative Onboarding setup. Meanwhile, take a look at the state in `terraform.tfstate` and check its content.

***Tip:*** If you want to follow the BIG-IP boot and configuration process, use the command below in another terminal. To disconnect from the serial console, press the *ENTER* key, type ```~.``` (tilde, followed by a period).

```bash
gcloud compute connect-to-serial-port `terraform output -raw console-bigip-name` --zone=`terraform output -raw console-bigip-zone`
```

The output will give you the management IP address and other useful information. Take note of all outputs, you will need some of them in next steps. If you need to print the outputs another time, try the following command:

```bash
terraform output
```

To access Config Utility, you must use the user `admin` and the password you defined.

Open the file `terraform.tfstate` to see all resources in the state file. To list the resources, use the command:

```bash
terraform state list
```

To show the attributes of a resource in the Terraform state, try the command replacing *RESOURCE_NAME* by the name of the resource:

```bash
terraform state show RESOURCE_NAME
```

### Part 2 - Deploying the app

Copy the `terraform.tfvars` from the folder `1-infra` to the folder `2-app`.

```bash
cp ~/appservices/ao-demo/1-infra/terraform.tfvars ~/appservices/ao-demo/2-app/
cd ~/appservices/ao-demo/2-app
echo "Your current folder: `pwd`"
```

Edit the file `2-app\terraform.tfvars` to update the **Part 2** block. Set the vars `app-target-instance` and `app-target-network` in `2-app\terraform.tfvars` to the values of the output from previus step, also set the `server-network` and `server-subnetwork`.

```hcl
...
#Part 2 - App Forwarding Rules
app-target-instance = "" #Get this from Part 1 output
app-target-network  = "" #Get this from Part 1 output

#Part 2 - Server Compute Engine
server-network    = ""   #Get this from Part 1 output
server-subnetwork = ""   #Get this from Part 1 output
...
```

***Tip***: To avoid Terraform having to redeploy the forwarding rule, replace ***v1*** by ***beta*** between `compute/` and `/projects` in variable `app-target-network`. Your var will be something like `https://www.googleapis.com/compute/beta/projects/PROJECT_ID/global/networks/OBJECT_NAME`.

Take a look at the `.tf` files, check all the resources that were declared. Using a terminal, go to the folder `2-app`, and use the command below to init, plan and apply the declarations. Check for any error and fix them.

After the Terraform download all required providers, resouces and modules, test the plan. Verify that the plan is as expected and start implementation by confirming with `yes`.

```bash
cd ~/appservices/ao-demo/2-app
echo "Your current folder: `pwd`"
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

### Part 3 - Deploying Application Services

Copy the `terraform.tfvars` from `2-app` to `3-as3` and update the Part 3 block.

```bash
cp ~/appservices/ao-demo/2-app/terraform.tfvars ~/appservices/ao-demo/3-as3/
cd ~/appservices/ao-demo/3-as3
echo "Your current folder: `pwd`"
```

Edit the file `3-as3\terraform.tfvars` and edit the `bigip-address` to use the BIG-IP management IP address output from the 1st step. From the 2nd step, set the application node IP address `app-node-ip` and the public IP address `app-address`.

```hcl
...
#Part 3 - BIG-IP
bigip-address = ""       #Get this from Part 1 output

#Part 3 - AS3
app-address   = ""       #Get this from Part 2 output
app-node-ip   = ""       #Get this from Part 2 output
...
```

#### Part 3a - Basic application service

In this part of the demo, you'll create a simple application using AS3. Take a look at the `.tf` and [`appBasic.json.tftpl`](3-as3/appBasic.json.tftpl) files, check all the resources that were declared.

The AS3 declaration include a single Tenant, a single Application with a single HTTP Service with Pool and its Pool Members. Can you identity those elements in the AS3 declaration?

Using a terminal, change to the folder `3-as3`, and use the command below to init, plan and apply the declarations. Check for any error and fix them. After the Terraform download all required providers, resouces and modules, test the plan and check it. Take a time to see how is the final version of the AS3 declaration. Apply by confirming with `yes`.

```bash
cd ~/appservices/ao-demo/3-as3
echo "Your current folder: `pwd`"
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

The Terraform will output your application URL. Navigate to that site and test your application.

Go to BIG-IP Config Utility and verify the Tenant (Partition), Application (Folder), Virtual Server, Pool and Pool Members.

### Part 3b - TLS, Security and Analytics

In this part of the demo, you will create a richful set of Application Services with more functionality and features using AS3, including TLS, Analytics, Application and Network Security and Service Discovery.

In [as3.tf](3-as3/as3.tf), comment the Part 1 Basic App (line 3 and 15) and remove the comments for the Part 2 (lines 6, 18-21).

```hcl
data "template_file" "app-declaration" {
  #Part 1: Basic app (appBasic.json.tftpl)
  #template = file("${path.module}/appBasic.json.tftpl")

  #Part 2: App with Service Discovery and TLS (appServiceDiscoveryTLS.json.tftpl)
  template = file("${path.module}/appServiceDiscoveryTLS.json.tftpl")

  vars = {
    app_tenant    = var.app-tenant
    app_name      = var.app-name
    app_address   = var.app-address
    app_node_port = var.app-node-port

    #Part 1: Basic app (appBasic.json.tftpl)
    #app_node_ip = var.app-node-ip

    #Part 2: App with Service Discovery and TLS (appServiceDiscoveryTLS.json.tfpl)
    app_tag         = "${var.prefix}-app"
    app_region      = var.gcp-region
    app_certificate = replace(tls_self_signed_cert.app-certificate.cert_pem, "/\n/", "\\n")
    app_private_key = replace(tls_private_key.app-private-key.private_key_pem, "/\n/", "\\n")
  }
}

resource "bigip_as3" "as3-app" {
  as3_json = data.template_file.app-declaration.rendered
}
```

Take a look at the and [`appServiceDiscoveryTLS.json.tftpl`](3-as3/appServiceDiscoveryTLS.json.tftpl) file, check all the resources that were declared.

The AS3 declaration include a single Tenant, a single Application with a single HTTPS Service with Pool without Pool Members, TLS configuration, Analytics, Network Security, Application Security and Logging. Can you identity all those elements in the AS3 declaration?

Test the plan, take a time to see how is the final version of the AS3 declaration. Check for any errors and fix them. Apply the new AS3 declaration by confirming with `yes`.

```bash
terraform plan
```

```bash
terraform apply
```

Go to to BIG-IP Configuration Utility and verify the Tenant (Partition), Application (Folder), Virtual Server, Pool and Pool Members, TLS, Analytics Profiles, and Application and Network Security.

Did you notice that there is only one Service in AS3 but two Virtual Servers were created in the same Application? Can you explain why?

And how were the Application Security settings (WAF policies) applied? Where did the Application Security configurations come from? What about the Network Security?

Did you notice how Pool Members were configured? What if the application team increases the number of servers?

Edit the file [2-app\app.tf](2-app/app.tf) and change the resource counter from 1 to 3.

```hcl
...
resource "google_compute_instance_from_machine_image" "app" {
  count        = 3 #change from 1 to 3
  provider     = google-beta
  name         = "${var.prefix}-server-${count.index}"
...
```

Use `terraform plan` in the folder `2-app` to plan the update to the application declaration. By looking at the `+`, `-` and `~` symbols, can you identify what changes will be made?

```bash
cd ~/appservices/ao-demo/2-app
echo "Your current folder: `pwd`"
terraform plan
```

Apply the changes. While the changes are applied, go back to the BIG-IP Config Utility, check the Pool Members and how the pool members are updated dynamically (refresh the list).

```bash
terraform apply -auto-approve
```

Go back to your application, create an account, make some purchases, post a comment, and try to attack the application. Then, go back to BIG-IP Config Utility and check the HTTP and TCP analytics and Application Security loggings.

Try attacking your application with, for example, a script in the comment form and check the response and Application Security loggings.

### Final

Don't forget to destroy your resources by the end of the demo. Go back to the root folder of the project and use the `destroy_all.sh`.

```bash
cd ~/appservices/ao-demo/
echo "Your current folder: `pwd`"
chmod +x destroy_all.sh
./destroy_all.sh
```

## Extra

Other useful Terraform commands:

- `terraform fmt`: Rewrites all Terraform configuration files to a canonical format. Both configuration files (.tf) and variables files (.tfvars) are updated.
- `terraform validate`: Validate the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.
- `terraform graph`: Produces a representation of the dependency graph between different objects in the current configuration and state. Paste the output in [Graphviz Online](https://dreampuf.github.io/GraphvizOnline/) to see the dependencies.
