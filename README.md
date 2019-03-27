- Install [gcloud](https://cloud.google.com/sdk/install)  
- Enable compute engine API (compute.googleapis.com)  
```
gcloud services enable compute.googleapis.com
```
- Create service account teraform:  
```
gcloud iam service-accounts create terraform-sa --display-name "terraform-sa"
gcloud projects add-iam-policy-binding test-terraform-gcp --member serviceAccount:terraform-sa@test-terraform-gcp.iam.gserviceaccount.com --role roles/editor
```
- Create credentials.json file for Service Account terraform  
```
gcloud iam service-accounts keys create credentials.json --iam-account terraform-sa@test-terraform-gcp.iam.gserviceaccount.com
```