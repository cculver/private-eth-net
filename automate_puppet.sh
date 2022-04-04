#!/usr/bin/expect -f
spawn ./bin/puppeth --network competence
expect "What would you like to do? (default = stats)"
send "2\r"
expect "What would you like to do? (default = create)"
send "1\r"
expect "Which consensus engine to use? (default = clique)"
send "2\r"
expect "How many seconds should blocks take? (default = 15)"
send "0\r"
expect "Which accounts are allowed to seal? (mandatory at least one)"
send $env(node1)
send "\r"
expect "0x"
send $env(node2)
send "\r"
expect "0x"
send $env(node3)
send "\r"
expect "0x"
send "\r"
expect "Which accounts should be pre-funded? (advisable at least one)"
send $env(node1)
send "\r"
expect "0x"
send $env(node2)
send "\r"
expect "0x"
send $env(node3)
send "\r"
expect "0x"
send "\r"
expect "Should the precompile-addresses (0x1 .. 0xff) be pre-funded with 1 wei? (advisable yes)"
send "yes\r"
expect "Specify your chain/network ID if you want an explicit one (default = random)"
send "1515\r"
expect "What would you like to do? (default = stats)"
send "2\r"
expect "1. Modify existing configurations"
send "2\r"
expect "Which folder to save the genesis specs into? (default = current)"
send ".\r"
expect "What would you like to do? (default = stats)"
send \x03