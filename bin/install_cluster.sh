#!/bin/bash

blueprint_name=$1

java -jar /vagrant/bin/ambari-shell.jar --ambari.host=one.hdp << EOF
blueprint add --file /vagrant/blueprints/${blueprint_name}/blueprint.json
cluster build --blueprint ${blueprint_name}
cluster assign --hostGroup node_1 --host one.hdp
cluster create --exitOnFinish true
EOF

sleep 60
