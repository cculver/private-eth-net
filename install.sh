sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get -y update && sudo apt-get -y install ethereum jq moreutils net-tools expect
mkdir blockchain
cd blockchain
mkdir node1
mkdir node2
mkdir node3
geth --datadir node1/ account new
node1=$(cat node1/keystore/<tab> | jq -r ".address")
geth --datadir node2/ account new
node2=$(cat node2/keystore/<tab> | jq -r ".address")
geth --datadir node3/ account new
node3=$(cat node3/keystore/<tab> | jq -r ".address")

./automate_puppet.sh

# Errors are normal for Aleth & Parity chain specs

mv competence.json genesis.json
rm competence-harmony.json

jq '.config.clique.period = 0' genesis.json|sponge genesis.json
geth --datadir node1/ init genesis.json

cd node1
geth --nousb --datadir=$pwd --syncmode 'full' --port 30310 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node1" --password <(echo password) &
pid1=$(echo $!)
sleep 2
kill $pid1

nodekey1=$(cat geth/nodekey)
enode1=$(bootnode -nodekeyhex $nodekey1 -writeaddress)

cd ..
cd node2
geth --nousb --datadir=$pwd --syncmode 'full' --port 30311 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8546 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node2" --password <(echo password) &
pid2=$(echo $!)
sleep 2
kill $pid2

nodekey2=$(cat geth/nodekey)
enode2=$(bootnode -nodekeyhex $nodekey2 -writeaddress)

cd ..
cd node3
geth --nousb --datadir=$pwd --syncmode 'full' --port 30312 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node3" --password <(echo password) &
pid3=$(echo $!)
sleep 2

nodekey3=$(cat geth/nodekey)
enode3=$(bootnode -nodekeyhex $nodekey3 -writeaddress)

kill $pid3

cd ..

touch static-nodes.json
echo "[\r\t\"enode://$enode1@127.0.0.1:30310\",\r\t\"enode://$enode2@127.0.0.1:30311\",\r\t\"enode://$enode3@127.0.0.1:30312\"\r]" > static-nodes.json

cp static-nodes.json node1
cp static-nodes.json node2
cp static-nodes.json node3
rm static-nodes.json

cd node1
nohup geth --nousb --datadir=$pwd --syncmode 'full' --port 30310 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node1" --password <(echo password) &
pid1=$(echo $!)

cd node2
nohup geth --nousb --datadir=$pwd --syncmode 'full' --port 30311 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8546 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node2" --password <(echo password) &
pid2=$(echo $!)

cd node3
nohup geth --nousb --datadir=$pwd --syncmode 'full' --port 30312 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node3" --password <(echo password) &
pid3=$(echo $!)