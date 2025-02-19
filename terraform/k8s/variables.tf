variable "master_ip" {
  description = "IP address of the Kubernetes master node"
  type        = string
  default     = "192.168.1.70"
}

variable "worker_ips" {
  description = "List of worker node IPs"
  type        = list(string)
  default = [ "192.168.1.71", "192.168.1.72" ]
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
  default = "~/.ssh/id_rsa"
}

variable "ssh_user" {
  description = "SSH user for the nodes"
  default     = "ec"
}
