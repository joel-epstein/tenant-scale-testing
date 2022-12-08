#!/bin/bash

# Apply Fruit and Edge
cue eval all_k8s.cue -e everything_yaml --out text -t number=5 -t namespace=foobar-1 | kubectl apply -f -

# Create the config
for i in {1..5}
    do

    #echo "kiwi${i}"
    ~/greymatter-keyfix init service --insecure --type=http --dir greymatter/foobar_1 --port=9090 --namespace=foobar-1 "kiwi${i}"

    done

# Start up sync
cue eval all_k8s.cue -e sync_only --out text -t number=5 -t namespace=foobar-1 | kubectl apply -f -

# Gitops push the config
git add greymatter/foobar_1
git commit -m "commit gm config changes"
git push

# Check SHA and watch the Dashboard

