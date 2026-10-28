# IaC demo: VCF Automation + Argo CD

One `terraform apply`, three beats:

1. **VCFA object** - creates a new vSphere Namespace (`tf-demo-xxxxx`) in `default-project`.
2. **Existing cluster** - reads `acme-vks-01` (nothing new is deployed).
3. **GitOps hand-off** - registers an Argo CD Application in `acme-argo`, which deploys
   `podinfo/` from this repo onto `acme-vks-01` in namespace `tf-podinfo`.

## Run (from the lab jumpbox)

```bash
cd cic-holodeck-demos/terraform
cp terraform.tfvars.example terraform.tfvars   # set namespace_class
export VCFA_API_TOKEN='<Org portal > user menu > API Tokens>'
terraform init
terraform plan
terraform apply
```

Show: the new namespace under Project > Namespaces, the `tf-podinfo` app in Argo CD,
the pod in VCF Operations.

## Reset

```bash
terraform destroy
```

Removes the namespace and the Argo CD Application (Argo prunes the app's resources).
