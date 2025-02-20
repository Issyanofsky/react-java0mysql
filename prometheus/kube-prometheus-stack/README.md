install prometheus operation stack:
    
    1. download helm repo:

        helm pull prometheus-community/kube-prometheus-stack --untar

    2. edit values.yaml file with the following content:
        grafana.ingress.enabled: true
        grafana.ingress.hosts:
          - grafana.local

        * if needed to add persistence to grafana. edit the values.yaml file by enable (remove "#") under grafana.persistence (need to create storageClass too).

        alertmanager.enabled: false

        prometheus.ingress.enabled: true
        prometheus.ingress.hosts:   
            - prometheus.local
        
        * if needed to add persistence to grafana. edit the values.yaml file by enable (remove "#") under prometheus.persistence (need to create storageClass too).

    3. install prometheus operation stack:

        helm upgrade --install kube-prom-stack prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --create-namespace \
        -f values.yaml \
        --set controller.metrics.enabled=true \
        --set controller.metrics.serviceMonitor.enabled=true \
        --set controller.metrics.serviceMonitor.additionalLabels.release="kube-prom-stack"

    4. verify the installation:

        kubectl get ingress -A
        kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx