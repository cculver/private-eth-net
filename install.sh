rm -r ~/.puppeth
mkdir blockchain
cd blockchain
mkdir node1
mkdir node2
mkdir node3
geth --datadir node1/ account new --password <(echo password)
export node1=$(cat node1/keystore/* | jq -r ".address")
echo "Node 1: $node1"
geth --datadir node2/ account new --password <(echo password)
export node2=$(cat node2/keystore/* | jq -r ".address")
echo "Node 2: $node2"
geth --datadir node3/ account new --password <(echo password)
export node3=$(cat node3/keystore/* | jq -r ".address")
echo "Node 3: $node3"

../automate_puppet.sh $node1 $node2 $node3

# Errors are normal for Aleth & Parity chain specs

mv competence.json genesis.json
rm competence-harmony.json

jq '.config.clique.period = 0' genesis.json|sponge genesis.json
geth --datadir node1/ init genesis.json

geth --nousb --datadir=node1/ --syncmode 'full' --port 30310 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node1" --password <(echo password) &
export pid1=$(echo $!)
sleep 1
kill $pid1

export nodekey1=$(cat geth/nodekey)
export enode1="enode://$(bootnode -nodekeyhex $nodekey1 -writeaddress)@127.0.0.1:30310"

geth --nousb --datadir=node2/ --syncmode 'full' --port 30311 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8546 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node2" --password <(echo password) &
export pid2=$(echo $!)
sleep 1
kill $pid2

export nodekey2=$(cat geth/nodekey)
export enode2="enode://$(bootnode -nodekeyhex $nodekey2 -writeaddress)@127.0.0.1:30311"

geth --nousb --datadir=node3/ --syncmode 'full' --port 30312 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node3" --password <(echo password) &
export pid3=$(echo $!)
sleep 1

export nodekey3=$(cat geth/nodekey)
export enode3="enode://$(bootnode -nodekeyhex $nodekey3 -writeaddress)@127.0.0.1:30312"

kill $pid3

cd ..

touch static-nodes.json
echo -e "[\n\t\"$enode1\",\n\t\"$enode2\",\n\t\"$enode3\"\n]" > static-nodes.json

cp static-nodes.json node1
cp static-nodes.json node2
cp static-nodes.json node3
rm static-nodes.json

cd ..

./run.sh
