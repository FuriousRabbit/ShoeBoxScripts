#!/bin/bash
#This script creates the file file.1 if file.tst changes.
while true; do
  change=$(inotifywait -e close_write,moved_to,create .)
  change=${change#./ * }
  if [ "$change" = "file.tst" ]; then touch file.1; fi
done
