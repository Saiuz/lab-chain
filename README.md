# lab-chain
Docker environment for building private Ethereum Blockchain

Here we spin up two nodes on a single machine and peer them with each other. In each of the nodes, we run geth which will mine for the blocks. Follow the steps below to try it out for yourself!

# Build the nodes
```
docker build -t lab_chain_node_1 .

docker build -t lab_chain_node_2 .
```

# Run the nodes
```
docker run --rm -it -p 9000:9000 --net=LAB_CHAIN -v /Users/jothi/Desktop/lab_chain_node_1:/home/lab-chain-user/.ethereum lab_chain_node_1

docker run --rm -it -p 9001:9001 --net=LAB_CHAIN -v /Users/jothi/Desktop/lab_chain_node_2:/home/lab-chain-user/.ethereum lab_chain_node_2
```

If you notice the docker run commands above, we are mounting a persistent volume on the host machine so that the contents of the .ethereum folder survives container re-starts. The .ethereum folder is where we have all our chain data, user accounts and so on. So it is essential that we persist this folder so that when we stop the docker container running the node, we are able to continue from where we left when we start the container again!

# Set up the Ethereum accounts

Run the following command on both the nodes:

```
./lab-chain/common_init/setup_user_account.sh
```

# To start the Mining process

```
geth --identity="NODE_1" --networkid="999" --verbosity=3 --mine --minerthreads=1 --rpc --rpcaddr 0.0.0.0 console
geth --identity="NODE_2" --networkid="999" --verbosity=3 --mine --minerthreads=1 --rpc --rpcaddr 0.0.0.0 --rpcport=9001 console
```

# Inspect the Docker network 

We do this setp such that we need to identify what the node ip address is so that we can configure this on the enode:

just issue the following command:

```
docker network inspect LAB_CHAIN
```

Where LAB_CHAIN is the network that we created! On my Mac, this looks like this:

```
"Containers": {
    "1c4fbf2c1c826577c477523d204372783c4a5d462a16ff7440b002e329137d7f": {
        "Name": "pedantic_colden",
        "EndpointID": "2a7971ba4e7f374de5f18bb741efab3167ed47171e049d9644d0d2e116d6ef2d",
        "MacAddress": "02:42:ac:14:00:02",
        "IPv4Address": "172.20.0.2/16",
        "IPv6Address": ""
    },
    "295a9cf3743acd07764344922b3b552948e087df8067282e2f83d0cd6405f109": {
        "Name": "angry_stonebraker",
        "EndpointID": "9ebc5c6ee4ceddcbfe35830e49f219f91998b34116e023370a2a7976794d42fc",
        "MacAddress": "02:42:ac:14:00:03",
        "IPv4Address": "172.20.0.3/16",
        "IPv6Address": ""
    }
},
"Options": {},
"Labels": {}
```
        
So, the IPv4Address is what we need to copy for each node and add it to the enode address in the next step!

# Add the enode of NODE_2 to NODE_1

```
enode = "enode://some-hex-number-randomly-generated-by-your-local-ethereum-client-that-is-running-replace-it-here@172.20.0.3:30303"
```

To add this variable as a peer, issue the following command in the geth console:

```
admin.addPeer(enode)
```
The above command should return true

To see the peer that is added, give the following command:

```
admin.peers
```

Do the same for NODE_1, i.e., add the enode of NODE_1 to NODE_2
