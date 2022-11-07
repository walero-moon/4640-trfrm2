# This project simply creates some resources on Digital Ocean using Terraform, and then installs NGinx on them using Ansible.

## How to run.

### Initial setup:

1. Install Terraform. You can install it here: https://developer.hashicorp.com/terraform/tutorials/downloads

2. Configure your .env file. You can use the .env.example file as a template.

3. Source your .env file. You can do this by running the following command:

```bash
source .env
```

4. Run the following command to initialize Terraform:

```bash
terraform init
```

### Creating resources:

You can create all the resources in the file by running the following command:

```bash
terraform apply
```

### Destroying resources:

You can destroy all the resources in the file by running the following command:

```bash
terraform destroy
```

### Running Ansible:
key-file to ssh into the VMs must be present at root of this repository.

Digital Ocean API key must be present in the environment variable.

Virtual Machines MUST have tags "Lab" for playbook to work.

```bash
ansible-playbook install-nginx.ansible.yml -u root
```

Afterwards, to check that everything is working, simply grab the laod balancer IP from the Digital Ocean website and paste it into your browser. You should see the NGinx welcome page.

