#!/bin/sh
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://localhost:8080/api/v1/blueprints/vagrant-hdp21-n1 -d @blueprint.json
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://localhost:8080/api/v1/clusters/hdp21 -d @hostmapping.json
