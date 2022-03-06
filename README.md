참고 : [kubeadm, ec2 로 k8s 클러스터 구축하기]( https://velog.io/@koo8624/Kubernetes-AWS-EC2-%EC%9D%B8%EC%8A%A4%ED%84%B4%EC%8A%A4%EC%97%90-Kubernetes-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0)   
참고 : [k8s 1.22 버전 이상인 경우 도커와 cgroup 매칭](https://kubernetes.io/ko/docs/setup/production-environment/_print/#%EB%8F%84%EC%BB%A4)   
   
# ec2
ubuntu 20.04 LTS(x86) > t2.medium(spot instance)   
security group   
 - TCP, port : 6443 ( k8s-api server ) / for master node
 - TCP, port : 2379 - 2380 ( k8s etcd ) / for master node
 - TCP, port : 22 (SSH)
 - TCP, port : 10250 ( k8s kubelet )
   
# disable swap   
 - $ sudo su # root 권한으로 실행
 - $ swapoff -a
 - $ echo 0 > /proc/sys/vm/swappiness
 - $ sed -e '/swap/ s/^#*/#/' -i /etc/fstab
 - $ exit
   
# docker
 - sudo apt-get update
 - sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
 - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 - echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 - sudo apt-get update
 - sudo apt-get install docker-ce docker-ce-cli containerd.io
 - sudo mkdir /etc/docker
 - cat <<EOF | sudo tee /etc/docker/daemon.json
   {
     "exec-opts": ["native.cgroupdriver=systemd"],
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "100m"
     },
     "storage-driver": "overlay2"
   }
   EOF
 - sudo systemctl enable docker
 - sudo systemctl daemon-reload
 - sudo systemctl restart docker
   
# k8s
 - sudo apt-get update
 - sudo apt-get install -y apt-transport-https ca-certificates curl
 - sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
 - echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
 - sudo apt-get update
 - sudo apt-get install -y kubelet kubeadm kubectl
 - sudo apt-mark hold kubelet kubeadm kubectl
 - sudo kubeadm init \
	--pod-network-cidr=192.168.0.0/16 \
    --control-plane-endpoint=<ec2-ip> \
    --apiserver-cert-extra-sans=<ec2-ip> \
      
 c.f. 사전에 sudo kubeadm init 을 한 적이 있다면 sudo kubeadm reset 해줘야 에러 발생 안 함   
 - mkdir -p $HOME/.kube
 - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 - sudo chown $(id -u):$(id -g) $HOME/.kube/config
 - kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
