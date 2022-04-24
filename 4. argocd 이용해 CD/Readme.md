1. k8s에 ArgoCD 애드온 설치 ->    kubectl create namespace argocd   
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
2. argocd-server 를 insecure 하게 만들기 (tls인증서 요구 무시) ->   kubectl patch deployment -n argocd argocd-server --patch-file no-tls.yaml 
3. ingress 추가하기 ->   kubectl apply -n argocd -f argocd-ing.yml
4. 내 PC (ex mac or windows) 의 hosts file 에 <master 노드 public IP 주소>   argocd.example.com 추가하기
