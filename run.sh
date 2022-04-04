cd blockchain

echo "Starting Node 1"
geth --nousb --datadir=./blockchain/node1/ --syncmode 'full' --networkid 1515 --port 30310 --miner.threads 1 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node1" --password <(echo password) &
PID1=$(echo $!)
cd ../..

echo "Starting Node 2"
geth --nousb --datadir=./blockchain/node2/ --syncmode 'full' --networkid 1515 --bootnodes $enode1 --miner.threads 1 --ipcdisable --port 30311 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8546 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node2" --password <(echo password) &
PID2=$(echo $!)

echo "Starting Node 3"
geth --nousb --datadir=./blockchain/node3/ --syncmode 'full' --networkid 1515 --bootnodes $enode1 --miner.threads 1 --ipcdisable --port 30312 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$node3" --password <(echo password) &
PID3=$(echo $!)

touch running.json
echo -e "{\n\t\"GETH1\": \"$PID1\",\n\t\"GETH2\": \"$PID2\",\n\t\"GETH3\": \"$PID3\"\n}" > running.json

echo "Nodes started"
