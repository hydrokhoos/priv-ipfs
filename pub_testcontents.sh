#!/bin/sh
NUM_CONTENTS=1000

cd /
mkdir -p test-contents

cd /test-contents
rm -f *
echo "Creating test contents"
for i in `seq -w $NUM_CONTENTS`
do
  touch $i.txt
  echo "$i" > $i.txt
  printf '\rCreated %s/%s' "$i" "$NUM_CONTENTS"
done
echo "\nTest contents created"

echo "Putting contents"
for file in *
do
  ipfs add $file
done

echo "\nDone!"
