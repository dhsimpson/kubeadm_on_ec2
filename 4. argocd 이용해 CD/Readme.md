1. k8s에 ArgoCD 애드온 설치
2. argocd-server 를 insecure 하게 만들기 (tls인증서 요구 무시) ->  kubectl patch deployment -n argocd argocd-server --patch-file no-tls.yaml 
3. ingress 추가하기 -> kubectl apply -n argocd -f argocd-ing.yml
