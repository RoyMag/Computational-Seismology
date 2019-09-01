#!/bin/bash

for stn in $(cat stn_XW.txt)
do
cp -rf /home/magneto/Thesis/tarimBasin/XW_1997-2001/goodEvents.txt ~/Thesis/tarimBasin/XW_1997-2001/station/${stn}
cd ~/Thesis/tarimBasin/XW_1997-2001/station/${stn}
echo "sh" "~/Thesis/newScripts/move.sh" | sh
done
