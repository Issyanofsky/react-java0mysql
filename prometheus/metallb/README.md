intalling metallb on the cluster.

steps to install metallb on the cluster:
    1. editing kube-proxy configuration: 

        kubectl edit configmap kube-proxy -n kube-system
        set strictARP: true

        reset kube-proxy pods:

        kubectl delete pod -n kube-system -l k8s-app=kube-proxy

    2. installing metallb: 

        kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml

    3. setting up metallb configuration: 

        kubectl apply -f metallb-config.yaml
        
