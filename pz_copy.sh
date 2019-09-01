#!/bin/bash

for d in */
do
( cd $d && 
for pz in SAC_*
do
ins=`echo ${pz} | awk -F"BHZ" '{print $1}'`
cp -rf ${ins}* ~/Thesis/tarimBasin/XW_1997-2001/poleZero
done )
done
