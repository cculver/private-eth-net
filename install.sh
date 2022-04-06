rm -r ~/.puppeth
mkdir blockchain
cd blockchain
mkdir node1
mkdir node2
#mkdir node3
geth --datadir node1/ account new --password <(echo password)
NODE1=$(cat node1/keystore/* | jq -r ".address")
echo "Node 1: $NODE1"
geth --datadir node2/ account new --password <(echo password)
NODE2=$(cat node2/keystore/* | jq -r ".address")
echo "Node 2: $NODE2"
geth --datadir node3/ account new --password <(echo password)
#NODE3=$(cat node3/keystore/* | jq -r ".address")
#echo "Node 3: $NODE3"

../automate_puppet.sh $NODE1 $NODE2 # $NODE3

# Errors are normal for Aleth & Parity chain specs

mv competence.json genesis.json
rm competence-harmony.json

jq '.config.clique.period = 0' genesis.json|sponge genesis.json
geth --datadir node1/ init genesis.json

geth --nousb --datadir=node1/ --syncmode 'full' --port 30310 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE1" --password <(echo password) &
PID1=$(echo $!)
sleep 1
kill $PID1

NODEKEY1=$(cat node1/geth/nodekey)
ENODE1="enode://$(bootnode -nodekeyhex $NODEKEY1 -writeaddress)@127.0.0.1:30310"

geth --nousb --datadir=node2/ --syncmode 'full' --port 30311 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8546 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE2" --password <(echo password) &
PID2=$(echo $!)
sleep 1
kill $PID2

NODEKEY2=$(cat node2/geth/nodekey)
ENODE2="enode://$(bootnode -nodekeyhex $NODEKEY2 -writeaddress)@127.0.0.1:30311"

#geth --nousb --datadir=node3/ --syncmode 'full' --port 30312 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE3" --password <(echo password) &
#PID3=$(echo $!)
#sleep 1
#kill $PID3
#
#NODEKEY3=$(cat node3/geth/nodekey)
#ENODE3="enode://$(bootnode -nodekeyhex $NODEKEY3 -writeaddress)@127.0.0.1:30312"


touch static-nodes.json
#echo -e "[\n\t\"$ENODE1\",\n\t\"$ENODE2\",\n\t\"$ENODE3\"\n]" > static-nodes.json
echo -e "[\n\t\"$ENODE1\",\n\t\"$ENODE2\"\n]" > static-nodes.json

touch values.json
#echo -e "{\n\t\"ENODE1\": \"$ENODE1\",\n\t\"ENODE2\": \"$ENODE2\",\n\t\"ENODE3\": \"$ENODE3\",\n\t\"NODEKEY1\": \"$NODEKEY1\",\n\t\"NODEKEY2\": \"$NODEKEY2\",\n\t\"NODEKEY3\": \"$NODEKEY3\",\n\t\"NODE1\": \"$NODE1\",\n\t\"NODE2\": \"$NODE2\",\n\t\"NODE3\": \"$NODE3\"\n}" > values.json
echo -e "{\n\t\"ENODE1\": \"$ENODE1\",\n\t\"ENODE2\": \"$ENODE2\",\n\t\"NODEKEY1\": \"$NODEKEY1\",\n\t\"NODEKEY2\": \"$NODEKEY2\",\n\t\"NODE1\": \"$NODE1\",\n\t\"NODE2\": \"$NODE2\"\n}" > values.json

cp static-nodes.json node1
cp static-nodes.json node2
#cp static-nodes.json node3
rm static-nodes.json

cd ..

./run2.sh

./run1.sh