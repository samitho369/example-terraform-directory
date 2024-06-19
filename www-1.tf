resource "digitalocean_droplet" "www-1" {
  image = "ubuntu-20-04-x64"
  name = "www-1"
  region = "nyc1"
  size = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "5m"
  }
  
 
  provisioner "remote-exec" {
    # on_failure = continue
    inline = [
      "export PATH=$PATH:/usr/bin",
      # install nginx
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt-get update",
      "sudo apt-get -y install nginx"
    ]
  }
}