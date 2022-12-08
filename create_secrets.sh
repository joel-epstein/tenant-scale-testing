#!/bin/bash

set -x

kubectl create secret generic greymatter-sync-secret \
            --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
            -n foobar-1

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-2

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-3

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-4

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-5

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-6

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-7

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-8

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-9

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-10

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-11

# kubectl create secret generic greymatter-sync-secret \
#             --from-file=ssh-private-key=$HOME/.ssh/id_ed25519 \
#             -n foobar-12