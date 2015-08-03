# OpenVaccineServer
Opensource malware signature database server

How to create a self-signed SSL Certificate

ref : http://www.akadia.com/services/ssh_test_certificate.html

Step 1: Generate a Private Key

$ openssl genrsa -des3 -out server.key 1024

Step 2: Generate a CSR (Certificate Signing Request)

$ openssl req -new -key server.key -out server.csr

Step 3: Remove Passphrase from Key

$ cp server.key server.key.org
$ openssl rsa -in server.key.org -out server.key

Step 4: Generating a Self-Signed Certificate

$ openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

Step 5: Installing the Private Key and Certificate

$ cp server.crt /usr/local/apache/conf/ssl.crt
$ cp server.key /usr/local/apache/conf/ssl.key