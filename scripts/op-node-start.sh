#!/bin/sh
set -eou

apk add wget
if [ "$NETWORK_NAME" == "testnet" ]; then
  if [ ! -f /op_node/rollup.json ]; then
    wget -O /op_node/rollup.json https://raw.githubusercontent.com/bnb-chain/opbnb/develop/assets/testnet/rollup.json
  else
     echo "rollup.json exists."
  fi
  export P2P_BOOTNODES="enr:-J24QGQBeMsXOaCCaLWtNFSfb2Gv50DjGOKToH2HUTAIn9yXImowlRoMDNuPNhSBZNQGCCE8eAl5O3dsONuuQp5Qix2GAYjB7KHSgmlkgnY0gmlwhDREiqaHb3BzdGFja4PrKwCJc2VjcDI1NmsxoQL4I9wpEVDcUb8bLWu6V8iPoN5w8E8q-GrS5WUCygYUQ4N0Y3CCIyuDdWRwgiMr"
fi

if [ "$NETWORK_NAME" == "mainnet" ]; then
  if [ ! -f /op_node/rollup.json ]; then
    wget -O /op_node/rollup.json https://raw.githubusercontent.com/bnb-chain/opbnb/develop/assets/mainnet/rollup.json
  else
     echo "rollup.json exists."
  fi
  export P2P_BOOTNODES="enr:-J24QGRN1ZLv--bzrqM-qRC-zUlCO4irVVg2bbWOvd3KEFjwLj8qCh54a1ziqic84uQz-2RLVSuNyNAbKEfrNr-STj-GAYoIQDCIgmlkgnY0gmlwhDaykUmHb3BzdGFja4PMAQCJc2VjcDI1NmsxoQJ-_5GZKjs7jaB4TILdgC8EwnwyL3Qip89wmjnyjvDDwoN0Y3CCIyuDdWRwgiMr"
fi

# Start op-node.
exec op-node \
  --l1.trustrpc \
  --sequencer.l1-confs=15 \
  --verifier.l1-confs=15 \
  --l1.http-poll-interval 3s \
  --l1.epoch-poll-interval 45s \
  --l1.rpc-max-batch-size 20 \
  --rollup.config=/op_node/rollup.json \
  --rpc.addr=0.0.0.0 \
  --rpc.port=8546 \
  --p2p.sync.req-resp \
  --p2p.listen.ip=0.0.0.0 \
  --p2p.listen.tcp=9003 \
  --p2p.listen.udp=9003 \
  --snapshotlog.file=./snapshot.log \
  --p2p.priv.raw=$P2P_PRIV_KEY \
  --p2p.bootnodes=$P2P_BOOTNODES \
  --metrics.enabled \
  --metrics.addr=0.0.0.0 \
  --metrics.port=7300 \
  --pprof.enabled \
  --rpc.enable-admin \
  --l1=$OP_NODE__RPC_ENDPOINT \
  --l2=http://op-geth:8551 \
  --l2.jwt-secret=./jwt.txt \
  --log.level=debug
