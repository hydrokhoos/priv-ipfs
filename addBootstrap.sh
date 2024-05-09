#!/bin/sh
id_PC2=$(sudo docker exec clab-priv-ipfs-PC2 sh -c 'ipfs id -f="<addrs>" | grep $MY_IP/tcp/')
id_PC3=$(sudo docker exec clab-priv-ipfs-PC3 sh -c 'ipfs id -f="<addrs>" | grep $MY_IP/tcp/')
sudo docker exec clab-priv-ipfs-PC1 ipfs bootstrap add $id_PC2
sudo docker exec clab-priv-ipfs-PC1 ipfs bootstrap add $id_PC3
