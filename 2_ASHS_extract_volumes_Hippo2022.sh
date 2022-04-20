#Written by Rachel Zsido
#Adapted from original code from Angharad Williams September 2018
#ASHS info from: https://sites.google.com/site/hipposubfields/tutorial

#note that paths YYY and ZZZ need to be inserted
#YYY is path to directory containing subject list and timepoint list files (last script), and ASHSextract_list.txt (this script)
#ZZZ is path to main data directory containing participant folders, participant folders contain timepoint folders


#!/bin/sh

#First create a subject-day text file list to be filled in by the extracted data. Each row should be a single entry (e.g., MCP-M). Leave a blank row at the top.
#e.g. /YYY/ASHSextract_list.txt

dire=/YYY
tempout=${dire}/temp #have a temporary output directory that will be cleared while looping
out=${dire}/output #have a final output directory for this script

rm $out/right_output.txt
rm $out/left_output.txt
rm $out/icv_output.txt
rm $out/ASHSextract_list.txt
rm $out/ASHSextract_listT.txt
rm $out/ID_all_output.txt
rm $out/ID_icvLeft_output.txt
rm $out/ID_icv_output.txt

touch $out/right_output.txt
touch $out/left_output.txt
touch $out/icv_output.txt

for subID in `cat ${dire}/subjectID.txt`
do
for day in `cat ${dire}/DayList.txt`
do

if [[ -d /ZZZ/$subID/$day ]]
then

cd /ZZZ/$subID/$day/ASHS_output/final/

awk '{print $NF}' *_left_corr_usegray_volumes.txt > left_finalCol.txt
paste -d" " $out/left_output.txt left_finalCol.txt >> $tempout/left_temp.txt
mv $tempout/left_temp.txt $out/left_output.txt

awk '{print $NF}' *_right_corr_usegray_volumes.txt > right_finalCol.txt
paste -d" " $out/right_output.txt right_finalCol.txt >> $tempout/right_temp.txt
mv $tempout/right_temp.txt $out/right_output.txt

awk '{print $NF}' *_icv.txt > icv.txt
paste -d" " $out/icv_output.txt icv.txt >> $tempout/icv_temp.txt
mv $tempout/icv_temp.txt $out/icv_output.txt

fi 

done
done

cp /data/p_01596/HippoSub/Scripts/ASHS_scripts/ASHSextract_list.txt $out
tr '\n' " " < $out/ASHSextract_list.txt > $out/ASHSextract_listT.txt

cd $out

cat ASHSextract_listT.txt >ID_icv_output.txt
echo >>ID_icv_output.txt
cat icv_output.txt >>ID_icv_output.txt

#combine all into final output text file, ID_all_output.txt
cat ID_icv_output.txt >ID_icvLeft_output.txt
echo >>ID_icvLeft_output.txt
cat left_output.txt >>ID_icvLeft_output.txt

cat ID_icvLeft_output.txt >ID_all_output.txt
echo >>ID_all_output.txt
cat right_output.txt >>ID_all_output.txt


