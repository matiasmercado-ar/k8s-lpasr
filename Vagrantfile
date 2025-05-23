IMAGE_NAME = "ubuntu/focal64"
BOX_VERSION = "20240821.0.1"
N = 5

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false

    config.vm.box = IMAGE_NAME
    config.vm.box_version = BOX_VERSION

    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
    end

    config.vm.define "controlplane" do |master|
        master.vm.network "private_network", ip: "192.168.56.20"
        master.vm.hostname = "controlplane"
        master.vm.provision "ansible" do |ansible|
            ansible.playbook = "k-playbooks/master-playbook.yml"
            ansible.extra_vars = {
                node_ip: "192.168.56.20",
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
