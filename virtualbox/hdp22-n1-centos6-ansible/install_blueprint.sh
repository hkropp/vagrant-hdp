#!/bin/sh
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://localhost:8080/api/v1/blueprints/vagrant-hdp22-n1 -d @blueprint.json
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST http://localhost:8080/api/v1/clusters/hdp22 -d @hostmapping.json
