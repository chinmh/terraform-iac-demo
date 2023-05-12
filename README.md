# Introduction
In this demo, the following infrastructure will be created.
![](screenshot/HLD.png)

# How to start the demo
Please ensure your test machine have the following pre-requisite:
1. Git clone this repository to your test machine.
2. Ensure Terraform CLI tool is installed. Please refer to this [documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
3. Ensure AWS access key id and secret key is created with **Right Permission**. Please refer to this [documentation](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
4. Create a S3 bucket with a new unique name, this is to store terraform statefile.

Once the pre-requisite item is ready, you may follow the following steps to setup the demo:
1. Git clone this repository to the test machine.
2. Ensure the AWS access key id and secret key is setup as environment variable. Here is the sample in Windows Machine:
![](screenshot/environment-variable.png)
3. Update the s3 bucket name in provider.tf line 16 with the name created in pre-requisite item 4.
4. Once this is done, you may execute the following command:
```
terraform init
terraform plan
terraform apply -auto-approve
```
5. When execute terraform plan, you shall see the following output at the end:
```
Plan: 23 to add, 0 to change, 0 to destroy.
```
6. Once complete terraform apply, you may check your AWS account for the resources.