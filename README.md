# terraform-cloud-deploy

![CI](https://github.com/SumitSonkusale/terraform-cloud-deploy/actions/workflows/ci.yml/badge.svg)

Terraform Infrastructure-as-Code project that provisions a secure, production-pattern AWS environment. Covers VPC, public subnets, EC2 with IMDSv2 enforcement, IAM least-privilege roles, and an S3 bucket with encryption and versioning — all validated by a GitHub Actions CI pipeline on every push.

---

## Infrastructure Overview

```
tf-cloud-deploy/
├── main.tf        # Provider, VPC, subnets, IGW, route tables
├── ec2.tf         # Security group + hardened EC2 instance
├── iam.tf         # IAM role, instance profile, SSM + CloudWatch policies
├── s3.tf          # S3 bucket (encryption, versioning, public-access block)
├── variables.tf   # All input variables with sensible defaults
├── outputs.tf     # Useful post-apply output values
└── versions.tf    # Terraform and provider version pins
```

---

## Resources Provisioned

| Resource | Details |
|---|---|
| `aws_vpc` | Custom VPC with DNS support enabled |
| `aws_subnet` (public) | Public subnet with `map_public_ip_on_launch = true` |
| `aws_internet_gateway` | IGW attached to the VPC |
| `aws_route_table` | Route table directing 0.0.0.0/0 to the IGW |
| `aws_security_group` | Allows SSH (22), HTTP (80), HTTPS (443) inbound; all egress |
| `aws_instance` | Amazon Linux 2023, gp3 encrypted root volume, IMDSv2 required |
| `aws_iam_role` | EC2 assume-role with `AmazonSSMManagedInstanceCore` + `CloudWatchAgentServerPolicy` |
| `aws_s3_bucket` | AES-256 SSE, versioning enabled, public access blocked, 90-day lifecycle |

---

## Security Highlights

- **IMDSv2 enforced** on the EC2 instance (`http_tokens = "required"`) — prevents SSRF-based metadata abuse
- **No hard-coded credentials** — instance uses an IAM instance profile; SSM Session Manager removes the need for port 22 in production
- **S3 public access fully blocked** — all four public-access-block settings enabled
- **Encrypted root volume** (gp3, AES-256)
- **Least-privilege IAM** — only SSM and CloudWatch permissions, nothing else
- **Default tags** applied to every resource via provider `default_tags`

---

## Prerequisites

- [Terraform >= 1.5](https://developer.hashicorp.com/terraform/install)
- AWS credentials configured (`aws configure` or environment variables)

---

## Quick Start

```bash
git clone https://github.com/SumitSonkusale/terraform-cloud-deploy.git
cd terraform-cloud-deploy

terraform init
terraform plan
terraform apply
```

### Override defaults

```bash
terraform apply \
  -var="aws_region=eu-west-2" \
  -var="project=myproject" \
  -var="environment=prod" \
  -var="key_name=my-keypair"
```

---

## Variables

| Name | Default | Description |
|---|---|---|
| `aws_region` | `eu-west-2` | AWS region |
| `project` | `tcdev` | Short project identifier |
| `environment` | `dev` | Deployment environment |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR block |
| `public_subnet_cidr` | `10.0.1.0/24` | Public subnet CIDR |
| `ami_id` | Amazon Linux 2023 (eu-west-2) | EC2 AMI |
| `instance_type` | `t3.micro` | EC2 instance type |
| `key_name` | `""` | EC2 key pair name (optional) |
| `allowed_ssh_cidrs` | `["0.0.0.0/0"]` | SSH allowed CIDRs |
| `s3_bucket_name` | auto-generated | S3 bucket name |

---

## CI/CD

GitHub Actions runs on every push to `main`:

1. `terraform fmt -check -recursive` — enforces canonical style
2. `terraform init -backend=false` — resolves providers without remote state
3. `terraform validate` — checks HCL syntax and resource references
4. `terraform plan` (dry-run with mock credentials) — exercises full provider logic

---

## Outputs

After `terraform apply`, the following values are printed:

- `vpc_id`, `public_subnet_id`
- `instance_id`, `instance_public_ip`, `instance_public_dns`
- `security_group_id`
- `s3_bucket_name`, `s3_bucket_arn`
- `iam_role_arn`

---

## License

MIT — see [LICENSE](LICENSE).
