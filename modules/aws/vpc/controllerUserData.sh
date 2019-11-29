#!/bin/bash

sudo rm -f /var/log/user-data.log
sudo touch /var/log/user-data.log
sudo chown ubuntu:ubuntu /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/null) 2>&1

echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

sudo apt-get update
sudo apt-get -y install socat conntrack ipset golang-cfssl awscli

### Disabling IPV6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1

###### get ca.pem from S3 bucket
#aws s3 cp s3://dlos-platform-poc/ca.pem .
#aws s3 cp s3://dlos-platform-poc/ca-key.pem .
#aws s3 cp s3://dlos-platform-poc/ca-config.json .
##### installing required packages
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca.pem <<EOF
-----BEGIN CERTIFICATE-----
MIIDsjCCApqgAwIBAgIUFh7mO/NVcKxhX8ZFr/U8KQExW0IwDQYJKoZIhvcNAQEL
BQAwcTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
B1NlYXR0bGUxFzAVBgNVBAoTDnN5c3RlbTptYXN0ZXJzMQ0wCwYDVQQLEwRETE9T
MRMwEQYDVQQDEwpLdWJlcm5ldGVzMB4XDTE5MTEyNjA3NDgwMFoXDTI0MTEyNDA3
NDgwMFowcTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
BAcTB1NlYXR0bGUxFzAVBgNVBAoTDnN5c3RlbTptYXN0ZXJzMQ0wCwYDVQQLEwRE
TE9TMRMwEQYDVQQDEwpLdWJlcm5ldGVzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEA6ghZaWU1RCmEEvmNnTSmT6aua6YNmsmOknP5CFJDbgS7A23Oj/8Y
D9CeifGFQhD2nTnmwQVP9p69UZim0+LngioFFBKoLN7/r+6SjIBHt8RQfqJSSLvo
v0ygQnTKRSb+FX38oR2Ra5LwnacdThpbzoEZ1nBm6+k7HISbJo1998Sd5qcB+eyY
8+7OoFgrDM+gqEeHPNcVwFqCnu9uI56oa88fASQAQJt1Tjw2Sc2uDKRCjPFwPuH4
rvAkTNzk2gOm11YOaGOQIIkuG5/J9NOEW0Ci9v24gGbDBc9h784v5EcaqNE2uuPh
0O/ftLbv3B6HPu6sc+Zigs110uAdM86mGwIDAQABo0IwQDAOBgNVHQ8BAf8EBAMC
AQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQURZwuH/HiI4Jc1ft5TmE17emO
d4IwDQYJKoZIhvcNAQELBQADggEBAFa0m2v66TR2XTw/Uymo4sSYRwPLfvXLb6Rh
h5f3KEZWCLAw8kBdiouC03073DEUpVZ4qZJSNWLOaRerDntCpuWD6rVdvXjeFqin
EJgp2/M2QWTIntidj+zQldlb7Ns15E+LJ81rRCzmyCNui2ltlDFDX92pCFdyKsfr
ys6dJVhN0qJXuj8tCyLaMVn/v0qqRQ0BttmpNB6Ivz4y5Rl3PyCY729Z7qiPQuEe
/7xPlFpgKMM+UV7VQpSG4jp+ArPlOAlr7T3uPmqqLrrro/BIpkR5U2hNstrVDSNC
0GaLOFJuQVouu72p7T7n2Rqo1aslhCytK9iXi8VMjBvLx+EXyf0=
-----END CERTIFICATE-----
EOF

cat > ca-key.pem <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA6ghZaWU1RCmEEvmNnTSmT6aua6YNmsmOknP5CFJDbgS7A23O
j/8YD9CeifGFQhD2nTnmwQVP9p69UZim0+LngioFFBKoLN7/r+6SjIBHt8RQfqJS
SLvov0ygQnTKRSb+FX38oR2Ra5LwnacdThpbzoEZ1nBm6+k7HISbJo1998Sd5qcB
+eyY8+7OoFgrDM+gqEeHPNcVwFqCnu9uI56oa88fASQAQJt1Tjw2Sc2uDKRCjPFw
PuH4rvAkTNzk2gOm11YOaGOQIIkuG5/J9NOEW0Ci9v24gGbDBc9h784v5EcaqNE2
uuPh0O/ftLbv3B6HPu6sc+Zigs110uAdM86mGwIDAQABAoIBAD/1zjHexiL90am5
6DkZpYZJQIwNEtTF1yAxb9MVYHZV9qJmRTjXd8UCuAFtL4Uxy6SGqYkBIax+D7GY
Lafk8G6De2XT/4Bb5bc4VXburCsODQ2+4QwdxutZTsc60fj6QiCvkPabdR3YR8he
XsT0sTiL0froN0isMkqF9z0fGFk5LjSFaXE6Z/ts1Dfiq/9NW4JeaSLYV4+t9oLX
Bbx1Vdsqu3t/xYR9II4Bahhz8zN4JNaOWAsf1EQLg8ZXPi4n0U2x1uVeEawP5Vij
LyfHIiklkTahWLlksJOTd1UqdPEJ5iqMBGoy/shJIp1o0FpDgUfX3C2fPb7U/JQW
rfnC6FkCgYEA7pUXLNDeYaDeZbktjjMeQX9ut4ZhTVLeb62NtNb0fi01fA6P23pg
JA+kkbaB+Uqxy5s7GQDo/JmS2MIsFf7KOqaGzTxk/j+daJXzJJAM5AbZq4Pc6LKv
etV+XlOaKLSAqla0DOB8bzzg3uxDXQbVNv+Lr285yrbu7Af6GEIH9ZcCgYEA+x46
LQYgON7Z7iyLtLvxvD0hMpoCqYMH5g0+yKSmlllKdXqDxy5GVijLz3wKYNLhGChz
kfNZ6dyf8gcGNwRqnLjVP8hQ98GngLy1cGy7nyOuf1RVUZnepSGxuJs4VCWSgn60
gvAJpMG2FqEKMgpi8neKm6JGovGbOibIqSnZTB0CgYA4O83dk1GHI1qoEVCKfsP3
3ihje3n9trWVDwwifrPb9Z3woqIHsj1s4n8AlUrnTlK/0dPJHezMdQomqwWnHYne
7xdA0qZfQvFAEG/hw042hOLTSV5NPqibxCxn4T6pr3nQLGV9z3+k3G2IPZnXGGAy
+WKcNBQkEqAX4/1vsEid+wKBgGfDLba8+UOGkfZgYbnkjxaBC96k1MTGZ9UfU/oE
TvGBI8s3PIxpCpc/dDffwUoQ2QHqdRaxv01q5IxVarQBFyx7E2KvmwVE97myQCac
R0qSq9/hMP/u3JjPO2hUewoKHGffgyc3mESD5oGjOVtD/27BBn0YqKdbvhBhRjjg
GfHhAoGBAMFlxp/J/UEJES/mwrG7RIsBZAGjC9znxEW7uhst8AzJxF7nEbhnR+i6
tgQ5K5vw9XqBbFSnOmoIo0iACo7eUjCKPW9RRSwOW0e5ujP80LpXTjhJWNmdE97r
ac2YWaycYSXbnuGVySHNfxe5BXg/V1QCtwkW0VPNYdci6LaXX7W1
-----END RSA PRIVATE KEY-----
EOF
### ETCD
wget -q --show-progress --https-only --timestamping \
  "https://github.com/etcd-io/etcd/releases/download/v3.4.0/etcd-v3.4.0-linux-amd64.tar.gz"
tar -xvf etcd-v3.4.0-linux-amd64.tar.gz
  sudo mv etcd-v3.4.0-linux-amd64/etcd* /usr/local/bin/


#### Control Plane
sudo mkdir -p /etc/kubernetes/config
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-scheduler" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl"

sudo chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:masters",
      "OU": "DLOS",
      "ST": "Washington"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:masters",
      "OU": "DLOS",
      "ST": "Washington"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager


cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:masters",
      "OU": "DLOS",
      "ST": "Washington"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

KUBERNETES_PUBLIC_ADDRESS='1.2.3.4'

KUBERNETES_HOSTNAMES='kubeapi.dlos-example.com,etcd.dlos-example.com,kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local'

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:masters",
      "OU": "DLOS",
      "ST": "Washington"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.0.1.11,10.1.1.11,10.2.1.11,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:masters",
      "OU": "DLOS",
      "ST": "Washington"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig

  cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: NM4SQyPIBQGAA7mEvHZtx4D8x8QL2V/9wYoxhNc0M2I=
      - identity: {}
EOF

###### BootStrapping ETCD cluster
sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
INTERNAL_IP=`hostname -i|awk '{print $1}'`
ETCD_NAME=$(hostname -s)
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ip-10-0-1-11=https://10.0.1.11:2380,ip-10-1-1-11=https://10.1.1.11:2380,dlos-controller=https://10.2.1.11:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl restart etcd

######## Bootstrapping the Kubernetes Control Plane
sudo mkdir -p /var/lib/kubernetes/

sudo cp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem \
    encryption-config.yaml /var/lib/kubernetes/
cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
  --allow-privileged=true \\
  --apiserver-count=3 \\
  --audit-log-maxage=30 \\
  --audit-log-maxbackup=3 \\
  --audit-log-maxsize=100 \\
  --audit-log-path=/var/log/audit.log \\
  --authorization-mode=Node,RBAC \\
  --bind-address=0.0.0.0 \\
  --client-ca-file=/var/lib/kubernetes/ca.pem \\
  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\
  --etcd-cafile=/var/lib/kubernetes/ca.pem \\
  --etcd-certfile=/var/lib/kubernetes/kubernetes.pem \\
  --etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem \\
  --etcd-servers=https://etcd.dlos-example.com:2379 \\
  --event-ttl=1h \\
  --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\
  --kubelet-client-certificate=/var/lib/kubernetes/kubernetes.pem \\
  --kubelet-client-key=/var/lib/kubernetes/kubernetes-key.pem \\
  --kubelet-https=true \\
  --runtime-config=api/all \\
  --service-account-key-file=/var/lib/kubernetes/service-account.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --service-node-port-range=30000-32767 \\
  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \\
  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

#### Configure the Kubernetes Controller Manager
sudo cp kube-controller-manager.kubeconfig /var/lib/kubernetes/
cat <<EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-controller-manager \\
  --address=0.0.0.0 \\
  --cluster-cidr=10.200.0.0/16 \\
  --cluster-name=kubernetes \\
  --cluster-signing-cert-file=/var/lib/kubernetes/ca.pem \\
  --cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem \\
  --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
  --leader-elect=true \\
  --root-ca-file=/var/lib/kubernetes/ca.pem \\
  --service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


##### Configure the Kubernetes Scheduler
sudo cp kube-scheduler.kubeconfig /var/lib/kubernetes/
cat <<EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --config=/etc/kubernetes/config/kube-scheduler.yaml \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

###### Start the Controller Services
sudo systemctl daemon-reload
sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
sudo systemctl restart kube-apiserver kube-controller-manager kube-scheduler


###### RBAC for Kubelet Authorization

cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF

cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF



echo "User data ends here"
date '+%Y-%m-%d %H:%M:%S'