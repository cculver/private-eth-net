NODE1=$(cat blockchain/values.json | jq -r ".NODE1")
NODE2=$(cat blockchain/values.json | jq -r ".NODE2")
#NODE3=$(cat blockchain/values.json | jq -r ".NODE3")
ENODE1=$(cat blockchain/values.json | jq -r ".ENODE1")

echo "Starting Node 1"
geth --datadir=./blockchain/node1/ --syncmode 'full' --networkid 1515 --port 30310 --miner.threads 1 --miner.gasprice 1 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE1" --password <(echo password) &
PID1=$(echo $!)

echo "Starting Node 2"
geth --datadir=./blockchain/node2/ --syncmode 'full' --networkid 1515 --bootnodes $ENODE1 --miner.threads 1 --ipcdisable --port 30311 --miner.gasprice 1 --http --http.addr 'localhost' --http.port 8546 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE2" --password <(echo password) &
PID2=$(echo $!)

#echo "Starting Node 3"
#geth --datadir=./blockchain/node3/ --syncmode 'full' --networkid 1515 --bootnodes $ENODE1 --miner.threads 1 --ipcdisable --port 30312 --miner.gasprice 1 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE3" --password <(echo password) &
#PID3=$(echo $!)

touch running.json
#echo -e "{\n\t\"GETH1\": \"$PID1\",\n\t\"GETH2\": \"$PID2\",\n\t\"GETH3\": \"$PID3\"\n}" > running.json
echo -e "{\n\t\"GETH1\": \"$PID1\",\n\t\"GETH2\": \"$PID2\"\n}" > running.json

echo "Nodes started"
