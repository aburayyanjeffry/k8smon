#!/usr/bin/bash
# Author: Jeffry Johar
# 12/5/2020
# About: Script to deploy Prometheus and Grafanat at K8s

### GLOBAL VAR ###
CLUSTER=$(kubectl config get-contexts | grep ^\* | awk '{print $3}')
HARBORDEV="dev.company.com\/monitoring\/"
HARBORPRD="dev.company.com\/monitoring\/"
#### FUNCTION ###

function kubeapply {
 echo "kubectl apply -f $1" 
 kubectl apply -f $1 
}

### MAIN ###

echo "CLuster = $CLUSTER"

#check if namespace apm exist or not
if  kubectl get ns | grep apm &> /dev/null; then
  echo "WARNING: Namesapce apm exsit. This installer will install Prometheus and Grafana in this namespace"
  echo
else
  echo "does not exist"
  kubectl create ns apm
  echo
fi

# change user context
echo "Changing user context"
echo "kubectl config set-context --current --namespace=apm"
kubectl config set-context --current --namespace=apm
#Get user input
echo -n "Enter the base URL : "
read URL
APMURL="apm.${URL}"
PURL="prometheus.${URL}"
echo "Your Prometheus URL : $PURL"
echo "Your APM URL        : $APMURL"
echo
#set URL at prometheus ingress
sed -i "s/URLDOTCOM/$PURL/g" prometheus/server-ingress.yaml
#set APM URL at grafana configmap and ingress
sed -i "s/APMURLDOTCOM/$APMURL/g" grafana/configmap.yaml
sed -i "s/APMURLDOTCOM/$APMURL/g" grafana/ingress.yaml

echo "Enter the storage class: "
read SCLASS
sed -i "s/STORAGECLASS/$SCLASS/g" prometheus/server-pvc.yaml

echo "Select the Environment :"
echo "1 = Development"
echo "2 = Production"
read ENVI

case "$ENVI" in
1) echo "ENV $ENVI"
sed -i "s/HARBOR/$HARBORDEV/g" prometheus/*
sed -i "s/HARBOR/$HARBORDEV/g" grafana/*
kubeapply prometheus
kubeapply grafana
;;
2) echo "ENV $ENVI"
sed -i "s/HARBOR/$HARBORPRD/g" prometheus/*
sed -i "s/HARBOR/$HARBORPRD/g" grafana/*
kubeapply prometheus
kubeapply grafana
;;
*) echo "Not a valid selection. Please try again"
;;
esac




#select env
#script print menu and user select



#user enter url



#change value in manifest
#deploy
