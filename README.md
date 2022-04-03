참고 : [kubeadm, ec2 로 k8s 클러스터 구축하기]( https://velog.io/@koo8624/Kubernetes-AWS-EC2-%EC%9D%B8%EC%8A%A4%ED%84%B4%EC%8A%A4%EC%97%90-Kubernetes-%ED%81%B4%EB%9F%AC%EC%8A%A4%ED%84%B0-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0)   
참고 : [k8s 1.22 버전 이상인 경우 도커와 cgroup 매칭](https://kubernetes.io/ko/docs/setup/production-environment/_print/#%EB%8F%84%EC%BB%A4)   
참고 : [k8s kubeadm, ec2 로 마스터 & 워커 노드 구축](https://jonnung.dev/kubernetes/2020/03/07/create-kubernetes-cluster-using-kubeadm-on-aws-ec2-part2/)   
참고 : [kubeadm join 안 될 때는 join 키를 새로 생성](https://stackoverflow.com/questions/65588628/node-cannot-join-cluster-k8s-onprem?rq=1)   
참고 : [AWS EC2 에서 calico 사용하려면 해야 하는 셋팅들 -> calico 대신 flannel쓰는 게 정신상 이롭다](https://stackoverflow.com/questions/60806708/kubernetes-with-calico-on-aws-cannot-ping-pods-on-on-different-nodes)   
참고 : [nginx-ingress 설치](https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal-clusters)   
참고 : [nginx-ingress 설치 후 ing.yml apply 시 인증에러 뜰 때](https://ikcoo.tistory.com/137)   
참고 : [nginx-ingress 최신버전 example](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengsettingupingresscontroller.htm)   
참고 : [metalLb example... 별루임](https://www.youtube.com/watch?v=2SmYjj-GFnE)   
참고 : helm 설치 : sudo snap install helm --classic   

# C.F. 이 md file 의 커멘드는 indent 등의 문제가 있어 정상 실행되지 않는다. k8s 설치 흐름 보는 용도로 쓰고 실제 커멘드는 quick-install.sh 파일을 복붙해 사용하자

# ec2
ubuntu 20.04 LTS(x86) > t2.medium(spot instance)   
security group   
 - TCP, port : 6443 ( k8s-api server ) / for master node
 - TCP, port : 2379 - 2380 ( k8s etcd ) / for master node
 - TCP, port : 30000-32767 ( k8s service ) / for master node
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
	--pod-network-cidr=10.244.0.0/16 
      
 c.f. 사전에 sudo kubeadm init 을 한 적이 있다면 sudo kubeadm reset 해줘야 에러 발생 안 함   
# master node에서 kubectl 사용할 수 있도록 하기	
 - mkdir -p $HOME/.kube
 - sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
 - sudo chown $(id -u):$(id -g) $HOME/.kube/config
 - kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
	
	
#worker node : join k8s as cluster
### kubeadm init 했을 때, 마지막 로그에 join 명령어가 나온다.
 - sudo kubeadm join <ip>:<port> --token <token> \
	--discovery-token-ca-cert-hash sha256:<hash>
	
	
단, master 노드의 $HOME/.kube/config 파일을 worker 노드의 $HOME/.kube/config 에 복붙한 후
 - sudo chown $(id -u):$(id -g) $HOME/.kube/config 해준다
