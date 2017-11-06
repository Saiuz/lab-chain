# lab-chain
Docker environment for building private Ethereum Blockchain

# Build the nodes
```
docker build -t lab_chain_node_1 .

docker build -t lab_chain_node_2 .
```

# Run the nodes
```
docker run --rm -it -p 9000:9000 --net=LAB_CHAIN lab_chain_node_1

docker run --rm -it -p 9001:9001 --net=LAB_CHAIN lab_chain_node_2
```

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

# Add the enode of NODE_1 to NODE_2

```
enode = "enode://28e9c15e15e8a95b8e222ad175daa46a4679044088bfd4862d08203d28f25761331d1cb45b55b840885160d9883b15371112c83add81ef27856d16591c40e621@172.20.0.3:30303"
> admin.addPeer(enode)
> admin.peers
```
