Here is a basic rundown of how to use this repo.

Go ahead and init your basic project structure here from the root

Here's an example:
`~/greymatter init --insecure foobar-1`

Check in the basic empty project config.

Then create the service type (which we do in the 100_fruit.sh script)

`~/greymatter-keyfix init service --insecure --type=http --dir greymatter/foobar_1 --port=9090 --namespace=foobar-1 "kiwi1"`

Once the sync container is configured and up and running, check in the config.
