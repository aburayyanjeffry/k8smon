# k8smon
A quick way to deploy Prometheus and Grafana for K8s monitoring

# Prerequisites
1. You need to know these info
	i. Base URL
	ii. Storage class name
	iii. Environtment. DEV or PRD?

2. You need to load the required container images to you repo

3. In the script change the repo url to your repo
HARBORDEV="dev.company.com\/monitoring\/"
HARBORPRD="dev.company.com\/monitoring\/"

# How to use
git clone
ch k8smon
chmod +x install.sh
./install.sh
