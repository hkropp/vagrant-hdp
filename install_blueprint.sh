#!/bin/sh
curl --user admin:admin -H 'X-Requested-By:mycompany' -X DELETE "http://localhost:8080/api/v1/blueprints/vagrant-hdp22-n1"
curl --user admin:admin -H 'X-Requested-By:mycompany' -X DELETE "http://localhost:8080/api/v1/clusters/hdp22"

curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST "http://localhost:8080/api/v1/blueprints/vagrant-hdp22-n1?validate_topology=false" -d @blueprint.json
curl --user admin:admin -H 'X-Requested-By:mycompany' -X POST "http://localhost:8080/api/v1/clusters/hdp22" -d @hostmapping.json
