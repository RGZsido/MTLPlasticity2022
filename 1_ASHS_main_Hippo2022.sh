#Written by Rachel Zsido
#Adapted from original code from Angharad Williams September 2018
#ASHS info from: https://sites.google.com/site/hipposubfields/tutorial

#note that paths XXX,YYY,ZZZ need to be inserted
#XXX is path to downloaded ASHS software directory
#YYY is path to directory containing subject list and timepoint list files (this script), and ASHSextract_list.txt (next script)
#ZZZ is path to main data directory containing participant folders, participant folders contain timepoint folders


#!/bin/bash

#downloaded ASHS directory
export ASHS_ROOT=/XXX/ashs-fastashs_beta

#re-locate to where subject list and timepoint list text files are
cd /YYY/

#loop through subjects and timepoints
for subID in `cat subjectID.txt`
do
for day in `cat DayList.txt`

do

#include if command so do not create directories for missing timepoints for certain participants
if [[ -d /ZZZ/$subID/$day ]]
then

echo Running ASHS on subject $subID $day

mkdir /ZZZ/$subID/$day/ASHS_output/

cd /ZZZ/$subID/$day/ASHS_output/

cp /ZZZ/$subID/$day/anat/MP2RAGE/MP2RAGE_denoised.nii /ZZZ/$subID/$day/ASHS_output/

cp /ZZZ/$subID/$day/anat/T2_TSE_slab/TSE_slab.nii /ZZZ/$subID/$day/ASHS_output/

$ASHS_ROOT/bin/ashs_main.sh -N -I $subID -a /XXX/atlas_magdeburg_7t_20180416 -g /ZZZ/$subID/$day/ASHS_output/MP2RAGE_denoised.nii -f /ZZZ/$subID/$day/ASHS_output/TSE_slab.nii -w /ZZZ/$subID/$day/ASHS_output/

fi

done
cd /YYY/ #re-locate back to where subjects/timepoints text files are
done
