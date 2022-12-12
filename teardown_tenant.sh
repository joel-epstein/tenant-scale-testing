#!/bin/bash

# Stop the Vegeta Containers

# Teardown Fruit and Edge
cue eval all_k8s.cue -e everything_yaml --out text -t number=5 -t namespace=foobar-1 | kubectl delete -f -

# Remove the config

rm greymatter/foobar_1/kiwi*

# Gitops push the config
git add greymatter/foobar_1
git commit -m "commit gm config changes"
git push

sleep 8

echo "check the SHA and the Dashboard"

# Teardown sync
cue eval all_k8s.cue -e only_sync --out text -t number=5 -t namespace=foobar-1 | kubectl delete -f
