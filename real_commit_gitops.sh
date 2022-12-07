#!/bin/sh  
while true  
do  
  sed -i '' 's/EDIT ME/REDLIGHT/g' greymatter/foobar_1/kiwi1.cue
  sed -i '' 's/REDLIGHT/GREENLIGHT/g' greymatter/foobar_1/kiwi1.cue
  git add greymatter/foobar_1/kiwi1.cue 
  git commit -m "change description to GREENLIGHT" 
  git push
  sleep $((15 + RANDOM % 3))
  sed -i '' 's/GREENLIGHT/REDLIGHT/g' greymatter/foobar_1/kiwi1.cue
  git add greymatter/foobar_1/kiwi1.cue
  git commit -m "change description to REDLIGHT"                  
  git push
  sleep $((15 + RANDOM % 3))
done
