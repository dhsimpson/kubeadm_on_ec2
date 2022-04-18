### caller 가 responder 를 호출한다.   
   
1. responder pod를 11111번 포트로 오픈 (responder 컨테이너의 서버 또한 11111번 포트에서 listen)
2. responder pod에 service를 붙임. service 종류를 명시하지 않아 default 로 clusterIP 로 생성 됨 (k8s 내부에서 동일 namespace 에서만 접근 가능)
3. responder 는 name 이 responder 이고, 11111 번  k8s 의 동일 namespace 내에선 responder:11111
