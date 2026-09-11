# AWS EC2 VM

This Terraform configuration provisions one low-cost EC2 instance using:

- `t2.micro` by default
- Amazon Linux 2023 from the AWS public SSM parameter
- The default VPC and first available default subnet
- An 8 GiB encrypted `gp3` root volume
- No NAT gateway, load balancer, or extra paid networking resources
- SSH ingress disabled unless `allowed_ssh_cidr` is configured

## Usage

1. Update `terraform.tfvars` with your AWS region and, if needed, an existing EC2 key pair name and your public IP CIDR.
2. Initialize and validate:

   ```powershell
   terraform init
   terraform fmt -check
   terraform validate
   ```

3. Review and apply:

   ```powershell
   terraform plan -var-file="terraform.tfvars"
   terraform apply -var-file="terraform.tfvars"
   ```

4. Destroy the resources when finished to avoid ongoing charges:

   ```powershell
   terraform destroy -var-file="terraform.tfvars"
   ```