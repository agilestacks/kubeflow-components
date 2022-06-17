#!/bin/bash -e

# Inspired by https://kubernetes.io/docs/tasks/administer-cluster/certificates/#openssl

usage() {
    cat <<EOF
usage: ${0} [OPTIONS]
The following flags are optional.
       --service           Service name of webhook
       --namespace         Namespace where webhook service and secret reside
EOF
    exit 1
}

while [[ $# -gt 0 ]]; do
    case ${1} in
        --service)
            service="$2"
            shift
            ;;
        --namespace)
            namespace="$2"
            shift
            ;;
        --cn)
            cn="$2"
            shift
            ;;
        --output-dir)
            dest_dir="$2"
            shift
            ;;
        *)
            usage
            ;;
    esac
    shift
done

if [ ! -x "$(command -v openssl)" ]; then
    echo "openssl not found"
    exit 1
fi

if test -z "$dest_dir"; then
    dest_dir=$(mktemp -d)
fi

if test -z "$cn"; then
    cn="${service}.${namespace}.svc"
fi

ca_key="$dest_dir/ca.key"
ca_crt="$dest_dir/ca.crt"
server_key="$dest_dir/tls.key"
server_crt="$dest_dir/tls.crt"
server_csr="$dest_dir/cert.csr"
csr_conf="$dest_dir/csr.conf"

mkdir -p "$dest_dir"
cat <<EOF >> "$csr_conf"
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[ dn ]
C = LV
ST = LV
L = Riga
O = EPAM
OU = MLOps Engineering
CN = $cn

[ req_ext ]
subjectAltName = @alt_names

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names

[alt_names]
DNS.1 = ${service}.${namespace}.svc
DNS.2 = ${service}.${namespace}.svc.cluster.local

EOF

# add IPs to the alt_names if needed
# IP.1 = <MASTER_IP>
# IP.2 = <MASTER_CLUSTER_IP>

openssl genrsa -out "$ca_key" 2048
openssl req -x509 -new -nodes -key "$ca_key" -subj "/CN=$cn" -days 10000 -out "$ca_crt"
openssl genrsa -out "$server_key" 2048

openssl req -new -key "$server_key" -out "$server_csr" -config "$csr_conf"
openssl x509 -req -in "$server_csr" -CA "$ca_crt" -CAkey "$ca_key" -CAcreateserial -out "$server_crt" -days 10000 -extensions v3_ext -extfile "$csr_conf"
