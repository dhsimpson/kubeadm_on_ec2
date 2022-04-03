설치해야 할 사항 : kubeadm, cni, ingress-nginx (bare metal 버전의 yml 파일 다운받아 type을 LoadBalancer로 변경) ,metalLB 설치   
1. configMap 생성 및 apply
2. [metalLb 설치하기](https://linux.systemv.pe.kr/metallb-%EC%84%A4%EC%B9%98%ED%95%98%EA%B8%B0/)   
3. [metalLb 에서 할당해 줄 ip 대역 찾기 : 영상의 3:30~4:00 사이](https://www.youtube.com/watch?v=2SmYjj-GFnE)   
4. [nginx-ingress load balancer mode 로 설치하기](https://stackoverflow.com/questions/71637344/i-cant-access-service-via-k8s-master-node)   
5. [metalLb 예시 영상 보고 따라해 보기](https://www.youtube.com/watch?v=UvwtALIb2U8)   
   
## 현재 상태 : nginx-ingress-controller 가 external ip도 할당 받고 잘 되는데 query 가 안 된다.
