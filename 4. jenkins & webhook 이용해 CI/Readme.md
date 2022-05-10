## 도커 컨테이너 이용해 설치 (도커 없이 하려면 java 부터 설치해야 할 것이 많아 귀찮다)
    
### Jenkins 설치
1. ec2 인스턴스의 인바운드 규칙을 편집해 준다 => 8080 포트 오픈
2. 도커 설치 => sudo apt update && sudo apt install -y docker.io
3. 젠킨스 컨테이너 띄우고 로컬의 도커를 사용하도록 연결 => sudo docker run -d -p 8080:8080 --name jenkins -v /home/jenkins:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -u root jenkins/jenkins:lts
4. 젠킨스 컨테이너 내부에 도커를 설치해 준다 => sudo docker exec jenkins apt update 
sudo docker exec jenkins apt install -y docker.io
5. ec2 인스턴스의 <PublicIP>:8080 or <퍼블릭 IPv4 DNS>:8080 로 접속한다
6. 접속했을 때 Unlock Jenkins 에 나오는 붉은 글씨(ex - sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword)에 젠킨스 비밀번호가 있다. => sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
7. 해당 비밀번호를 Administrator password 에 입력한다.
8. install suggested pulgins 클릭해 플러그인 설치
9. account 생성
10. 도커 CI 파이프라인용 플러그인 설치 => Jenkins 관리 > Plugin 관리 > 설치 가능 > docker pipeline 검색 > install without restart
     
     
### Webhook 이용해 컨테이너 이미지 자동 생성   
  
##### github webhook
1. 예시 app 생성 => ex) [예시 app](https://github.com/dhsimpson/jenkins_test_node_app)
예시 app 컨테이너를 업로드 할 컨테이너 허브(ex docker hub) 레포지토리가 생성돼 있어야 함   
이 App 엔 도커 인스턴스 생성을 위한 Dockerfile 및 Jenkins pipeline을 위한 jenkins 파일이 있어야 함
2. 예시 app 레포지토리의 settings > Webhooks > Add webhook > 의 payload url에 <ec2인스턴스의 public ip or 퍼블릭 IPv4 DNS>:8080/github-webhook/ 을 입력
3. Content type 을 application/json 로 선택, webhook 생성
4. 깃헙 계정의 setting > 좌측하단 Developer Settings > Personal Access tokens > Generate new token
5. Note 에 아무 이름이나 넣고 write packages 체크 > Generate token > 생성된 토큰 복사
   
##### Jenkins
1. New Item 에 들어가 item name 입력 및 "Pipeline" 선택 > OK 클릭
2. Github project 체크한 뒤 예시 app의 github url 입력
3. GitHub hook trigger for GITScm polling 체크
4. Pipeline 에 Definition 을 Pipeline script from SCM 로 선택
5. SCM 을 Git 으로 선택
6. Repository URL 을 예시 app 의 github url 입력
7. Credentials > Add > Jenkins 클릭
Username : 예시 app 을 가진 깃헙의 id   
Password : 위에서 생성한 깃헙의 token   
ID : 아무거나.. (ex dhsimpson_cred)   
11. Add 후 Credentails 에서 방금 생성 한 credential 선택
12. Branch Specifier 에 CI 할 브랜치 명 입력 (ex */main)
13. Script Path 에 jenkinsfile 입력 (예시 app 레포지토리의 jenkinsfile 파일 경로, 대소문자 구분)
13. Apply 및 저장
14. Dashboard > Jenkins관리 > Manage Credentials
15. Jenkins > Global credentials > 좌측의 Add Credentials
Username : 도커허브 id
Password : 도커허브 pw
ID : 아무거나...(ex docker-hub)
16. Build Now 클릭 (한 번은 해줘야 Webhook이 동작)
17. 예시 app 의 코드를 수정해 webhook이 정상 동작하는 지 확인
    
   
Jenkins file 은 아래와 같이 작성
```Jenkinsfile
node {
    stage ('Clone repository') {
        checkout scm
    }
    stage ('Build image') {
        app = docker.build("dhsimpson/jenkins-example-node-app") # CI 한 컨테이너 이미지를 업로드 할 도커허브 레포지토리
    }
    stage ('Push image') {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') { # 위에서 추가 한 docker-hub 의 credential ID
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }
}

stage ('Build image') {
    app = docker.build("dhsimpson/jenkins-example-node-app") # CI 한 컨테이너 이미지를 업로드 할 도커허브 레포지토리
}

stage ('Push image') {
    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub') { # 위에서 추가 한 docker-hub 의 credential ID
        app.push("v1.0.${env.BUILD_NUMBER}") # env.BUILD_NUMBER 는 jenkins 의 환경 변수
        app.push("latest") # 굳이 안 넣어도 됨
    }
}
```
