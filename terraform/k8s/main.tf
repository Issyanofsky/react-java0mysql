provider "null" {}

resource "null_resource" "master" {
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = var.master_ip  # Connect to the master node
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'ec ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers",
      "echo 'sometext' | sudo tee -a /etc/hosts",
      "sudo apt-get update -y",
      "sudo apt-get install -y kubelet kubeadm kubectl",
      "sudo kubeadm init --pod-network-cidr=10.244.0.0/16",  # Initialize the master
      "TOKEN=$(kubeadm token list | awk 'NR==2 {print $1}')",  # Get the token
      "DISCO_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | sha256sum | awk '{print $1}')",  # Get discovery token hash
      "echo $TOKEN > /tmp/kubeadm-token.txt",  # Save the token to a file
      "echo $DISCO_HASH > /tmp/kubeadm-disco-hash.txt"  # Save the discovery hash to a file
    ]
  }
}

resource "null_resource" "workers" {
  count = length(var.worker_ips)

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    host        = var.worker_ips[count.index]  # Connect to each worker IP
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'ec ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers",  
      "sudo apt-get update -y",
      "sudo apt-get install -y kubelet kubeadm kubectl",
      "TOKEN=$(ssh ${var.master_ip} 'cat /tmp/kubeadm-token.txt')",  # Get token from master node
      "DISCO_HASH=$(ssh ${var.master_ip} 'cat /tmp/kubeadm-disco-hash.txt')",  # Get discovery hash from master
      "kubeadm join ${var.master_ip}:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$DISCO_HASH"  # Join the worker node to the cluster
    ]
  }

  # Ensure workers start after the master is initialized
  depends_on = [null_resource.master]
}
