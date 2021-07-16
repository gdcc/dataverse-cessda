#!/bin/sh




# First we create a 'paths.txt' index in which the paths of all the folders that contain the datasets' metadata will be recorded

filepath=paths.txt

find /usr/local/glassfish4/glassfish/domains/domain1/files/ -name "export_ddi.cached" | sed 's/\/export_ddi.cached//g' > $filepath




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




# NB: All these operations are carried twice, once in the export_ddi.cached file, the second time in the export_oai_ddi.cached file

# Attribute @xmlns is temporarily removed from <codeBook> element because it disrupts XMLStarlet
# It will be added back into the element at the very end of the loop
# NB: It will appear in last position, which is okay since attribute position is not relevant in XML

sed -i "s/xmlns=\"ddi:codebook:2_5\"//g" export_ddi.cached export_oai_ddi.cached




# First we remove all instances of attribute @lang, which had been previously added

xmlstarlet ed -L -d '//codeBook/stdyDscr/citation/rspStmt/AuthEnty/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/citation/distStmt/distrbtr/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/stdyInfo/subject/keyword/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/stdyInfo/subject/topcClas/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/stdyInfo/abstract/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/stdyInfo/sumDscr/nation/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/method/dataColl/sampProc/@lang' export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -L -d '//codeBook/stdyDscr/method/dataColl/collMode/@lang' export_ddi.cached export_oai_ddi.cached




# Next we add the proper attribute @xml:lang with 'en' as value in all elements that require it to satisfy the basic level of validation

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/rspStmt/AuthEnty[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/distStmt/distrbtr[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/subject/keyword[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/subject/topcClas[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/abstract[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/sumDscr/nation[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/sumDscr/anlyUnit[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/method/dataColl/sampProc[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/method/dataColl/collMode[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/docDscr/citation/titlStmt/titl[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached
xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/titlStmt/titl[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached




# Here we fetch the value present in the <distDate> element

dateDataset=( $( grep -oPm1 "(?<=<distDate>)[^<]+" export_ddi.cached ) )




# Then, if there is no <distDate> element in stdyDscr/citation/distStmt, we create one

xmlstarlet ed -O --inplace --subnode "/codeBook/stdyDscr/citation/distStmt[not(distDate)]" --type elem -n distDate -v $dateDataset export_ddi.cached export_oai_ddi.cached




# And here we give to that same <distDate> element a @date attribute, which receives as a value the date we just fetched from the element itself

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/citation/distStmt/distDate[not(@date)]" --type attr -n date -v $dateDataset export_ddi.cached export_oai_ddi.cached




# Finally, we insert the @xmlns attribute back into the <codeBook> element

xmlstarlet ed -O --inplace --insert "/codeBook[not(@xmlns)]" --type attr -n xmlns -v ddi:codebook:2_5 export_ddi.cached export_oai_ddi.cached

((i++))
done

fi

echo "End of procedure"
