NODE1=$(cat blockchain/values.json | jq -r ".NODE1")
NODE2=$(cat blockchain/values.json | jq -r ".NODE2")
#NODE3=$(cat blockchain/values.json | jq -r ".NODE3")
ENODE1=$(cat blockchain/values.json | jq -r ".ENODE1")

echo "Starting Node 2"
geth --datadir=./blockchain/node2/ \
     --syncmode 'full' \
	 --port 30311 \
	 --networkid 1515 \
	 --miner.gasprice 0 \
	 --http \
	 --http.addr 'localhost' \
	 --http.corsdomain '*' \
	 --http.port 8546 \
	 --http.vhosts '*' \
	 --http.api admin,eth,miner,net,txpool,personal,web3 \
	 --mine \
	 --allow-insecure-unlock \
	 --unlock "0x$NODE2" \
	 --password <(echo password) &
	 
PID2=$(echo $!)

echo "Node 2 started"
