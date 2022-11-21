#!/bin/bash

# service state confirm
# systemctl status nlp_server

# disable service first if service is alreay running...
systemctl disable nlp_server.service && sync

cp ./nlp_server.service /etc/systemd/system/ && sync

systemctl enable nlp_server.service && sync

systemctl restart nlp_server.service && sync

