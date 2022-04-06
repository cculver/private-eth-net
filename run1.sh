NODE1=$(cat blockchain/values.json | jq -r ".NODE1")
NODE2=$(cat blockchain/values.json | jq -r ".NODE2")
#NODE3=$(cat blockchain/values.json | jq -r ".NODE3")
ENODE1=$(cat blockchain/values.json | jq -r ".ENODE1")

echo "Starting Node 1"
geth --datadir=./blockchain/node1/ \
     --syncmode 'full' \
	 --port 30310 \
	 --networkid 1515 \
	 --miner.gasprice 0 \
	 --http \
	 --http.addr '127.0.0.1' \
	 --http.corsdomain '*' \
	 --http.port 8545 \
	 --http.vhosts '*' \
	 --http.api admin,eth,miner,net,txpool,personal,web3 \
	 --mine \
	 --allow-insecure-unlock \
	 --unlock "0x$NODE1" \
	 --password <(echo password) &

geth --datadir=./blockchain/node1/ --syncmode 'full' --networkid 1515 --port 30310 --miner.threads 1 --miner.gasprice 1 --http --http.addr 'localhost' --http.port 8545 --http.api admin,eth,miner,net,txpool,personal,web3 --mine --allow-insecure-unlock --unlock "0x$NODE1" --password <(echo password) &
PID1=$(echo $!)

echo "Node 1 started"
