1. 환경변수 파일을 만든다.
  - [test-env.yml](./test-env.yml) 참고
2. 해당 환경변수 파일로 configMap 을 만든다.
  - kubectl create cm env-config --from-env-file=test-env.yml
3. 환경변수를 참조할 pod의 yml 파일에 envFrom 값을 추가 한다.
  - [temp-app.yml](./temp-app.yml) 참고
  ```
            envFrom:
            - configMapRef:
                name: board-content-env
  ```
