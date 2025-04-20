# Kubernetes Exercise - IUT Bayonne Pays Basque

This repository contains a Kubernetes exercise for the academic year **2024–2025**, as part of the  
**Licenciatura Profesional en Administración de Sistemas y Redes** at **IUT de Bayonne et du Pays Basque**.

## 📚 Context

Practical configuration and deployment of a Kubernetes cluster using tools like:
- Kubernetes
- Vagrant
- Ansible
- Calico for networking

## 🛠️ Requirements

- VirtualBox
- Vagrant
- Ansible
- Linux-based system
- Troubleshooting ninja skills

## 🚀 Setup Instructions

a. Clone this repository: `git clone https://github.com/matiasmercado-ar/k8s-lpasr.git`

b. Add execute permissions to the `vagrant-setup.sh` script by running: `chmod +x vagrant-setup.sh`

c. Run the Vagrant setup with: `./vagrant-setup.sh`

   This will prompt you for the following:
   - The number of worker nodes you need (it is recommended by Kubernetes to choose an odd number).
   - The amount of CPU and RAM resources needed for the nodes.

d. After the setup, bring up the Vagrant environment by typing: `vagrant up`

## 🧑‍🎓 Author

This is an updated version of this configuration from 2019: https://kubernetes.io/blog/2019/03/15/kubernetes-setup-using-ansible-and-vagrant/
 
