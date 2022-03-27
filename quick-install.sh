sudo su 

swapoff -a 

echo 0 > /proc/sys/vm/swappiness 

sed -e '/swap/ s/^#*/#/' -i /etc/fstab 

exit 

sudo apt-get update 

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release 
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg 

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
  
sudo apt-get update 

sudo apt-get install -y docker-ce docker-ce-cli containerd.io 

sudo mkdir /etc/docker 

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker 

sudo systemctl daemon-reload 

sudo systemctl restart docker 

sudo apt-get update 

sudo apt-get install -y apt-transport-https 

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg 

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list 

sudo apt-get update 

sudo apt-get install -y kubelet kubeadm kubectl 

sudo apt-mark hold kubelet kubeadm kubectl 

# master node 만
sudo kubeadm init \
--pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

# worker node 만, master node 에서 kubeadm init 결과 나옴
sudo kubeadm join <master node ec2 프라이빗 ipv4 주소>:6443 --token <token값> \
	--discovery-token-ca-cert-hash sha256:<hash값> 

