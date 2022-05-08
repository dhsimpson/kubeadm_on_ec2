### 도커 컨테이너 이용해 설치 (도커 없이 하려면 java 부터 설치해야 할 것이 많아 귀찮다)
1. ec2 인스턴스 생성 시 네트워크 설정에서 "http 트래픽 허용" 을 체크해 준다.
2. ec2 인스턴스의 인바운드 규칙을 편집해 준다 => 8080 포트 오픈
3. 도커 설치 => sudo apt update && sudo apt install -y docker.io
4. 젠킨스 컨테이너 띄우고 로컬의 도커를 사용하도록 연결 => sudo docker run -d -p 8080:8080 --name jenkins -v /home/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -u root jenkins/jenkins:lts
5. 젠킨스 컨테이너 내부에 도커를 설치해 준다 => sudo docker exec jenkins apt update 
sudo docker exec jenkins apt install -y docker.io
7. ec2 인스턴스의 <PublicIP>:8080 or <퍼블릭 IPv4 DNS>:8080 로 접속한다


