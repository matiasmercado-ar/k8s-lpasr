#!/bin/bash


# Ask for number of worker nodes
read -p "Enter the number of worker nodes(odd number recommended): " NODE_COUNT

# Validate node count is a positive integer
if ! [[ "$NODE_COUNT" =~ ^[0-9]+$ ]]; then
    echo "Error: Node count must be a positive number."
    exit 1
fi

# Ask for CPU
read -p "Enter the number of CPUs per VM (1-16): " V_CPU
if ! [[ "$V_CPU" =~ ^[0-9]+$ ]] || [ "$V_CPU" -lt 1 ] || [ "$V_CPU" -gt 16 ]; then
    echo "Error: CPU must be a number between 1 and 16."
    exit 1
fi

# Ask for RAM
read -p "Enter the RAM per VM in MB (1024, 2048, 4096, 8192): " V_RAM
if ! [[ "$V_RAM" =~ ^(1024|2048|4096|8192)$ ]]; then
    echo "Error: RAM must be one of 1024, 2048, 4096, or 8192."
    exit 1
fi


# Controlplane base IPs
CONTROL_PLANE_IP="192.168.56.20"
BASE_NODE_IP=21  # Nodes start from .21

# Write Vagrantfile
cat > Vagrantfile <<EOF
IMAGE_NAME = "ubuntu/focal64"
BOX_VERSION = "20240821.0.1"
N = $NODE_COUNT

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.box = IMAGE_NAME
    config.vm.box_version = BOX_VERSION

    config.vm.provider "virtualbox" do |v|
        v.memory = $V_RAM
        v.cpus = $V_CPU
    end

    config.vm.define "controlplane" do |master|
        master.vm.network "private_network", ip: "$CONTROL_PLANE_IP"
        master.vm.hostname = "controlplane"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "k-playbooks/master-playbook.yml"
            ansible.extra_vars = {
                node_ip: "$CONTROL_PLANE_IP",
            }
        end
    end

    (1..N).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.network "private_network", ip: "192.168.56.#{i + 20}"
            node.vm.hostname = "node-#{i}"
            node.vm.provision "ansible" do |ansible|
                ansible.playbook = "k-playbooks/node-playbook.yml"
                ansible.extra_vars = {
                    node_ip: "192.168.56.#{i + 20}",
                }
            end
        end
    end
end
EOF

echo "#################################"
echo "---------------------------------"
echo "Vagrantfile updated with $NODE_COUNT worker node(s). Control plane IP set to $CONTROL_PLANE_IP."
echo "---------------------------------"
echo "Each node was set with $V_RAM MB of RAM and $V_CPU cores"
echo "---------------------------------"
echo "Run 'vagrant up' to start deploying your VMs with k8s"
echo "---------------------------------"

# By matias@matiasmercado.ar
