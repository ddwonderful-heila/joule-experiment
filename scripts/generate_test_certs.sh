#!/bin/sh
# generate_test_certs.sh

set -e

# CA configuration
cat > csr.conf <<EOF
 [ req ]
 default_bits = 2048
 default_md = sha256
 prompt = no
 utf8 = yes
 distinguished_name = heila

 [ heila ]
 C = US
 ST = NY
 L = Schenectady
 O  = Heila Technologies
 CN = heila.test.ca
EOF

openssl req \
        -new \
        -newkey rsa:4096 \
        -nodes \
        -x509 \
        -config csr.conf \
        -keyout node.key \
        -out node.crt \
        -out node.crt

# Key
#openssl genrsa \
#        -des3 \
#        -out heila_test_ca.key \
#        2048
#
#openssl req \
#        -new \
#        -batch \
#        -config csr.conf \
#        -key heila_test_ca.key \
#        -out heila_test_ca.crt
#
## renew the node certificates
#for NAME in "node1" "node2"
#do
#
#  CLIENT_KEY=$NAME.key
#  CLIENT_CRT=$NAME.crt
#
#  openssl req \
#          -new \
#          -key $CLIENT_KEY \
#          -out client.csr \
#          -config csr.conf
#
#  openssl x509 \
#          -req \
#          -in client.csr \
#          -CA heila_test_ca.crt \
#          -CAkey heila_test_ca.key \
#          -CAcreateserial \
#          -out $CLIENT_CRT
#
#done
