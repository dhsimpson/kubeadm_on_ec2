# kubeadm_on_vm
1. 여긴 순서대로 (아랫쪽에 한번에 하는 버전)   

install docker   
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
   
swap 중지 시키기   
sudo passwd root   
> root   
> root   
   
su -   
swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab   
cat <<EOF | tee /etc/modules-load.d/k8s.conf   
br_netfilter   
EOF   
   
cat <<EOF | tee /etc/sysctl.d/k8s.conf   
net.bridge.bridge-nf-call-ip6tables = 1   
net.bridge.bridge-nf-call-iptables = 1   
EOF   
sysctl --system   
   
방화벽 disable   
   
systemctl stop firewalld    
systemctl disable firewalld   
   
kubectl,adm,let 설치   
apt-get update   
apt-get install -y apt-transport-https ca-certificates curl   
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg   
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list   
apt-get update   
apt-get install -y kubelet kubeadm kubectl   
apt-mark hold kubelet kubeadm kubectl   
   
systemctl start kubelet   
systemctl enable kubelet   


2. 한번에 다 하기   
### docker 셋팅 (UTM - ubuntu 20.04 LTS 에서 도커 사전 설치했으면 k8s 셋팅으로 넘어가도 됨)
 
### k8s 셋팅   

swap 중지 시키기   
sudo passwd root   
> root   
> root   
   
   
<아래를 .sh 파일로 만들면 됨>   
   
su -   
swapoff -a && sed -i '/swap/s/^/#/' /etc/fstab   
cat <<EOF | tee /etc/modules-load.d/k8s.conf   
br_netfilter   
EOF   
   
cat <<EOF | tee /etc/sysctl.d/k8s.conf   
net.bridge.bridge-nf-call-ip6tables = 1   
net.bridge.bridge-nf-call-iptables = 1   
EOF   
sysctl --system   
   
방화벽 disable   
   
systemctl stop firewalld    
systemctl disable firewalld   
   
kubectl,adm,let 설치   
apt-get update   
apt-get install -y apt-transport-https ca-certificates curl   
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg   
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list   
apt-get update   
apt-get install -y kubelet kubeadm kubectl   
apt-mark hold kubelet kubeadm kubectl   
   
systemctl start kubelet   
systemctl enable kubelet   
