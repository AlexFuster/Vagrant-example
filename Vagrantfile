# -*- mode: ruby -*-
# vi: set ft=ruby :
MAX_CLIENTS=2
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.define "sl1" do |sl1|

     sl1.vm.network "private_network", ip: "192.168.100.50", auto_config: true
     
     sl1.vm.provider "virtualbox" do |v|
        v.name = "sl1"
        v.gui = false
        v.memory = 1024
        v.cpus = 2
     end

     sl1.vm.provision "network-config", type: "shell" do |s|
        s.path = "scripts/network-config.sh"
        s.args = "'sl1' '192.168.100.50' '8.8.8.8'"
     end

     sl1.vm.provision "ipa-server-install", type: "shell" do |s|
        s.path = "scripts/ipa-server-install.sh"
        s.args = "'sl1'"
     end
     sl1.vm.provision "ipa-server-addusers", type: "shell" do |s|
        s.path = "scripts/ipa-server-addusers.sh"
        s.args = "'usuarios.csv'"
     end
  end 


  # SOLUCION BASICA: Configurar un único cliente "cl1"
  # MEJORA: Hacer un bucle de 1 a MAX_CLIENTS para configurar varios clientes
  (1..MAX_CLIENTS).each do |i|
     config.vm.define "cl#{i}" do |ci|
        ci.vm.network "private_network", ip: "192.168.100.6#{i}", auto_config: true
        ci.vm.provider "virtualbox" do |v|
           v.name = "cl#{i}"
           v.gui = false
           v.memory = 512
           v.cpus = 1
        end
        ci.vm.provision "network-config", type: "shell" do |s|
           s.path = "scripts/network-config.sh"
           s.args = "'cl#{i}' '192.168.100.6#{i}' '192.168.100.50'"
        end
        ci.vm.provision "ipa-client-install", type: "shell" do |s|
           s.path = "scripts/ipa-client-install.sh"
        end
        
     end
  end
end

