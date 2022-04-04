NODE1=$(cat blockchain/values.json | jq -r ".NODE1")
NODE2=$(cat blockchain/values.json | jq -r ".NODE2")
NODE3=$(cat blockchain/values.json | jq -r ".NODE3")
ENODE1=$(cat blockchain/values.json | jq -r ".ENODE1")

echo "Starting Node 3"
geth --nousb --datadir=./blockchain/node3/ --syncmode 'full' --networkid 1515 --bootnodes $ENODE1 --miner.threads 1 --ipcdisable --port 30312 --miner.gasprice 0 --miner.gastarget 470000000000 --http --http.addr 'localhost' --http.port 8547 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE3" --password <(echo password) &
PID3=$(echo $!)

echo "Node 3 started"
