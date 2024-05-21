#!/bin/sh
NUM_CONTENTS=1000
RESULT_FILE=/ipfs-find-provs-peer.csv

cd /
mkdir -p test-contents
: > /cids.txt

cd /test-contents
rm -f *
echo "Creating test contents"
for i in `seq -w $NUM_CONTENTS`
do
  touch $i.txt
  echo "$i" > $i.txt
  (ipfs add --only-hash -q $i.txt) >> /cids.txt
  printf '\rCreated %s/%s' "$i" "$NUM_CONTENTS"
done
echo "\nTest contents created"

echo "Searching contents"
echo "findprovs[ms],findpeer[ms]" > $RESULT_FILE
FILE_NAME=/cids.txt && while read cid
do
  start_time=$(date +%s%3N)
  prov=$(ipfs routing findprovs -n=1 $cid)
  mid_time=$(date +%s%3N)
  ipfs routing findpeer $prov
  end_time=$(date +%s%3N)

  findprovs=$(($mid_time - $start_time))
  findpeer=$(($end_time - $mid_time))
  echo "$findprovs,$findpeer" >> $RESULT_FILE
done < ${FILE_NAME}

echo "\nDone!"
