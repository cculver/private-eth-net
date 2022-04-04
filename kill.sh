PID1 = $(cat running.json | jq -r ".GETH1")
PID2 = $(cat running.json | jq -r ".GETH2")
PID3 = $(cat running.json | jq -r ".GETH3")

kill -9 $PID1
kill -9 $PID2
kill -9 $PID3