I just completed Project 4 of my security portfolio: **terraform-cloud-deploy** — a production-grade AWS infrastructure deployment using Terraform IaC.

🔧 What I built:

- **VPC** with public subnet, Internet Gateway, and route table
- **EC2** instance (Amazon Linux 2023) with a hardened security group — SSH restricted to allowlisted CIDRs, HTTP/HTTPS open
- **S3 bucket** with AES-256 server-side encryption, versioning enabled, and public access fully blocked
- **IAM role** following least-privilege principles — scoped S3 permissions, SSM access, and CloudWatch Logs for observability
- **GitHub Actions CI** pipeline running on every push to `main`:
  - `terraform fmt -check -recursive` — enforces canonical style
  - `terraform init -backend=false` — resolves providers without remote state
  - `terraform validate` — checks HCL syntax and resource references
  - `terraform plan` (dry-run with mock credentials) — exercises full provider logic

📁 All variables are parameterised with sensible defaults. The bucket name is auto-generated via the `random` provider to guarantee global uniqueness.

🔒 Security highlights:
- No hardcoded credentials anywhere in the codebase
- S3 public access block enforced at the bucket level
- IAM role scoped to minimum required actions
- SSH access defaults to deny-all (`[]`)

This is part of a 4-project portfolio series covering Python security tooling, .NET Core APIs, and cloud infrastructure.

🔗 GitHub: https://github.com/SumitSonkusale/terraform-cloud-deploy

#Terraform #AWS #IaC #CloudSecurity #DevSecOps #GitHub #Infrastructure #Cloud
