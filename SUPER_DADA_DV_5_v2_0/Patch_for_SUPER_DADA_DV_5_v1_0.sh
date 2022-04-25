#!/bin/bash




# First we create a 'paths.txt' index in which the paths of all the folders that contain the datasets' metadata will be recorded

filepath=pathsNation.txt




# Here you must specify the filepath according to your own installation, and you must also take into account which version of Dataverse you are running

# For Dataverse 4.x -> glassfish
# For Dataverse 5.x -> payara

find /usr/local/payara5/glassfish/domains/domain1/files/  -name "export_ddi.cached" | sed 's/\/export_ddi.cached//g' > $filepath




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




# In order to add the country code as an 'abbr' attribute in all instances of <nation>, we must first remove the 'xml:lang' attribute from those <nation> elements

xmlstarlet ed -L -d '//codeBook/stdyDscr/stdyInfo/sumDscr/nation/@xml:lang' export_ddi.cached export_oai_ddi.cached




# Adding the country code as a 'abbr' attribute in the <nation> element

# First, the script checks if there are instances of <nation> and, if so, adds them to a log file

grep -oP "(?<=<nation>)[^<]+" export_ddi.cached > CountrNation.txt

# Then we transfer the contents of the .txt file into a local variable

tableau=CountrNation.txt

# Then we declare the codes for all countries in a dedicated table/array

declare -A tab_asso=( ["Afghanistan"]="AF" ["Albania"]="AL" ["Algeria"]="DZ" ["American Samoa"]="AS" ["Andorra"]="AD" ["Angola"]="AO" ["Anguilla"]="AI" ["Antarctica"]="AQ" ["Antigua and Barbuda"]="AG" ["Argentina"]="AR" ["Armenia"]="AM" ["Aruba"]="AW" ["Australia"]="AU" ["Austria"]="AT" ["Azerbaijan"]="AZ" ["Bahamas"]="BS" ["Bahrain"]="BH" ["Bangladesh"]="BD" ["Barbados"]="BB" ["Belarus"]="BY" ["Belgium"]="BE" ["Belize"]="BZ" ["Benin"]="BJ" ["Bermuda"]="BM" ["Bhutan"]="BT" ["Bolivia, Plurinational State of"]="BO" ["Bonaire, Sint Eustatius and Saba"]="BQ" ["Bosnia and Herzegovina"]="BA" ["Botswana"]="BW" ["Bouvet Island"]="BV" ["Brazil"]="BR" ["British Indian Ocean Territory"]="IO" ["Brunei Darussalam"]="BN" ["Bulgaria"]="BG" ["Burkina Faso"]="BF" ["Burundi"]="BI" ["Cambodia"]="KH" ["Cameroon"]="CM" ["Canada"]="CA" ["Cape Verde"]="CV" ["Cayman Islands"]="KY" ["Central African Republic"]="CF" ["Chad"]="TD" ["Chile"]="CL" ["China"]="CN" ["Christmas Island"]="CX" ["Cocos (Keeling) Islands"]="CC" ["Colombia"]="CO" ["Comoros"]="KM" ["Congo"]="CG" ["Congo, the Democratic Republic of the"]="CD" ["Cook Islands"]="CK" ["Costa Rica"]="CR" ["Croatia"]="HR" ["Cuba"]="CU" ["Curaçao"]="CW" ["Cyprus"]="CY" ["Czech Republic"]="CZ" ["Côte d'Ivoire"]="CI" ["Denmark"]="DK" ["Djibouti"]="DJ" ["Dominica"]="DM" ["Dominican Republic"]="DO" ["Ecuador"]="EC" ["Egypt"]="EG" ["El Salvador"]="SV" ["Equatorial Guinea"]="GQ" ["Eritrea"]="ER" ["Estonia"]="EE" ["Ethiopia"]="ET" ["Falkland Islands (Malvinas)"]="FK" ["Faroe Islands"]="FO" ["Fiji"]="FJ" ["Finland"]="FI" ["France"]="FR" ["French Guiana"]="GF" ["French Polynesia"]="PF" ["French Southern Territories"]="TF" ["Gabon"]="GA" ["Gambia"]="GM" ["Georgia"]="GE" ["Germany"]="DE" ["Ghana"]="GH" ["Gibraltar"]="GI" ["Greece"]="GR" ["Greenland"]="GL" ["Grenada"]="GD" ["Guadeloupe"]="GP" ["Guam"]="GU" ["Guatemala"]="GT" ["Guernsey"]="GG" ["Guinea"]="GN" ["Guinea-Bissau"]="GW" ["Guyana"]="GY" ["Haiti"]="HT" ["Heard Island and Mcdonald Islands"]="HM" ["Holy See (Vatican City State)"]="VA" ["Honduras"]="HN" ["Hong Kong"]="HK" ["Hungary"]="HU" ["Iceland"]="IS" ["India"]="IN" ["Indonesia"]="ID" ["Iran, Islamic Republic of"]="IR" ["Iraq"]="IQ" ["Ireland"]="IE" ["Isle of Man"]="IM" ["Israel"]="IL" ["Italy"]="IT" ["Jamaica"]="JM" ["Japan"]="JP" ["Jersey"]="JE" ["Jordan"]="JO" ["Kazakhstan"]="KZ" ["Kenya"]="KE" ["Kiribati"]="KI" ["Korea, Democratic People's Republic of"]="KP" ["Korea, Republic of"]="KR" ["Kuwait"]="KW" ["Kyrgyzstan"]="KG" ["Lao People's Democratic Republic"]="LA" ["Latvia"]="LV" ["Lebanon"]="LB" ["Lesotho"]="LS" ["Liberia"]="LR" ["Libya"]="LY" ["Liechtenstein"]="LI" ["Lithuania"]="LT" ["Luxembourg"]="LU" ["Macao"]="MO" ["Macedonia, the Former Yugoslav Republic of"]="MK" ["Madagascar"]="MG" ["Malawi"]="MW" ["Malaysia"]="MY" ["Maldives"]="MV" ["Mali"]="ML" ["Malta"]="MT" ["Marshall Islands"]="MH" ["Martinique"]="MQ" ["Mauritania"]="MR" ["Mauritius"]="MU" ["Mayotte"]="YT" ["Mexico"]="MX" ["Micronesia, Federated States of"]="FM" ["Moldova, Republic of"]="MD" ["Monaco"]="MC" ["Mongolia"]="MN" ["Montenegro"]="ME" ["Montserrat"]="MS" ["Morocco"]="MA" ["Mozambique"]="MZ" ["Myanmar"]="MM" ["Namibia"]="NA" ["Nauru"]="NR" ["Nepal"]="NP" ["Netherlands"]="AN" ["New Caledonia"]="NC" ["New Zealand"]="NZ" ["Nicaragua"]="NI" ["Niger"]="NE" ["Nigeria"]="NG" ["Niue"]="NU" ["Norfolk Island"]="NF" ["Northern Mariana Islands"]="MP" ["Norway"]="NO" ["Oman"]="OM" ["Pakistan"]="PK" ["Palau"]="PW" ["Palestine, State of"]="PS" ["Panama"]="PA" ["Papua New Guinea"]="PG" ["Paraguay"]="PY" ["Peru"]="PE" ["Philippines"]="PH" ["Pitcairn"]="PN" ["Poland"]="PL" ["Portugal"]="PT" ["Puerto Rico"]="PR" ["Qatar"]="QA" ["Romania"]="RO" ["Russian Federation"]="RU" ["Rwanda"]="RW" ["Réunion"]="RE" ["Saint Barthélemy"]="BL" ["Saint Helena, Ascension and Tristan da Cunha"]="SH" ["Saint Kitts and Nevis"]="KN" ["Saint Lucia"]="LC" ["Saint Martin (French part)"]="MF" ["Saint Pierre and Miquelon"]="PM" ["Saint Vincent and the Grenadines"]="VC" ["Samoa"]="WS" ["San Marino"]="SM" ["Sao Tome and Principe"]="ST" ["Saudi Arabia"]="SA" ["Senegal"]="SN" ["Serbia"]="RS" ["Seychelles"]="SC" ["Sierra Leone"]="SL" ["Singapore"]="SG" ["Sint Maarten (Dutch part)"]="SX" ["Slovakia"]="SK" ["Slovenia"]="SI" ["Solomon Islands"]="SB" ["Somalia"]="SO" ["South Africa"]="ZA" ["South Georgia and the South Sandwich Islands"]="GS" ["South Sudan"]="SS" ["Spain"]="ES" ["Sri Lanka"]="LK" ["Sudan"]="SD" ["Suriname"]="SR" ["Svalbard and Jan Mayen"]="SJ" ["Swaziland"]="SZ" ["Sweden"]="SE" ["Switzerland"]="CH" ["Syrian Arab Republic"]="SY" ["Taiwan, Province of China"]="TW" ["Tajikistan"]="TJ" ["Tanzania, United Republic of"]="TZ" ["Thailand"]="TH" ["Timor-Leste"]="TL" ["Togo"]="TG" ["Tokelau"]="TK" ["Tonga"]="TO" ["Trinidad and Tobago"]="TT" ["Tunisia"]="TN" ["Turkey"]="TR" ["Turkmenistan"]="TM" ["Turks and Caicos Islands"]="TC" ["Tuvalu"]="TV" ["Uganda"]="UG" ["Ukraine"]="UA" ["United Arab Emirates"]="AE" ["United Kingdom"]="GB" ["United States"]="US" ["United States Minor Outlying Islands"]="UM" ["Uruguay"]="UY" ["Uzbekistan"]="UZ" ["Vanuatu"]="VU" ["Venezuela, Bolivarian Republic of"]="VE" ["Viet Nam"]="VN" ["Virgin Islands, British"]="VG" ["Virgin Islands, U.S."]="VI" ["Wallis and Futuna"]="WF" ["Western Sahara"]="EH" ["Yemen"]="YE" ["Zambia"]="ZM" ["Zimbabwe"]="ZW" ["Åland Islands"]="AX")

# Then the loop can start

# If the array is empty, the loop is not triggered

# If the array contains occurrences of <nation>, the scripts lists all countries found in a list one below the other, separated by linebreaks

# The loop initializes the "y" value at zero, then it finds the maximum position to reach for this array

# Then it adds the abbreviation, then  increases its "y" value and, eventually, it exits the loop

        if [ -s "$tableau" ]
        then
        IFS=$'\n'
        postab=( $( cat $tableau ) )

			for (( y=0; y < ${#postab[*]}; y++ ))
			do
			PaysNation=${postab[$y]}
			echo "I have found the country $PaysNation"
			Abreviation=${tab_asso["$PaysNation"]}
			echo "I have added the country code $Abreviation"
			xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/sumDscr/nation[not(@abbr)][not(testnation)][1]" --type attr -n abbr -v $Abreviation export_ddi.cached export_oai_ddi.cached
			echo "Country code added"
			done
        fi




# Now that all country codes have been added, we can add once again the 'xml:lang' attribute to all occurrences of <nation>

xmlstarlet ed -O --inplace --insert "/codeBook/stdyDscr/stdyInfo/sumDscr/nation[not(@xml:lang)]" --type attr -n xml:lang -v en export_ddi.cached export_oai_ddi.cached




# Last step: putting the xmlns attribute back in the <codeBook> element

xmlstarlet ed -O --inplace --insert "/codeBook[not(@xmlns)]" --type attr -n xmlns -v ddi:codebook:2_5 export_ddi.cached export_oai_ddi.cached

echo "codebook xmlns attribute was successfully added once again to element <codeBook>: " $(date)

((i++))

done

fi 

echo "I finished my job."







