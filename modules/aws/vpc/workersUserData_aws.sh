#!/bin/bash


sudo rm -f /var/log/user-data.log
sudo touch /var/log/user-data.log
sudo chown ubuntu:ubuntu /var/log/user-data.log

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/null) 2>&1

echo BEGIN
date '+%Y-%m-%d %H:%M:%S'
##### install requisite packages
sudo apt-get update
sudo apt-get -y install socat conntrack ipset golang-cfssl awscli jq
##### setting up the hostname
hostnamectl set-hostname worker-${RANDOM}.dlos-example.com

##### Register host to Route53 hosted zone
HOSTNAME=`hostname -f`
KUBERNETES_PUBLIC_ADDRESS='kubeapi.dlos-example.com'

######## GET POD CIDR
#TAG_NAME='pod-cidr'
#INSTANCE_ID="`wget -qO- http://instance-data/latest/meta-data/instance-id`"
#REGION="`wget -qO- http://instance-data/latest/meta-data/placement/availability-zone | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
#POD_CIDR="`aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$TAG_NAME" --region $REGION --output=text | cut -f5`"
POD_CIDR='10.200.0.0/16'
INTERNAL_IP=`hostname -i|awk '{print $1}'`
ZONE_ID=`aws route53 list-hosted-zones-by-name |jq --arg name "dlos-example.com." -r '.HostedZones | .[] | select(.Name=="\($name)") | .Id'|awk -F '/' '{print $3}'`

cat > worker-host.json <<EOF
{
            "Comment": "registering a worker node",
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "${HOSTNAME}",
                                    "Type": "A",
                                    "TTL": 300,
                                 "ResourceRecords": [{ "Value": "${INTERNAL_IP}"}]
}}]
}
EOF
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file://worker-host.json
## Enabling packet forwarder
iptables -A FORWARD -j ACCEPT
### Disabling IPV6
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1



###### get ca.pem from S3 bucket
#aws s3 cp s3://dlos-platform-poc/ca.pem .
#aws s3 cp s3://dlos-platform-poc/ca-key.pem .
#aws s3 cp s3://dlos-platform-poc/kube-proxy.kubeconfig .
#aws s3 cp s3://dlos-platform-poc/ca-config.json .
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


######## Generating The Kubelet Client Certificates
cat > ${HOSTNAME}-csr.json <<EOF
{
  "CN": "system:node:${HOSTNAME}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:nodes",
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
  -hostname=${HOSTNAME},${INTERNAL_IP} \
  -profile=kubernetes \
  ${HOSTNAME}-csr.json | cfssljson -bare ${HOSTNAME}


wget -q --show-progress --https-only --timestamping \
  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.15.0/crictl-v1.15.0-linux-amd64.tar.gz \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc8/runc.amd64 \
  https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz \
  https://github.com/containerd/containerd/releases/download/v1.2.9/containerd-1.2.9.linux-amd64.tar.gz \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-proxy \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubelet

sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes


mkdir containerd
tar -xvf crictl-v1.15.0-linux-amd64.tar.gz
tar -xvf containerd-1.2.9.linux-amd64.tar.gz -C containerd
sudo tar -xvf cni-plugins-linux-amd64-v0.8.2.tgz -C /opt/cni/bin/
sudo mv runc.amd64 runc
chmod +x crictl kubectl kube-proxy kubelet runc 
sudo mv crictl kubectl kube-proxy kubelet runc /usr/local/bin/
sudo mv containerd/bin/* /bin/

#########The Kube Proxy Client Certificate
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Seattle",
      "O": "system:node-proxier",
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
  kube-proxy-csr.json | cfssljson -bare kube-proxy

#########The kube-proxy Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

######### Generating kubelet Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${HOSTNAME}.kubeconfig

  kubectl config set-credentials system:node:${HOSTNAME} \
    --client-certificate=${HOSTNAME}.pem \
    --client-key=${HOSTNAME}-key.pem \
    --embed-certs=true \
    --kubeconfig=${HOSTNAME}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${HOSTNAME} \
    --kubeconfig=${HOSTNAME}.kubeconfig

  kubectl config use-context default --kubeconfig=${HOSTNAME}.kubeconfig






cat <<EOF | sudo tee /etc/cni/net.d/10-bridge.conf
{
    "cniVersion": "0.3.1",
    "name": "bridge",
    "type": "bridge",
    "bridge": "cnio0",
    "isGateway": true,
    "ipMasq": true,
    "ipam": {
        "type": "host-local",
        "ranges": [
          [{"subnet": "${POD_CIDR}"}]
        ],
        "routes": [{"dst": "0.0.0.0/0"}]
    }
}
EOF

cat <<EOF | sudo tee /etc/cni/net.d/99-loopback.conf
{
    "cniVersion": "0.3.1",
    "name": "lo",
    "type": "loopback"
}
EOF

sudo mkdir -p /etc/containerd/

cat << EOF | sudo tee /etc/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
EOF


cat <<EOF | sudo tee /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF


sudo mv ${HOSTNAME}-key.pem ${HOSTNAME}.pem /var/lib/kubelet/
sudo mv ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
sudo mv ca.pem /var/lib/kubernetes/

cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
EOF

cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2 \\
  --node-labels='cloud=aws'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "10.200.0.0/16"
EOF

cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable containerd kubelet kube-proxy
sudo systemctl restart containerd kubelet kube-proxy

echo "User data ends here"
date '+%Y-%m-%d %H:%M:%S'