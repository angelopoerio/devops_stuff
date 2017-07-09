# Introduction
A redis deployment on Kubernetes

# How to use
When you have a running k8s cluster run this:
* kubectl create -f redis_pod.yaml
* kubectl create -f redis_rc.yaml
* kubectl create -f redis_service.yaml

If everything worked, you should get 3 pods running the redis container and a service called 'redis-service'

# Misc
You can get a test environment [here](http://docker-k8s-lab.readthedocs.io/en/latest/) 

# Author
Angelo Poerio <angelo.poerio@gmail.com>
