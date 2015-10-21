#!/bin/bash

# stop openlava on the cluster of computers specified in clst_list.txt
# by Piero Dalle Pezze - piero.dallepezze@ncl.ac.uk - (npdp2) - 2013


#MY_DIR=`dirname $0`
. ${CLST_LIB}/io/clst_read_db.sh


# # # Retrieve the admin name
admin=`get_admin "${CLST_DIR}/etc/db/admin"`

# Retrieve the full list of hosts
db=`get_list_hosts "${CLST_DIR}/etc/db/clst_db_nodes"`
hosts=(`get_comp db[@] "hosts"`)
ips=(`get_comp db[@] "ips"`)
mac=(`get_comp db[@] "mac"`)

# Exclude the following nodes
clean_db=`exclude_hosts "${CLST_DIR}/etc/db/clst_excl_nodes" hosts[@] ips[@] mac[@]`
hosts=(`get_comp clean_db[@] "hosts"`)
ips=(`get_comp clean_db[@] "ips"`)
mac=(`get_comp clean_db[@] "mac"`)

# Attach the admin name to the host.
hosts=(`bind_user_host $admin hosts[@]`)






echo ""
echo "#############################################"
echo "##########  STOPPING OPENLAVA  ##############"
echo "#############################################"

echo -n "HOSTS: ${hosts[@]}"; echo; echo;
echo -n "Enter cluster password: "; read -r -s PASS; echo; 

for (( i=0; i < ${#hosts[@]}; i++ ))
do

    echo ""
    echo "#############################################"
    echo "...processing node: ${hosts[i]}"
    echo "#############################################"

    eval ping -c 3 ${ips[i]}
    # if pings are not returned/forbidden, then check for individual services (e.g. ssh --> port 22) through nmap
    #eval nmap $host -p 22 --max-retries 10 | grep -q open
    if [ "$?" == "0" ]; then

      echo "Stopping openlava service on ${hosts[i]}"
      ssh -t -t -t ${hosts[i]} "sudo -S service openlava stop << 'EOF'
$PASS
EOF
"   

    else
      echo "---- COULD NOT CONNECT TO ${hosts[i]} ----"
    fi
done
