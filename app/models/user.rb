class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :number_id, use: [:slugged, :history]
  has_secure_password
  
  # Cohorts
  # A = Do not disturb
  
  # http://uifaces.com/api
  FACES = ["calebogden","adellecharles","pixeliris","boheme","michzen","madedigital","geeftvorm","jennyshen","alv",
    "chloepark","lovskogen","teylorfeliz","nickcouto","jobharmsen","hollowellme","heyjoyhey","zwitscherlise","visionarty","shibu_ravi",
    "kfriedson","edwellbrook","mikaelstaer", "gigifk", "leezlee", "calebjoyce", "karagates", "cheriana", "her_ruu",
    "beliv", "kennedysgarage","lady_katherine","tomsturge","dingledow","hannahlikesyouu","4l3d",
    "romanbulah","rdsaunders", "kennahasson", "leez", "katelynannsays", "aiiaiiaii", "slowspock", "websiddu",
    "paladinstudio", "tal_hertz","knilob", "doesmostthings","maridlcrmn", "simplyand", "chloepark", "dwaldron", "chexee",
    "oykun", "mcercos"]
  
  #   Mapping from select array to the hash:
  #   a = User::NATIONALITIES_ARRAY
  #   b = a.map { |x| "#{x[1]}"+ "monkey" + " => " + "monkey" + x[0] }
  #   find and replace "monkey" with: "
  
  INTERESTS = {
    "1" => {"name" => "Lodging", "icon" => "building", "margins" => "2-22", "attrs" => {"1" => "Hotels", "2" => "Hostels", "3" => "Staying With Locals", "4" => "Any"}},
    "2" => {"name" => "Rooming", "icon" => "hotel", "margins" => "0-20", "attrs" => {"1" => "Own Room", "2" => "Open to Sharing", "3" => "Prefer Sharing", "4" => "Any"}},
    "3" => {"name" => "Food", "icon" => "cutlery", "margins" => "2-23", "attrs" => {"1" => "Picky", "2" => "Typical Eating", "3" => "Adventerous"}},
    "4" => {"name" => "Drinking", "icon" => "glass", "margins" => "1-21", "attrs" => {"1" => "Never", "2" => "Rarely", "3" => "Socially", "4" => "Often"}},
    "5" => {"name" => "Budget", "icon" => "money", "margins" => "1-20", "attrs" => {"1" => "Budget: $", "2" => "Budget: $$", "3" => "Budget: $$$"}}
  }
  INTERESTS_ARRAY = [
    ["lodging", "1", [["hotels", "1"], ["hostels", "2"], ["with locals", "3"], ["any", "4"]] ],
    ["rooming", "2", [["own room", "1"], ["open to share", "2"], ["prefer sharing", "3"], ["any", "4"]] ],
    ["food", "3", [["picky", "1"], ["typical", "2"], ["adventerous", "3"]] ],
    ["drinking", "4", [["never", "1"], ["rarely", "2"], ["socially", "3"], ["often", "4"]] ],
    ["budget", "5", [["$", "1"], ["$$", "2"], ["$$$", "3"]] ]
  ]
  EMAILS_ARRAY = [
    ["General", "1", [["Announcements - Tripsharing updates", "B"], ["Announcements - Travel news, Tips, etc.", "C"]] ],
    ["Trips", "2", [["Newsletter - daily", "D"], ["Newsletter - weekly", "E"], ["Trip creation - info", "F"], ["Trip - Requests to join", "G"],
                    ["Trip - New travel companion accepted", "H"],["Trip - Departing updates", "J"],["Trip - Updates during trip", "K"],["Trip - Completion", "L"],["Trip - Time changes", "N"]] ],
    ["Messaging", "3", [["New message emails", "P"]] ]
  ]

  STATUS = {"1" => "Seeking travel plans", "2" => "Seeking travel companions", "3" => "Dreaming about travel", "4" => "On a trip"}
  STATUS_ARRAY = [["Seeking travel plans", "1"], ["Seeking travel companions", "2"], ["Dreaming about travel", "3"], ["On a trip", "4"]]
  NATIONALITIES = {"0" => "any", "1" => "American", "2" => "British", "3" => "English", "4" => "Irish", "5" => "Northern Irish", "6" => "Canadian", 
    "7" => "Scottish", "8" => "Welsh", "9" => "Australian", "10" => "Afghan", "11" => "Albanian", "12" => "Algerian", "13" => "Andorran", 
    "14" => "Angolan", "15" => "Antiguans", "16" => "Argentinean", "17" => "Armenian", "18" => "Austrian", "19" => "Azerbaijani", "20" => "Bahamian", 
    "21" => "Bahraini", "22" => "Bangladeshi", "23" => "Barbadian", "24" => "Barbudans", "25" => "Batswana", "26" => "Belarusian", "27" => "Belgian", 
    "28" => "Belizean", "29" => "Beninese", "30" => "Bhutanese", "31" => "Bolivian", "32" => "Bosnian", "33" => "Brazilian", "34" => "Bruneian", 
    "35" => "Bulgarian", "36" => "Burkinabe", "37" => "Burmese", "38" => "Burundian", "39" => "Cambodian", "40" => "Cameroonian", "41" => "Cape Verdean", 
    "42" => "Central African", "43" => "Chadian", "44" => "Chilean", "45" => "Chinese", "46" => "Colombian", "47" => "Comoran", "48" => "Congolese", 
    "49" => "Congolese", "50" => "Costa Rican", "51" => "Croatian", "52" => "Cuban", "53" => "Cypriot", "54" => "Czech", "55" => "Danish", 
    "56" => "Djibouti", "57" => "Dominican", "58" => "Dutch", "59" => "Dutchman", "60" => "Dutchwoman", "61" => "East Timorese", "62" => "Ecuadorean", 
    "63" => "Egyptian", "64" => "Emirian", "65" => "Equatorial Guinean", "66" => "Eritrean", "67" => "Estonian", "68" => "Ethiopian", "69" => "Fijian", 
    "70" => "Filipino", "71" => "Finnish", "72" => "French", "73" => "Gabonese", "74" => "Gambian", "75" => "Georgian", "76" => "German", "77" => "Ghanaian", 
    "78" => "Greek", "79" => "Grenadian", "80" => "Guatemalan", "81" => "Guinea-Bissauan", "82" => "Guinean", "83" => "Guyanese", "84" => "Haitian", 
    "85" => "Herzegovinian", "86" => "Honduran", "87" => "Hungarian", "88" => "I-Kiribati", "89" => "Icelander", "90" => "Indian", "91" => "Indonesian", 
    "92" => "Iranian", "93" => "Iraqi", "94" => "Israeli", "95" => "Italian", "96" => "Ivorian", "97" => "Jamaican", "98" => "Japanese", "99" => "Jordanian", 
    "100" => "Kazakhstani", "101" => "Kenyan", "102" => "Kittian and Nevisian", "103" => "Kuwaiti", "104" => "Kyrgyz", "105" => "Laotian", 
    "106" => "Latvian", "107" => "Lebanese", "108" => "Liberian", "109" => "Libyan", "110" => "Liechtensteiner", "111" => "Lithuanian", 
    "112" => "Luxembourger", "113" => "Macedonian", "114" => "Malagasy", "115" => "Malawian", "116" => "Malaysian", "117" => "Maldivan", "118" => "Malian", 
    "119" => "Maltese", "120" => "Marshallese", "121" => "Mauritanian", "122" => "Mauritian", "123" => "Mexican", "124" => "Micronesian", "125" => "Moldovan", 
    "126" => "Monacan", "127" => "Mongolian", "128" => "Moroccan", "129" => "Mosotho", "130" => "Motswana", "131" => "Mozambican", "132" => "Namibian", 
    "133" => "Nauruan", "134" => "Nepalese", "135" => "Netherlander", "136" => "New Zealander", "137" => "Ni-Vanuatu", "138" => "Nicaraguan", 
    "139" => "Nigerian", "140" => "Nigerien", "141" => "North Korean", "142" => "Norwegian", "143" => "Omani", "144" => "Pakistani", "145" => "Palauan", 
    "146" => "Panamanian", "147" => "Papua New Guinean", "148" => "Paraguayan", "149" => "Peruvian", "150" => "Polish", "151" => "Portuguese", 
    "152" => "Qatari", "153" => "Romanian", "154" => "Russian", "155" => "Rwandan", "156" => "Saint Lucian", "157" => "Salvadoran", "158" => "Samoan", 
    "159" => "San Marinese", "160" => "Sao Tomean", "161" => "Saudi", "162" => "Senegalese", "163" => "Serbian", "164" => "Seychellois", 
    "165" => "Sierra Leonean", "166" => "Singaporean", "167" => "Slovakian", "168" => "Slovenian", "169" => "Solomon Islander", "170" => "Somali", 
    "171" => "South African", "172" => "South Korean", "173" => "Spanish", "174" => "Sri Lankan", "175" => "Sudanese", "176" => "Surinamer", 
    "177" => "Swazi", "178" => "Swedish", "179" => "Swiss", "180" => "Syrian", "181" => "Taiwanese", "182" => "Tajik", "183" => "Tanzanian", "184" => "Thai", 
    "185" => "Tobagonian", "186" => "Togolese", "187" => "Tongan", "188" => "Trinidadian", "189" => "Tunisian", "190" => "Turkish", "191" => "Tuvaluan", 
    "192" => "Ugandan", "193" => "Ukrainian", "194" => "Uruguayan", "195" => "Uzbekistani", "196" => "Venezuelan", "197" => "Vietnamese", "198" => "Yemenite", 
    "199" => "Zambian", "200" => "Zimbabwean"}
  NATIONALITIES_ARRAY = [["any", "0"], ["American", "1"], ["British", "2"], ["English", "3"], ["Irish", "4"], ["Northern Irish", "5"], ["Canadian", "6"], 
    ["Scottish", "7"], ["Welsh", "8"], ["Australian", "9"], ["Afghan", "10"], ["Albanian", "11"], ["Algerian", "12"], ["Andorran", "13"], 
    ["Angolan", "14"], ["Antiguans", "15"], ["Argentinean", "16"], ["Armenian", "17"], ["Austrian", "18"], ["Azerbaijani", "19"], 
    ["Bahamian", "20"], ["Bahraini", "21"], ["Bangladeshi", "22"], ["Barbadian", "23"], ["Barbudans", "24"], ["Batswana", "25"], 
    ["Belarusian", "26"], ["Belgian", "27"], ["Belizean", "28"], ["Beninese", "29"], ["Bhutanese", "30"], ["Bolivian", "31"], ["Bosnian", "32"], 
    ["Brazilian", "33"], ["Bruneian", "34"], ["Bulgarian", "35"], ["Burkinabe", "36"], ["Burmese", "37"], ["Burundian", "38"], ["Cambodian", "39"], 
    ["Cameroonian", "40"], ["Cape Verdean", "41"], ["Central African", "42"], ["Chadian", "43"], ["Chilean", "44"], ["Chinese", "45"], 
    ["Colombian", "46"], ["Comoran", "47"], ["Congolese", "48"], ["Congolese", "49"], ["Costa Rican", "50"], ["Croatian", "51"], ["Cuban", "52"], 
    ["Cypriot", "53"], ["Czech", "54"], ["Danish", "55"], ["Djibouti", "56"], ["Dominican", "57"], ["Dutch", "58"], ["Dutchman", "59"], 
    ["Dutchwoman", "60"], ["East Timorese", "61"], ["Ecuadorean", "62"], ["Egyptian", "63"], ["Emirian", "64"], ["Equatorial Guinean", "65"], 
    ["Eritrean", "66"], ["Estonian", "67"], ["Ethiopian", "68"], ["Fijian", "69"], ["Filipino", "70"], ["Finnish", "71"], ["French", "72"], 
    ["Gabonese", "73"], ["Gambian", "74"], ["Georgian", "75"], ["German", "76"], ["Ghanaian", "77"], ["Greek", "78"], ["Grenadian", "79"], 
    ["Guatemalan", "80"], ["Guinea-Bissauan", "81"], ["Guinean", "82"], ["Guyanese", "83"], ["Haitian", "84"], ["Herzegovinian", "85"], 
    ["Honduran", "86"], ["Hungarian", "87"], ["I-Kiribati", "88"], ["Icelander", "89"], ["Indian", "90"], ["Indonesian", "91"], ["Iranian", "92"], 
    ["Iraqi", "93"], ["Israeli", "94"], ["Italian", "95"], ["Ivorian", "96"], ["Jamaican", "97"], ["Japanese", "98"], ["Jordanian", "99"], 
    ["Kazakhstani", "100"], ["Kenyan", "101"], ["Kittian and Nevisian", "102"], ["Kuwaiti", "103"], ["Kyrgyz", "104"], ["Laotian", "105"], 
    ["Latvian", "106"], ["Lebanese", "107"], ["Liberian", "108"], ["Libyan", "109"], ["Liechtensteiner", "110"], ["Lithuanian", "111"], 
    ["Luxembourger", "112"], ["Macedonian", "113"], ["Malagasy", "114"], ["Malawian", "115"], ["Malaysian", "116"], ["Maldivan", "117"], 
    ["Malian", "118"], ["Maltese", "119"], ["Marshallese", "120"], ["Mauritanian", "121"], ["Mauritian", "122"], ["Mexican", "123"], 
    ["Micronesian", "124"], ["Moldovan", "125"], ["Monacan", "126"], ["Mongolian", "127"], ["Moroccan", "128"], ["Mosotho", "129"], 
    ["Motswana", "130"], ["Mozambican", "131"], ["Namibian", "132"], ["Nauruan", "133"], ["Nepalese", "134"], ["Netherlander", "135"], 
    ["New Zealander", "136"], ["Ni-Vanuatu", "137"], ["Nicaraguan", "138"], ["Nigerian", "139"], ["Nigerien", "140"], ["North Korean", "141"], 
    ["Norwegian", "142"], ["Omani", "143"], ["Pakistani", "144"], ["Palauan", "145"], ["Panamanian", "146"], ["Papua New Guinean", "147"], 
    ["Paraguayan", "148"], ["Peruvian", "149"], ["Polish", "150"], ["Portuguese", "151"], ["Qatari", "152"], ["Romanian", "153"], ["Russian", "154"], 
    ["Rwandan", "155"], ["Saint Lucian", "156"], ["Salvadoran", "157"], ["Samoan", "158"], ["San Marinese", "159"], ["Sao Tomean", "160"], 
    ["Saudi", "161"], ["Senegalese", "162"], ["Serbian", "163"], ["Seychellois", "164"], ["Sierra Leonean", "165"], ["Singaporean", "166"], 
    ["Slovakian", "167"], ["Slovenian", "168"], ["Solomon Islander", "169"], ["Somali", "170"], ["South African", "171"], ["South Korean", "172"], 
    ["Spanish", "173"], ["Sri Lankan", "174"], ["Sudanese", "175"], ["Surinamer", "176"], ["Swazi", "177"], ["Swedish", "178"], ["Swiss", "179"], 
    ["Syrian", "180"], ["Taiwanese", "181"], ["Tajik", "182"], ["Tanzanian", "183"], ["Thai", "184"], ["Tobagonian", "185"], ["Togolese", "186"], 
    ["Tongan", "187"], ["Trinidadian", "188"], ["Tunisian", "189"], ["Turkish", "190"], ["Tuvaluan", "191"], ["Ugandan", "192"], ["Ukrainian", "193"], 
    ["Uruguayan", "194"], ["Uzbekistani", "195"], ["Venezuelan", "196"], ["Vietnamese", "197"], ["Yemenite", "198"], ["Zambian", "199"], 
    ["Zimbabwean", "200"]]
  LANGUAGES = {"1" => "Afrikaans", "2" => "Albanian", "3" => "Arabic", "4" => "Armenian", "5" => "Basque", "6" => "Bengali", "7" => "Bulgarian", "8" => "Catalan", "9" => "Central Khmer", "10" => "Chinese", "11" => "Croatian", "12" => "Czech", "13" => "Danish", "14" => "Dutch", "15" => "English", "16" => "Estonian", "17" => "Fijian", "18" => "Finnish", "19" => "French", "20" => "Georgian", "21" => "German", "22" => "Gujarati", "23" => "Hebrew", "24" => "Hindi", "25" => "Hungarian", "26" => "Icelandic", "27" => "Indonesian", "28" => "Irish", "29" => "Italian", "30" => "Japanese", "31" => "Korean", "32" => "Latin", "33" => "Latvian", "34" => "Lithuanian", "35" => "Macedonian", "36" => "Malay", "37" => "Malayalam", "38" => "Maltese", "39" => "Maori", "40" => "Marathi", "41" => "Modern Greek (1453-)", "42" => "Mongolian", "43" => "Nepali", "44" => "Norwegian", "45" => "Panjabi", "46" => "Persian", "47" => "Polish", "48" => "Portuguese", "49" => "Quechua", "50" => "Romanian", "51" => "Russian", "52" => "Samoan", "53" => "Serbian", "54" => "Slovak", "55" => "Slovenian", "56" => "Spanish", "57" => "Swahili", "58" => "Swedish", "59" => "Tamil", "60" => "Tatar", "61" => "Telugu", "62" => "Thai", "63" => "Tibetan", "64" => "Tonga (Tonga Islands)", "65" => "Turkish", "66" => "Ukrainian", "67" => "Urdu", "68" => "Uzbek", "69" => "Vietnamese", "70" => "Welsh", "71" => "Xhosa"}
  LANGUAGES_ARRAY = [["Afrikaans", "1"], ["Albanian", "2"], ["Arabic", "3"], ["Armenian", "4"], ["Basque", "5"], ["Bengali", "6"], ["Bulgarian", "7"], ["Catalan", "8"], ["Central Khmer", "9"], ["Chinese", "10"], ["Croatian", "11"], ["Czech", "12"], ["Danish", "13"], ["Dutch", "14"], ["English", "15"], ["Estonian", "16"], ["Fijian", "17"], ["Finnish", "18"], ["French", "19"], ["Georgian", "20"], ["German", "21"], ["Gujarati", "22"], ["Hebrew", "23"], ["Hindi", "24"], ["Hungarian", "25"], ["Icelandic", "26"], ["Indonesian", "27"], ["Irish", "28"], ["Italian", "29"], ["Japanese", "30"], ["Korean", "31"], ["Latin", "32"], ["Latvian", "33"], ["Lithuanian", "34"], ["Macedonian", "35"], ["Malay", "36"], ["Malayalam", "37"], ["Maltese", "38"], ["Maori", "39"], ["Marathi", "40"], ["Modern Greek (1453-)", "41"], ["Mongolian", "42"], ["Nepali", "43"], ["Norwegian", "44"], ["Panjabi", "45"], ["Persian", "46"], ["Polish", "47"], ["Portuguese", "48"], ["Quechua", "49"], ["Romanian", "50"], ["Russian", "51"], ["Samoan", "52"], ["Serbian", "53"], ["Slovak", "54"], ["Slovenian", "55"], ["Spanish", "56"], ["Swahili", "57"], ["Swedish", "58"], ["Tamil", "59"], ["Tatar", "60"], ["Telugu", "61"], ["Thai", "62"], ["Tibetan", "63"], ["Tonga (Tonga Islands)", "64"], ["Turkish", "65"], ["Ukrainian", "66"], ["Urdu", "67"], ["Uzbek", "68"], ["Vietnamese", "69"], ["Welsh", "70"], ["Xhosa", "71"]]
  COUNTRIES = {"1" => "Andorra", "2" => "United Arab Emirates", "3" => "Afghanistan", "4" => "Antigua and Barbuda", "5" => "Anguilla", "6" => "Albania", "7" => "Armenia", "8" => "Netherlands Antilles", "9" => "Angola", "10" => "Antarctica", "11" => "Argentina", "12" => "American Samoa", "13" => "Austria", "14" => "Australia", "15" => "Aruba", "16" => "Åland Islands", "17" => "Azerbaijan", "18" => "Bosnia and Herzegovina", "19" => "Barbados", "20" => "Bangladesh", "21" => "Belgium", "22" => "Burkina Faso", "23" => "Bulgaria", "24" => "Bahrain", "25" => "Burundi", "26" => "Benin", "27" => "Saint Barthélemy", "28" => "Bermuda", "29" => "Brunei Darussalam", "30" => "Bolivia", "31" => "Bonaire, Sint Eustatius and Saba", "32" => "Brazil", "33" => "Bahamas", "34" => "Bhutan", "35" => "Bouvet Island", "36" => "Botswana", "37" => "Belarus", "38" => "Belize", "39" => "Canada", "40" => "Cocos (Keeling) Islands", "41" => "Congo, The Democratic Republic Of The", "42" => "Central African Republic", "43" => "Congo", "44" => "Switzerland", "45" => "Côte D'Ivoire", "46" => "Cook Islands", "47" => "Chile", "48" => "Cameroon", "49" => "China", "50" => "Colombia", "51" => "Costa Rica", "52" => "Cuba", "53" => "Cape Verde", "54" => "Curaçao", "55" => "Christmas Island", "56" => "Cyprus", "57" => "Czech Republic", "58" => "Germany", "59" => "Djibouti", "60" => "Denmark", "61" => "Dominica", "62" => "Dominican Republic", "63" => "Algeria", "64" => "Ecuador", "65" => "Estonia", "66" => "Egypt", "67" => "Western Sahara", "68" => "Eritrea", "69" => "Spain", "70" => "Ethiopia", "71" => "Finland", "72" => "Fiji", "73" => "Falkland Islands (Malvinas)", "74" => "Micronesia, Federated States Of", "75" => "Faroe Islands", "76" => "France", "77" => "Gabon", "78" => "United Kingdom", "79" => "Grenada", "80" => "Georgia", "81" => "French Guiana", "82" => "Guernsey", "83" => "Ghana", "84" => "Gibraltar", "85" => "Greenland", "86" => "Gambia", "87" => "Guinea", "88" => "Guadeloupe", "89" => "Equatorial Guinea", "90" => "Greece", "91" => "South Georgia and the South Sandwich Islands", "92" => "Guatemala", "93" => "Guam", "94" => "Guinea-Bissau", "95" => "Guyana", "96" => "Hong Kong", "97" => "Heard and McDonald Islands", "98" => "Honduras", "99" => "Croatia", "100" => "Haiti", "101" => "Hungary", "102" => "Indonesia", "103" => "Ireland", "104" => "Israel", "105" => "Isle of Man", "106" => "India", "107" => "British Indian Ocean Territory", "108" => "Iraq", "109" => "Iran, Islamic Republic Of", "110" => "Iceland", "111" => "Italy", "112" => "Jersey", "113" => "Jamaica", "114" => "Jordan", "115" => "Japan", "116" => "Kenya", "117" => "Kyrgyzstan", "118" => "Cambodia", "119" => "Kiribati", "120" => "Comoros", "121" => "Saint Kitts And Nevis", "122" => "Korea, Democratic People's Republic Of", "123" => "Korea, Republic of", "124" => "Kuwait", "125" => "Cayman Islands", "126" => "Kazakhstan", "127" => "Lao People's Democratic Republic", "128" => "Lebanon", "129" => "Saint Lucia", "130" => "Liechtenstein", "131" => "Sri Lanka", "132" => "Liberia", "133" => "Lesotho", "134" => "Lithuania", "135" => "Luxembourg", "136" => "Latvia", "137" => "Libya", "138" => "Morocco", "139" => "Monaco", "140" => "Moldova, Republic of", "141" => "Montenegro", "142" => "Saint Martin", "143" => "Madagascar", "144" => "Marshall Islands", "145" => "Macedonia, the Former Yugoslav Republic Of", "146" => "Mali", "147" => "Myanmar", "148" => "Mongolia", "149" => "Macao", "150" => "Northern Mariana Islands", "151" => "Martinique", "152" => "Mauritania", "153" => "Montserrat", "154" => "Malta", "155" => "Mauritius", "156" => "Maldives", "157" => "Malawi", "158" => "Mexico", "159" => "Malaysia", "160" => "Mozambique", "161" => "Namibia", "162" => "New Caledonia", "163" => "Niger", "164" => "Norfolk Island", "165" => "Nigeria", "166" => "Nicaragua", "167" => "Netherlands", "168" => "Norway", "169" => "Nepal", "170" => "Nauru", "171" => "Niue", "172" => "New Zealand", "173" => "Oman", "174" => "Panama", "175" => "Peru", "176" => "French Polynesia", "177" => "Papua New Guinea", "178" => "Philippines", "179" => "Pakistan", "180" => "Poland", "181" => "Saint Pierre And Miquelon", "182" => "Pitcairn", "183" => "Puerto Rico", "184" => "Palestine, State of", "185" => "Portugal", "186" => "Palau", "187" => "Paraguay", "188" => "Qatar", "189" => "Réunion", "190" => "Romania", "191" => "Serbia", "192" => "Russian Federation", "193" => "Rwanda", "194" => "Saudi Arabia", "195" => "Solomon Islands", "196" => "Seychelles", "197" => "Sudan", "198" => "Sweden", "199" => "Singapore", "200" => "Saint Helena", "201" => "Slovenia", "202" => "Svalbard And Jan Mayen", "203" => "Slovakia", "204" => "Sierra Leone", "205" => "San Marino", "206" => "Senegal", "207" => "Somalia", "208" => "Suriname", "209" => "South Sudan", "210" => "Sao Tome and Principe", "211" => "El Salvador", "212" => "Sint Maarten", "213" => "Syrian Arab Republic", "214" => "Swaziland", "215" => "Turks and Caicos Islands", "216" => "Chad", "217" => "French Southern Territories", "218" => "Togo", "219" => "Thailand", "220" => "Tajikistan", "221" => "Tokelau", "222" => "Timor-Leste", "223" => "Turkmenistan", "224" => "Tunisia", "225" => "Tonga", "226" => "Turkey", "227" => "Trinidad and Tobago", "228" => "Tuvalu", "229" => "Taiwan, Republic Of China", "230" => "Tanzania, United Republic of", "231" => "Ukraine", "232" => "Uganda", "233" => "United States Minor Outlying Islands", "234" => "United States", "235" => "Uruguay", "236" => "Uzbekistan", "237" => "Holy See (Vatican City State)", "238" => "Saint Vincent And The Grenedines", "239" => "Venezuela, Bolivarian Republic of", "240" => "Virgin Islands, British", "241" => "Virgin Islands, U.S.", "242" => "Vietnam", "243" => "Vanuatu", "244" => "Wallis and Futuna", "245" => "Samoa", "246" => "Yemen", "247" => "Mayotte", "248" => "South Africa", "249" => "Zambia", "250" => "Zimbabwe"}
  COUNTRIES_ARRAY = [["Andorra", "1"], ["United Arab Emirates", "2"], ["Afghanistan", "3"], ["Antigua and Barbuda", "4"], ["Anguilla", "5"], 
    ["Albania", "6"], ["Armenia", "7"], ["Netherlands Antilles", "8"], ["Angola", "9"], ["Antarctica", "10"], ["Argentina", "11"], ["American Samoa", "12"], 
    ["Austria", "13"], ["Australia", "14"], ["Aruba", "15"], ["Åland Islands", "16"], ["Azerbaijan", "17"], ["Bosnia and Herzegovina", "18"], ["Barbados", "19"], 
    ["Bangladesh", "20"], ["Belgium", "21"], ["Burkina Faso", "22"], ["Bulgaria", "23"], ["Bahrain", "24"], ["Burundi", "25"], ["Benin", "26"], 
    ["Saint Barthélemy", "27"], ["Bermuda", "28"], ["Brunei Darussalam", "29"], ["Bolivia", "30"], ["Bonaire, Sint Eustatius and Saba", "31"], ["Brazil", "32"], 
    ["Bahamas", "33"], ["Bhutan", "34"], ["Bouvet Island", "35"], ["Botswana", "36"], ["Belarus", "37"], ["Belize", "38"], ["Canada", "39"], 
    ["Cocos (Keeling) Islands", "40"], ["Congo, The Democratic Republic Of The", "41"], ["Central African Republic", "42"], ["Congo", "43"], ["Switzerland", "44"], 
    ["Côte D'Ivoire", "45"], ["Cook Islands", "46"], ["Chile", "47"], ["Cameroon", "48"], ["China", "49"], ["Colombia", "50"], ["Costa Rica", "51"], ["Cuba", "52"], 
    ["Cape Verde", "53"], ["Curaçao", "54"], ["Christmas Island", "55"], ["Cyprus", "56"], ["Czech Republic", "57"], ["Germany", "58"], ["Djibouti", "59"], 
    ["Denmark", "60"], ["Dominica", "61"], ["Dominican Republic", "62"], ["Algeria", "63"], ["Ecuador", "64"], ["Estonia", "65"], ["Egypt", "66"], 
    ["Western Sahara", "67"], ["Eritrea", "68"], ["Spain", "69"], ["Ethiopia", "70"], ["Finland", "71"], ["Fiji", "72"], ["Falkland Islands (Malvinas)", "73"], 
    ["Micronesia, Federated States Of", "74"], ["Faroe Islands", "75"], ["France", "76"], ["Gabon", "77"], ["United Kingdom", "78"], ["Grenada", "79"], 
    ["Georgia", "80"], ["French Guiana", "81"], ["Guernsey", "82"], ["Ghana", "83"], ["Gibraltar", "84"], ["Greenland", "85"], ["Gambia", "86"], ["Guinea", "87"], 
    ["Guadeloupe", "88"], ["Equatorial Guinea", "89"], ["Greece", "90"], ["South Georgia and the South Sandwich Islands", "91"], ["Guatemala", "92"], 
    ["Guam", "93"], ["Guinea-Bissau", "94"], ["Guyana", "95"], ["Hong Kong", "96"], ["Heard and McDonald Islands", "97"], ["Honduras", "98"], ["Croatia", "99"], 
    ["Haiti", "100"], ["Hungary", "101"], ["Indonesia", "102"], ["Ireland", "103"], ["Israel", "104"], ["Isle of Man", "105"], ["India", "106"], 
    ["British Indian Ocean Territory", "107"], ["Iraq", "108"], ["Iran, Islamic Republic Of", "109"], ["Iceland", "110"], ["Italy", "111"], ["Jersey", "112"], 
    ["Jamaica", "113"], ["Jordan", "114"], ["Japan", "115"], ["Kenya", "116"], ["Kyrgyzstan", "117"], ["Cambodia", "118"], ["Kiribati", "119"], ["Comoros", "120"], 
    ["Saint Kitts And Nevis", "121"], ["Korea, Democratic People's Republic Of", "122"], ["Korea, Republic of", "123"], ["Kuwait", "124"], ["Cayman Islands", "125"], 
    ["Kazakhstan", "126"], ["Lao People's Democratic Republic", "127"], ["Lebanon", "128"], ["Saint Lucia", "129"], ["Liechtenstein", "130"], ["Sri Lanka", "131"], 
    ["Liberia", "132"], ["Lesotho", "133"], ["Lithuania", "134"], ["Luxembourg", "135"], ["Latvia", "136"], ["Libya", "137"], ["Morocco", "138"], ["Monaco", "139"], 
    ["Moldova, Republic of", "140"], ["Montenegro", "141"], ["Saint Martin", "142"], ["Madagascar", "143"], ["Marshall Islands", "144"], 
    ["Macedonia, the Former Yugoslav Republic Of", "145"], ["Mali", "146"], ["Myanmar", "147"], ["Mongolia", "148"], ["Macao", "149"], 
    ["Northern Mariana Islands", "150"], ["Martinique", "151"], ["Mauritania", "152"], ["Montserrat", "153"], ["Malta", "154"], ["Mauritius", "155"], 
    ["Maldives", "156"], ["Malawi", "157"], ["Mexico", "158"], ["Malaysia", "159"], ["Mozambique", "160"], ["Namibia", "161"], ["New Caledonia", "162"], 
    ["Niger", "163"], ["Norfolk Island", "164"], ["Nigeria", "165"], ["Nicaragua", "166"], ["Netherlands", "167"], ["Norway", "168"], ["Nepal", "169"], 
    ["Nauru", "170"], ["Niue", "171"], ["New Zealand", "172"], ["Oman", "173"], ["Panama", "174"], ["Peru", "175"], ["French Polynesia", "176"], 
    ["Papua New Guinea", "177"], ["Philippines", "178"], ["Pakistan", "179"], ["Poland", "180"], ["Saint Pierre And Miquelon", "181"], ["Pitcairn", "182"], 
    ["Puerto Rico", "183"], ["Palestine, State of", "184"], ["Portugal", "185"], ["Palau", "186"], ["Paraguay", "187"], ["Qatar", "188"], ["Réunion", "189"], 
    ["Romania", "190"], ["Serbia", "191"], ["Russian Federation", "192"], ["Rwanda", "193"], ["Saudi Arabia", "194"], ["Solomon Islands", "195"], 
    ["Seychelles", "196"], ["Sudan", "197"], ["Sweden", "198"], ["Singapore", "199"], ["Saint Helena", "200"], ["Slovenia", "201"], ["Svalbard And Jan Mayen", "202"], 
    ["Slovakia", "203"], ["Sierra Leone", "204"], ["San Marino", "205"], ["Senegal", "206"], ["Somalia", "207"], ["Suriname", "208"], ["South Sudan", "209"], 
    ["Sao Tome and Principe", "210"], ["El Salvador", "211"], ["Sint Maarten", "212"], ["Syrian Arab Republic", "213"], ["Swaziland", "214"], 
    ["Turks and Caicos Islands", "215"], ["Chad", "216"], ["French Southern Territories", "217"], ["Togo", "218"], ["Thailand", "219"], ["Tajikistan", "220"], 
    ["Tokelau", "221"], ["Timor-Leste", "222"], ["Turkmenistan", "223"], ["Tunisia", "224"], ["Tonga", "225"], ["Turkey", "226"], ["Trinidad and Tobago", "227"], 
    ["Tuvalu", "228"], ["Taiwan, Republic Of China", "229"], ["Tanzania, United Republic of", "230"], ["Ukraine", "231"], ["Uganda", "232"], 
    ["United States Minor Outlying Islands", "233"], ["United States", "234"], ["Uruguay", "235"], ["Uzbekistan", "236"], ["Holy See (Vatican City State)", "237"], 
    ["Saint Vincent And The Grenedines", "238"], ["Venezuela, Bolivarian Republic of", "239"], ["Virgin Islands, British", "240"], ["Virgin Islands, U.S.", "241"], 
    ["Vietnam", "242"], ["Vanuatu", "243"], ["Wallis and Futuna", "244"], ["Samoa", "245"], ["Yemen", "246"], ["Mayotte", "247"], ["South Africa", "248"], 
    ["Zambia", "249"], ["Zimbabwe", "250"]]
  SUBREGIONS = ["Australia and New Zealand", "Caribbean", "Central America", "Central Asia", "Eastern Africa", "Eastern Asia", "Eastern Europe", "Melanesia", "Micronesia", "Middle Africa", "Northern Africa", "Northern America", "Northern Europe", "Polynesia", "South America", "South-Eastern Asia", "Southern Africa", "Southern Asia", "Southern Europe", "Western Africa", "Western Asia", "Western Europe"]
  
  # associations
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :trips
  has_many :interests, dependent: :destroy
  has_many :join_requests_sent, dependent: :destroy, class_name: "JoinRequest"
  has_many :join_requests_received, through: :trips, source: :join_requests
  has_one :survey
  has_many :image_attachments, as: :image_attachable, dependent: :destroy
  accepts_nested_attributes_for :image_attachments, allow_destroy: true
  has_many :followings, dependent: :destroy
  has_many :followed_trips, through: :followings, source: :followable, source_type: "Trip"
  has_many :activities, dependent: :destroy
  has_many :feed_items, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :sent_messages, foreign_key: "sender_id", class_name: "Message", dependent: :destroy
  has_many :received_messages, foreign_key: "receiver_id", class_name: "Message"
  # has_many :message_receivers, through: :sent_messages, source: :receiver
  # has_many :message_senders, through: :received_messages, source: :sender
  # http://stackoverflow.com/questions/20755890/friendship-has-many-through-model-with-multiple-status
  has_many :friendings, dependent: :destroy
  has_many :friends, through: :friendings, source: :friend
  
  # callbacks
  before_create { generate_number(:number_id) }
  before_create { generate_token(:auth_token) }
  after_create :build_email_blob
  before_save :correct_case_of_inputs
  after_commit :send_user_verification_email, on: :create
  # after_commit :build_interests 
  
  # validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true
  validates :birthday, presence: true
  validates_format_of :email, :with => /@/
  validates :password, presence: true, on: :create
  # validates_date :birthday, allow_blank: true
      
  
  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.fb_location = auth.info.location
      user.fb_hometown = auth.extra.raw_info.hometown.name if auth.extra.raw_info.hometown && auth.extra.raw_info.hometown != nil
      user.fb_image = auth.info.image
      user.fb_url = auth.info.urls.Facebook
      user.fb_locale = auth.extra.raw_info.locale
      user.fb_timezone = auth.extra.raw_info.timezone
      user.fb_updated_time = auth.extra.raw_info.updated_time
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.birthday = Date.strptime(auth.extra.raw_info.birthday,'%m/%d/%Y') if auth.extra.raw_info.birthday
      user.verified = auth.info.verified
      user.gender = auth.extra.raw_info.gender
      if auth.extra.raw_info.work
        auth.extra.raw_info.work.each do |employer|
          user.fb_occupation = employer.position.name unless employer.end_date.present?
        end
      end
      user.newsletter = true
      user.password = SecureRandom.urlsafe_base64
      logger.debug "%%%%%%%%%%% AUTH: #{auth}"
      user.save!
    end
  end
  
  def self.fb_image_random_5
    self.where.not(fb_image: nil).pluck(:fb_image).shuffle.first(5)
  end
  
  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
    Notification.add_to(other_user, "Q", self)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  def add_friend(user)
    logger.debug "******FRIEND #{user.full_name}"
    logger.debug "******USER #{self.full_name}"
    friending = self.friendings.new(friend_id: user.id)
    friending.save
    logger.debug "******friending #{friending.errors}"
  end
  
  def remove_friend(user)
    if self.friendings.where(friend_id: user.id).any?
      friending = self.friendings.where(friend_id: user.id).first
      friending.destroy
    end
  end
  
  def unsubscribed
    self.subscribed == false ? true : false
  end
  
  def build_email_blob
    x = []
    User::EMAILS_ARRAY.each do |ea|
      ea[2].each do |e|
        x << e[1]
      end
    end
    self.email_blob = x.join(",")
    self.save
  end
  
  def subscribed_to?(email_type)
    self.email_blob.include?(email_type) ? true : false
  end
  
  def unsubscribe_from(email_type)
    if self.email_blob.include?(email_type)
      self.email_blob.sub! email_type, ""
      array = self.email_blob.split(",") - ["", nil]
      self.email_blob = array.join(",")
      self.save
    end
  end
  
  def activity_percentage
    days_active = self.activity_trail.count("1")
    days_inactive = self.activity_trail.count("0")
    ((days_active.to_f / (days_inactive + days_active).to_f) * 100).round
  end
  
  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  end
  
  def build_interests
    Interest::IDS.each do |identifier_group|
      identifier_group[1].each do |identifier|
        self.interests.create!(identifier: identifier, category: identifier_group[0])
      end
    end
  end
  
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil # or consider a custom null object
  end
  
  def facebook_friends
    facebook { |fb| fb.get_connection("me", "friends") }
  end
  
  def facebook_friends_photos_rand5
    x = []
    5.times do
      x << self.facebook.get_picture(self.facebook_friends.shuffle.first['id'])
    end
    x
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
  def generate_number(column)
    begin
      self[column] = rand(100000000000).to_s
    end while User.exists?(column => self[column])
  end
  
  def full_name
    self.first_name + " " + self.last_name if self.first_name && self.last_name
  end
  
  def complete_welcome
    self.welcome_complete = true
    self.save
  end
  
  def correct_case_of_inputs
    self.email = self.email.strip.downcase
    self.first_name = self.first_name.strip
    self.last_name = self.last_name.strip
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.user_password_reset_email(self).deliver
  end
  
  def send_user_verification_email
    VerificationWorker.perform_async(self.id)
    # generate_token(:verification_token)
    # save!
    # UserMailer.user_verification_email(self).deliver
  end
  
  def percent_of_days_active
    ((self.activity_trail.count("1").to_f / self.activity_trail.length.to_f) * 100).round(1)
  end
  
  def active_more_than?(percent)
    if self.percent_of_days_active > percent
      true
    else
      false
    end
  end
end
