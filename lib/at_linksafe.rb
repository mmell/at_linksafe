# encoding: UTF-8

require "at_linksafe/controller_extensions"
require "at_linksafe/data_file"
require "at_linksafe/email"
require "at_linksafe/engine" # disable this to run tests
require "at_linksafe/helper_extensions"
require "at_linksafe/iname"
require "at_linksafe/integer_money"
require "at_linksafe/inumber"
require "at_linksafe/profile_element"
require "at_linksafe/resolver"
require "at_linksafe/synonym"
require "at_linksafe/uri_lib"
require "at_linksafe/variation_maps"
require "at_linksafe/version"
require "at_linksafe/xdi_status"
require "at_linksafe/xri"

module AtLinksafe
  # Your code goes here...
end

# FIXME: move all of these constants to the AtLinksafe namespace

GCS = %w{ @ ! = + $ }
SessionLogin = Struct.new( :iname, :cid, :user_id ) # this is the session[:login] -- purposefully minimal

LANGUAGES = [
   ['', ''],['EN', "English"],['AA', "Afar"],['AB', "Abkhazian"],['AF', "Afrikaans"],['AM', "Amharic"],
   ['AR', "Arabic"],['AS', "Assamese"],['AY', "Aymara"],['AZ', "Azerbaijani"],['BA', "Bashkir"],
   ['BE', "Byelorussian"],['BG', "Bulgarian"],['BH', "Bihari"],['BI', "Bislama"],['BN', "Bengali"],
   ['BO', "Tibetan"],['BR', "Breton"],['CA', "Catalan"],['CO', "Corsican"],['CS', "Czech"],
   ['CY', "Welsh"],['DA', "Danish"],['DE', "German"],['DZ', "Bhutani"],['EL', "Greek"],
   ['EO', "Esperanto"],['ES', "Spanish"],['ET', "Estonian"],['EU', "Basque"],['FA', "Persian"],
   ['FI', "Finnish"],['FJ', "Fiji"],['FO', "Faeroese"],['FR', "French"],['FY', "Frisian"],
   ['GA', "Irish"],['GD', "Gaelic"],['GL', "Galician"],['GN', "Guarani"],['GU', "Gujarati"],
   ['HA', "Hausa"],['HI', "Hindi"],['HR', "Croatian"],['HU', "Hungarian"],['HY', "Armenian"],
   ['IA', "Interlingua"],['IE', "Interlingue"],['IK', "Inupiak"],['IN', "Indonesian"],
   ['IS', "Icelandic"],['IT', "Italian"],['IW', "Hebrew"],['JA', "Japanese"],['JI', "Yiddish"],
   ['JW', "Javanese"],['KA', "Georgian"],['KK', "Kazakh"],['KL', "Greenlandic"],['KM', "Cambodian"],
   ['KN', "Kannada"],['KO', "Korean"],['KS', "Kashmiri"],['KU', "Kurdish"],['KY', "Kirghiz"],
   ['LA', "Latin"],['LN', "Lingala"],['LO', "Laothian"],['LT', "Lithuanian"],['LV', "Latvian"],
   ['MG', "Malagasy"],['MI', "Maori"],['MK', "Macedonian"],['ML', "Malayalam"],['MN', "Mongolian"],
   ['MO', "Moldavian"],['MR', "Marathi"],['MS', "Malay"],['MT', "Maltese"],['MY', "Burmese"],
   ['NA', "Nauru"],['NE', "Nepali"],['NL', "Dutch"],['NO', "Norwegian"],['OC', "Occitan"],
   ['OM', "Oromo"],['OR', "Oriya"],['PA', "Punjabi"],['PL', "Polish"],['PS', "Pashto"],['PT', "Portuguese"],
   ['QU', "Quechua"],['RM', "Rhaeto-Romance"],['RN', "Kirundi"],['RO', "Romanian"],['RU', "Russian"],
   ['RW', "Kinyarwanda"],['SA', "Sanskrit"],['SD', "Sindhi"],['SG', "Sangro"],['SH', "Serbo-Croatian"],
   ['SI', "Singhalese"],['SK', "Slovak"],['SL', "Slovenian"],['SM', "Samoan"],['SN', "Shona"],
   ['SO', "Somali"],['SQ', "Albanian"],['SR', "Serbian"],['SS', "Siswati"],['ST', "Sesotho"],
   ['SU', "Sudanese"],['SV', "Swedish"],['SW', "Swahili"],['TA', "Tamil"],['TE', "Tegulu"],
   ['TG', "Tajik"],['TH', "Thai"],['TI', "Tigrinya"],['TK', "Turkmen"],['TL', "Tagalog"],
   ['TN', "Setswana"],['TO', "Tonga"],['TR', "Turkish"],['TS', "Tsonga"],['TT', "Tatar"],
   ['TW', "Twi"],['UK', "Ukrainian"],['UR', "Urdu"],['UZ', "Uzbek"],['VI', "Vietnamese"],
   ['VO', "Volapuk"],['WO', "Wolof"],['XH', "Xhosa"],['YO', "Yoruba"],['ZH', "Chinese"],['ZU', "Zulu"]
]

CANADA_PROVENCE_ABBR = [['Alberta', 'AB'],['British Columbia', 'BC'],['Manitoba', 'MB'],['New Brunswick', 'NB'],
  ['Newfoundland/Labrador', 'NL'],['Nova Scotia', 'NS'],['Ontario', 'ON'],['Prince Edward Is', 'PE'],['Quebec', 'QC'],
  ['Saskatchewan', 'SK'],['Northwest Territories', 'NT'],['Nunavut', 'NU'],['Yukon Territory', 'YT']
  ]
US_STATE_ABBR = [["Alabama", "AL"],["Alaska", "AK"],["American Samoa", "AS"],["Arizona", "AZ"],
  ["Arkansas", "AR"],["California", "CA"],["Colorado", "CO"],["Connecticut", "CT"],["Delaware", "DE"],
  ["District of Columbia", "DC"],["Federated States of Micronesia", "FM"],["Florida", "FL"],
  ["Georgia", "GA"],["Guam", "GU"],["Hawaii", "HI"],["Idaho", "ID"],["Illinois", "IL"],["Indiana", "IN"],
  ["Iowa", "IA"],["Kansas", "KS"],["Kentucky", "KY"],["Louisiana", "LA"],["Maine", "ME"],["Marshall Islands", "MH"],
  ["Maryland", "MD"],["Massachusetts", "MA"],["Michigan", "MI"],["Minnesota", "MN"],["Mississippi", "MS"],
  ["Missouri", "MO"],["Montana", "MT"],["Nebraska", "NE"],["Nevada", "NV"],["New Hampshire", "NH"],
  ["New Jersey", "NJ"],["New Mexico", "NM"],["New York", "NY"],["North Carolina", "NC"],["North Dakota", "ND"],
  ["Northern Mariana Islands", "MP"],["Ohio", "OH"],["Oklahoma", "OK"],["Oregon", "OR"],["Palau", "PW"],
  ["Pennsylvania", "PA"],["Puerto Rico", "PR"],["Rhode Island", "RI"],["South Carolina", "SC"],
  ["South Dakota", "SD"],["Tennessee", "TN"],["Texas", "TX"],["Utah", "UT"],["Vermont", "VT"],
  ["Virgin Islands", "VI"],["Virginia", "VA"],["Washington", "WA"],["West Virginia", "WV"],
  ["Wisconsin", "WI"],["Wyoming", "WY"],["Armed Forces Africa/Canada/Europe/Middle East", "AE"],["Armed Forces Americas", "AA"],
  ["Armed Forces Pacific", "AP"]
]
COUNTRY_CODES = [["Afghanistan", "AF"],["Aland Islands", "AX"],["Albania ", "AL"],["Algeria", "DZ"],["American Samoa", "AS"],["Andorra", "AD"],
["Angola", "AO"],["Anguilla", "AI"],["Antarctica", "AQ"],["Antigua and Barbuda", "AG"],["Argentina", "AR"],["Armenia", "AM"],
["Aruba", "AW"],["Ascension Island", "AC"],["Australia", "AU"],["Austria", "AT"],["Azerbaijan", "AZ"],["Bahamas", "BS"],
["Bahrain", "BH"],["Barbados", "BB"],["Bangladesh", "BD"],["Belarus", "BY"],["Belgium", "BE"],["Belize", "BZ"],["Benin", "BJ"],
["Bermuda", "BM"],["Bhutan", "BT"],["Botswana", "BW"],["Bolivia", "BO"],["Bosnia and Herzegovina", "BA"],["Bouvet Island", "BV"],
["Brazil", "BR"],["British Indian Ocean Territory", "IO"],["Brunei Darussalam", "BN"],["Bulgaria", "BG"],["Burkina Faso", "BF"],
["Burundi", "BI"],["Cambodia", "KH"],["Cameroon", "CM"],["Canada", "CA"],["Cape Verde", "CV"],["Cayman Islands", "KY"],
["Central African Republic", "CF"],["Chad", "TD"],["Chile", "CL"],["China", "CN"],["Christmas Island", "CX"],["Cocos (Keeling) Islands", "CC"],
["Colombia", "CO"],["Comoros", "KM"],["Congo", "CG"],["Congo, Democratic Republic", "CD"],["Cook Islands", "CK"],["Costa Rica", "CR"],
["Cote D'Ivoire (Ivory Coast)", "CI"],["Croatia (Hrvatska)", "HR"],["Cuba", "CU"],["Cyprus", "CY"],["Czech Republic", "CZ"],
["Denmark", "DK"],["Djibouti", "DJ"],["Dominica", "DM"],["Dominican Republic", "DO"],["East Timor", "TP"],["Ecuador", "EC"],
["Egypt", "EG"],["El Salvador", "SV"],["Equatorial Guinea", "GQ"],["Eritrea", "ER"],["Estonia", "EE"],["Ethiopia", "ET"],
["European Union", "EU"],["Falkland Islands (Malvinas)", "FK"],["Faroe Islands", "FO"],["Fiji", "FJ"],["Finland", "FI"],
["France", "FR"],["France, Metropolitan", "FX"],["French Guiana", "GF"],["French Polynesia", "PF"],["French Southern Territories", "TF"],
["F.Y.R.O.M. (Macedonia)", "MK"],["Gabon", "GA"],["Gambia", "GM"],["Georgia", "GE"],["Germany", "DE"],["Ghana", "GH"],["Gibraltar", "GI"],
["Great Britain (UK)", "GB"],["Greece", "GR"],["Greenland", "GL"],["Grenada", "GD"],["Guadeloupe", "GP"],["Guam", "GU"],["Guatemala", "GT"],
["Guernsey", "GG"],["Guinea", "GN"],["Guinea-Bissau", "GW"],["Guyana", "GY"],["Haiti", "HT"],["Heard and McDonald Islands", "HM"],
["Honduras", "HN"],["Hong Kong", "HK"],["Hungary", "HU"],["Iceland", "IS"],["India", "IN"],["Indonesia", "ID"],["Iran", "IR"],["Iraq", "IQ"],
["Ireland", "IE"],["Israel", "IL"],["Isle of Man", "IM"],["Italy", "IT"],["Jersey", "JE"],["Jamaica", "JM"],["Japan", "JP"],["Jordan", "JO"],
["Kazakhstan", "KZ"],["Kenya", "KE"],["Kiribati", "KI"],["Korea (North)", "KP"],["Korea (South)", "KR"],["Kosovo", "XK"],["Kuwait", "KW"],
["Kyrgyzstan", "KG"],["Laos", "LA"],["Latvia", "LV"],["Lebanon", "LB"],["Liechtenstein", "LI"],["Liberia", "LR"],["Libya", "LY"],
["Lesotho", "LS"],["Lithuania", "LT"],["Luxembourg", "LU"],["Macau", "MO"],["Madagascar", "MG"],["Malawi", "MW"],["Malaysia", "MY"],
["Maldives", "MV"],["Mali", "ML"],["Malta", "MT"],["Marshall Islands", "MH"],["Martinique", "MQ"],["Mauritania", "MR"],["Mauritius", "MU"],
["Mayotte", "YT"],["Mexico", "MX"],["Micronesia", "FM"],["Monaco", "MC"],["Moldova", "MD"],["Mongolia", "MN"],["Montenegro", "ME"],
["Montserrat", "MS"],["Morocco", "MA"],["Mozambique", "MZ"],["Myanmar", "MM"],["Namibia", "NA"],["Nauru", "NR"],["Nepal", "NP"],
["Netherlands", "NL"],["Netherlands Antilles", "AN"],["Neutral Zone", "NT"],["New Caledonia", "NC"],["New Zealand (Aotearoa)", "NZ"],
["Nicaragua", "NI"],["Niger", "NE"],["Nigeria", "NG"],["Niue", "NU"],["Norfolk Island", "NF"],["Northern Mariana Islands", "MP"],
["Norway", "NO"],["Oman", "OM"],["Pakistan", "PK"],["Palau", "PW"],["Palestinian Territory, Occupied", "PS"],["Panama", "PA"],
["Papua New Guinea", "PG"],["Paraguay", "PY"],["Peru", "PE"],["Philippines", "PH"],["Pitcairn", "PN"],["Poland", "PL"],
["Portugal", "PT"],["Puerto Rico", "PR"],["Qatar", "QA"],["Reunion", "RE"],["Romania", "RO"],["Russian Federation", "RU"],
["Rwanda", "RW"],["S. Georgia and S. Sandwich Isls.", "GS"],["Saint Helena", "SH"],["Saint Kitts and Nevis", "KN"],
["Saint Lucia", "LC"],["Saint Martin", "MF"],["Saint Vincent & the Grenadines", "VC"],["Samoa", "WS"],["San Marino", "SM"],
["Sao Tome and Principe", "ST"],["Saudi Arabia", "SA"],["Senegal", "SN"],["Serbia", "RS"],["Seychelles", "SC"],["Sierra Leone", "SL"],
["Singapore", "SG"],["Slovenia", "SI"],["Slovak Republic", "SK"],["Solomon Islands", "SB"],["Somalia", "SO"],["South Africa", "ZA"],
["Spain", "ES"],["Sri Lanka", "LK"],["Sudan", "SD"],["Suriname", "SR"],["Svalbard & Jan Mayen Islands", "SJ"],["Swaziland", "SZ"],
["Sweden", "SE"],["Switzerland", "CH"],["Syria", "SY"],["Taiwan", "TW"],["Tajikistan", "TJ"],["Tanzania", "TZ"],["Thailand", "TH"],
["Togo", "TG"],["Tokelau", "TK"],["Tonga", "TO"],["Trinidad and Tobago", "TT"],["Tunisia", "TN"],["Turkey", "TR"],["Turkmenistan", "TM"],
["Turks and Caicos Islands", "TC"],["Tuvalu", "TV"],["Uganda", "UG"],["Ukraine", "UA"],["United Arab Emirates", "AE"],
["United States", "US"],["US Minor Outlying Islands", "UM"],["Uruguay", "UY"],["Uzbekistan", "UZ"],["Vanuatu", "VU"],
["Vatican City State (Holy See)", "VA"],["Venezuela", "VE"],["Viet Nam", "VN"],["British Virgin Islands ", "VG"],
["Virgin Islands (U.S.)", "VI"],["Wallis and Futuna Islands", "WF"],["Western Sahara", "EH"],["Yemen", "YE"],["Zambia", "ZM"],["Zaire", "ZR"],["Zimbabwe", "ZW"]
]


LanguageVariations = AtLinksafe::VariationMaps.new
LANGUAGES.each { |e|
  LanguageVariations.add( e[0], [ e[1]] )
}

CountryVariations = AtLinksafe::VariationMaps.new
COUNTRY_CODES.each { |e|
  CountryVariations.add( e[1], [ e[0]] )
}
CountryVariations.find_by_code('US').add('U.S.', 'U.S.A.', 'USA', 'United States of America', 'US of A')


StateVariations = AtLinksafe::VariationMaps.new
US_STATE_ABBR.each { |e|
  StateVariations.add( e[1], [ e[0]] )
}
CANADA_PROVENCE_ABBR.each { |e|
  StateVariations.add( e[1], [ e[0]] )
}