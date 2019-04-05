### Preparation
- Install [gcloud](https://cloud.google.com/sdk/install)  
- Enable compute engine API (compute.googleapis.com):  
```
gcloud services enable compute.googleapis.com
```
### Authentication to GCP:
1) Best practice:  
Use temporarily application credentials:
```
gcloud auth application-default login
```
2) Not best practice, but useful for automation:

- Create service account teraform:  
```
gcloud iam service-accounts create terraform-sa --display-name "terraform-sa"
gcloud projects add-iam-policy-binding test-terraform-gcp --member serviceAccount:terraform-sa@test-terraform-gcp.iam.gserviceaccount.com --role roles/editor
```
- Create credentials.json file for Service Account terraform  
```
gcloud iam service-accounts keys create credentials.json --iam-account terraform-sa@test-terraform-gcp.iam.gserviceaccount.com
```
- Set path to credentials.json and project configuration in .env file
- Export vars for terraform authentication:  
```
source .env
```

### Run terraform
```
terraform init
terraform apply
```
