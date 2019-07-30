helm install --name gitlab gitlab/gitlab --timeout 600 --namespace gitlab \
--set gitlab.migrations.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce \
--set gitlab.sidekiq.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce \
--set gitlab.unicorn.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-unicorn-ce \
--set gitlab.unicorn.workhorse.image=registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce \
--set gitlab.task-runner.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-task-runner-ce \
--set certmanager-issuer.email=61920970@qq.com \
--set global.hosts.domain=git.example.com \
--set global.time_zone="Asia/Shanghai" \
--set certmanager.install=false  \
--set global.ingress.configureCertmanager=false \
--set gitlab.gitaly.persistence.storageClass=rook-ceph-block \
--set gitlab.gitaly.persistence.size=20Gi \
--set postgresql.persistence.size=5Gi \
--set postgresql.persistence.storageClass=rook-ceph-block \
--set minio.persistence.size=5Gi \
--set minio.persistence.storageClass=rook-ceph-block \
--set redis.persistence.size=1Gi \
--set redis.persistence.storageClass=rook-ceph-block \
--set gitlab.gitlab-shell.service.externalPort=2222 \
--set gitlab.gitlab-shell.service.internalPort=2222 \
--set global.shell.port=2223 \
--set global.hosts.https=false
\
--set controller.kind=DaemonSet \
--set nginx-ingress.controller.hostNetwork=true \
--set nginx-ingress.controller.kind=DaemonSet \
--set gitlab.gitlab-runner.rbac.clusterWideAccess=true \
--set gitlab.gitlab-runner.rbac.create=true \
--set gitlab.gitlab-runner.runners.privileged=true \
--set gitlab-runner.install=false \
--set global.hosts.https=false \
--set prometheus.install=false \
--set certmanager.install=false \
--set gitlab-runner.enabled=false \
--set gitlab.gitlab-runner.enabled=false 

helm upgrade --install gitlab gitlab/gitlab --timeout 600 \
--set gitlab.gitaly.persistence.storageClass=rook-ceph-block \
--set gitlab.gitaly.persistence.size=20Gi \
--set postgresql.persistence.size=5Gi \
--set postgresql.persistence.storageClass=rook-ceph-block \
--set minio.persistence.size=5Gi \
--set minio.persistence.storageClass=rook-ceph-block \
--set redis.persistence.size=1Gi \
--set redis.persistence.storageClass=rook-ceph-block \
--set certmanager.install=false \
--set global.ingress.configureCertmanager=false \
--set global.ingress.tls.secretName=tls-gitlab-mydomain \
--set global.shell.port=2223 \
--set global.hosts.domain=gitlab.foocompany.com 

helm upgrade --install gitlab . --timeout 600 --namespace gitlab \
--set gitlab.migrations.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-rails-ce \
--set gitlab.sidekiq.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-sidekiq-ce \
--set gitlab.unicorn.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-unicorn-ce \
--set gitlab.unicorn.workhorse.image=registry.gitlab.com/gitlab-org/build/cng/gitlab-workhorse-ce \
--set gitlab.task-runner.image.repository=registry.gitlab.com/gitlab-org/build/cng/gitlab-task-runner-ce \
--set certmanager-issuer.email=61920970@qq.com \
--set gitlab.migrations.initialRootPassword.key="Aa123456" \
--set global.hosts.domain=git.example.com \
--set global.time_zone="Asia/Shanghai" \
--set gitlab.gitaly.persistence.enabled=false \
--set postgresql.persistence.enabled=false \
--set minio.persistence.size=5Gi \
--set minio.persistence.enabled=false \
--set redis.persistence.size=1Gi \
--set redis.persistence.enabled=false \
--set prometheus.install=false \
--set certmanager.install=false \
--set gitlab-runner.enabled=false \
--set gitlab.gitlab-runner.enabled=false 


helm install --name gitlab gitlab/gitlab --timeout 600 --namespace gitlab \
  --timeout 600 \
  --set global.hosts.domain=example.com \
  --set certmanager-issuer.email=me@example.com \
  --set global.time_zone="Asia/Shanghai" \
  --set global.edition=ce
--set gitlab.gitaly.persistence.storageClass=rook-ceph-block \
--set gitlab.gitaly.persistence.size=20Gi \
--set postgresql.persistence.size=5Gi \
--set postgresql.persistence.storageClass=rook-ceph-block \
--set minio.persistence.size=5Gi \
--set minio.persistence.storageClass=rook-ceph-block \
--set redis.persistence.size=1Gi \
--set redis.persistence.storageClass=rook-ceph-block \
--set gitlab.gitlab-shell.service.externalPort=2222 \
--set gitlab.gitlab-shell.service.internalPort=2222 \
--set prometheus.install=false \
--set certmanager.install=false \
--set gitlab-runner.enabled=false \
--set gitlab.gitlab-runner.enabled=false 

---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: gitlab
  namespace: default
spec:
  rules:
  - host: git.example.com
    http:
      paths:
      - backend:
          serviceName: gitlab-unicorn
          servicePort: 8181
        path: /
      - backend:
          serviceName: gitlab-unicorn
          servicePort: 8080
        path: /admin/sidekiq
  tls:
  - hosts:
    - git.example.com
    secretName: tls-gitlab-mydomain
status:
  loadBalancer: {}