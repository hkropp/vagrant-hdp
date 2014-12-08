#!/bin/sh
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://hwx-hdp-cluster-one.cloudapp.net:8080/api/v1/blueprints/vagrant-hdp21-n3 -d @blueprint.json
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://hwx-hdp-cluster-one.cloudapp.net::8080/api/v1/clusters/hdp21 -d @hostmapping.json
