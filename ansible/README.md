This anible deploy a kubeadm cluster with 1 master and 2 workers

configure the nodes:

    - setting static IP address.
    - setting sudo permissions - adding to the sudo visudo the line (under %sudo) <user>ALL=(ALL:ALL) NOPASSWD: ALL.
    - pushing the ssh key to the nodes (from the ansible control node to the nodes after creating a key - ssh-keygen -t rsa). ssh-copy-id <user>@<node_ip>.  

To deploy a Kubernetes cluster using `kubeadm` with 1 master and 2 worker nodes, you can use Ansible to automate the process (need to copy the files
to the ansible server - inventory.ini and k8s_install.yaml):

    - setting the inventory.ini (adjust to the ip of your nodes)
    - deploying the ansible script: ansible-playbook -i inventory.ini k8s_install.yaml

in order to execute kubectl commands there a need to run those on the control plane node:

    - mkdir -p $HOME/.kube
    - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    - sudo chown $(id -u):$(id -g) $HOME/.kube/config
