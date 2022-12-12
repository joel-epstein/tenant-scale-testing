#!/bin/bash

# A quick one-liner to use when you need to clean and start over because
# of changes to ./greymatter init <project>.  Determinism is the key to this
# script.  Just to keep the directory clean.

rm -rf README.md TUTORIAL.md cue.mod/ greymatter/ k8s/sync.yaml k8s/manifests.yaml