#!/bin/bash
export NODE_IP=`hostname -I`
export SEED_LIST="10.0.1.50,10.0.2.50,10.0.3.50"
export CASSANDRA_YML="/etc/cassandra/conf/cassandra.yaml"
export CLUSTER_NAME="devoops_cluster"
export SNITCH_TYPE="Ec2Snitch"

sed -i "/cluster_name:/c\cluster_name: \'${CLUSTER_NAME}\'"  ${CASSANDRA_YML}
sed -i "/- seeds:/c\          - seeds: \"${SEED_LIST}\""     ${CASSANDRA_YML}
sed -i "/listen_address:/c\listen_address: ${NODE_IP}"       ${CASSANDRA_YML}
sed -i "/rpc_address:/c\rpc_address: ${NODE_IP}"             ${CASSANDRA_YML}
sed -i "/endpoint_snitch:/c\endpoint_snitch: ${SNITCH_TYPE}" ${CASSANDRA_YML}
sed -i "/authenticator: AllowAllAuthenticator/c\authenticator: PasswordAuthenticator" ${CASSANDRA_YML}

chkconfig cassandra on
service cassandra start

