#!/bin/bash
for f in /mnt/d/PODATKI/10___FAKS_Ljubljana/Magisterij/Osnove_Biometričnih_Signalov_in_Slik/1.Homework/long-term-st-database-1.0.0/long-term-st-database-1.0.0/*.dat
do
  cd /mnt/d/PODATKI/10___FAKS_Ljubljana/Magisterij/Osnove_Biometričnih_Signalov_in_Slik/1.Homework/long-term-st-database-1.0.0/long-term-st-database-1.0.0;
  wfdb2mat -r $(basename "$f" .dat);
done
