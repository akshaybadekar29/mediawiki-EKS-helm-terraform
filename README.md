# Mediawiki-EKS-helm-terraform
This document provides steps to deploy mediawiki application on AWS EKS unsing terraform and helm chart

# architecture diagram

![alt text](https://github.com/akshaybadekar29/mediawiki-EKS-helm-terraform/blob/master/diagrams/WikimediaArch.jfif?raw=true)


# login to Amazon
 your "My Security Credentials" section in your profile. 
 create an access key

# install aws cli and configure on machine

aws configure

Default region name: ap-south-1
Default output format: json

# install Terraform

curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip

unzip /tmp/terraform.zip

chmod +x terraform && mv terraform /usr/local/bin/



# Install kubectl on machine

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

mv ./kubectl /usr/local/bin/kubectl

# install helm on machine 

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh

chmod 700 get_helm.sh

./get_helm.sh

# provisioning infrastructure 

cd mediawiki-EKS-helm-terraform/terraform/

terraform init

terraform plan

terraform apply

# EKS cluster on AWS 

![alt text](https://github.com/akshaybadekar29/mediawiki-EKS-helm-terraform/blob/master/diagrams/eks_cluster.JPG)


# grab our EKS config
aws eks update-kubeconfig --name eks-cluster --region ap-south-1

# spin up application 

cd mediawiki-EKS-helm-terraform/mediawiki-helm/

helm install wiki-release-1 -f values.yaml .


# get passwors by running below commands:

  export APP_HOST=$(kubectl get svc --namespace default wiki-release-1-mediawiki --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  
  export APP_PASSWORD=$(kubectl get secret --namespace default wiki-release-1-mediawiki -o jsonpath="{.data.mediawiki-password}" | base64 --decode)
  
  export MARIADB_ROOT_PASSWORD=$(kubectl get secret --namespace default wiki-release-1-mariadb  -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
  
  export MARIADB_PASSWORD=$(kubectl get secret --namespace default wiki-release-1-mariadb -o jsonpath="{.data.mariadb-password}" | base64 --decode)

# complete your Mediawiki deployment by running:

  helm upgrade wiki-release-1 bitnami/mediawiki \
    --set mediawikiHost=$APP_HOST,mediawikiPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$MARIADB_ROOT_PASSWORD,mariadb.auth.password=$MARIADB_PASSWORD

# helm ls 

![alt text](https://github.com/akshaybadekar29/mediawiki-EKS-helm-terraform/blob/master/diagrams/helmls.png?raw=true)


#  get service end point 

kubectl get svc --namespace default -w wiki-release-1-mediawiki

![alt text](https://github.com/akshaybadekar29/mediawiki-EKS-helm-terraform/blob/master/diagrams/service%20endpoint.png?raw=true)


# browse application

![alt text](https://github.com/akshaybadekar29/mediawiki-EKS-helm-terraform/blob/master/diagrams/Application.png?raw=true)

# clean up

terraform destroy

helm delete wiki-release-1
