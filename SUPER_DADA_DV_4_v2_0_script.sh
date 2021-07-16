#!/bin/sh

while (true)
do




# First we create a 'paths.txt' index in which the paths of all the folders that contain the datasets' metadata will be recorded

filepath=paths.txt




# Here the "-mtime -0.5" parameter limits the scope of the script to export metadata files that were produced in the last 12 hours
# So for your first run of the script, you will need to remove this parameter in order to edit all of your metadata export files

find /usr/local/glassfish4/glassfish/domains/domain1/files/ -name "export_ddi.cached" -mtime -0.5 | sed 's/\/export_ddi.cached//g' > $filepath




# We leave out folders that do not contain metadata (typically the case of yet unpublished datasets)

if [ -s "$filepath" ]; then




# Each path is separated by a linebreak

IFS=$'\n'
tab=( $( cat $filepath ) )




# Starting the loop
# As long as i does not equal the number of paths recorded in the index file, operations are carried out once more

i=0
while [ "$i" -lt "${#tab[*]}" ]
do
cd  ${tab[$i]}




# Displaying the path of the folder where edits are going to occur

echo "I am here" $(pwd)




# NB: All these operations are carried twice, once in the export_ddi.cached file, the second time in the export_oai_ddi.cached file

# Attribute @xmlns is temporarily removed from <codeBook> element because it disrupts XMLStarlet
# It will be added back into the element at the very end of the loop
# NB: It will appear in last position, which is okay since attribute position is not relevant in XML

sed -i "s/xmlns=\"ddi:codebook:2_5\"//g" export_ddi.cached export_oai_ddi.cached




# Adding the @xml:lang attribute in the <codeBook> element with English ('en') as a value

xmlstarlet ed -O --inplace --insert "/codeBook[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached

echo "codebook xml:lang attribute was successfully added or was already present within holdings element: " $(date)




# If the following elements do not have an @xml:lang attribute, they receive it with English ('en') as a value

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/rspStmt/AuthEnty[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/citation/rspStmt/AuthEnty xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/distStmt/distrbtr[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/citation/distStmt/distrbtr xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/subject/keyword[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo " /codeBook/stdyDscr/stdyInfo/subject/keyword xml:lang attribute was successfully added or was already present:" $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/subject/topcClas[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/stdyInfo/subject/topcClas xml:lang lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/abstract[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/stdyInfo/abstract xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/sumDscr/nation[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/stdyInfo/sumDscr/nation xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/method/dataColl/sampProc[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/method/dataColl/sampProc xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/method/dataColl/collMode[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/method/dataColl/collMode xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/docDscr/citation/titlStmt/titl[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/docDscr/citation/titlStmt/titl xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/titlStmt/titl[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
echo "/codeBook/stdyDscr/citation/titlStmt/titl xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/method/dataColl/timeMeth[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached

echo "/codeBook/stdyDscr/method/dataColl/timeMeth xml:lang attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/dataAccs/useStmt/restrctn[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached

echo "/codeBook/stdyDscr/dataAccs/useStmt/restrctn xml:lang attribute was successfully added or was already present: " $(date)




# If the following elements do not have a @vocab attribute, they receive it with 'none' as a value

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/subject/keyword[not(@vocab)]" --type attr -n vocab -v none export_ddi.cached export_oai_ddi.cached

echo "/codeBook/stdyDscr/stdyInfo/subject/keyword vocab attribute was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/subject/topcClas[not(@vocab)]" --type attr -n vocab -v none export_ddi.cached export_oai_ddi.cached

echo "/codeBook/stdyDscr/stdyInfo/subject/topcClas vocab attribute was successfully added or was already present: " $(date)




# Here we fetch the value present in the <distDate> element which appears in docDscr/citation/distStmt

dateDataset=( $( grep -oPm1 "(?<=<distDate>)[^<]+" export_ddi.cached ) )




# Then, if there is no <distDate> element in stdyDscr/citation/distStmt, we create one

xmlstarlet ed -O --inplace --subnode "/codeBook/stdyDscr/citation/distStmt[not(distDate)]" --type elem -n distDate -v $dateDataset export_ddi.cached export_oai_ddi.cached




# And here we give to that same <distDate> element a @date attribute, which receives as a value the date we just fetched from the element itself

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/distStmt/distDate[not(@date)]" --type attr -n date -v $dateDataset export_ddi.cached export_oai_ddi.cached

echo " distDate dataset is done on this date : " $(date)




# Adding an orphan <holdings> element whose @URI attribute receives the dataset's URL as a value

beginningofurl=https://doi.org
doi=$(pwd | sudo sed 's/\/usr\|\/local\|\/glassfish4\|\/glassfish\|\/domains\|\/domain1\|\/files//g')

xmlstarlet ed  -O --inplace --subnode "/codeBook/stdyDscr/citation[not(holdings[@URI])]" --type elem -n holdings -v "" export_ddi.cached export_oai_ddi.cached

echo "/codeBook/stdyDscr/citation holdings element was successfully added or was already present: " $(date)

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/holdings[not(@URI)]" --type attr -n URI -v $beginningofurl$doi export_ddi.cached export_oai_ddi.cached

echo "/codeBook/stdyDscr/citation/ URI attribute was successfully added or was already present within holdings element: " $(date)




# Last step: putting the xmlns attribute back in the <codeBook> element

xmlstarlet ed -O --inplace --insert "/codeBook[not(@xmlns)]" --type attr -n xmlns -v ddi:codebook:2_5 export_ddi.cached export_oai_ddi.cached

echo "codebook xmlns attribute was successfully added once again to element <codeBook>: " $(date)

((i++))

done

fi 

echo "I go to sleep for 12 hours."

sleep 12h

done