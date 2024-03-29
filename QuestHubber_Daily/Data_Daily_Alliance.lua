local qhub = QuestHubber
if not qhub then return end

local fg = UnitFactionGroup("player")
if fg == "Alliance" then

qhub:RegisterQuests({
	[700] = {
		[28861] = "80:0:0:84:84:4960:2920:48010:Low Shaman Blundy::0:0:0",
		[28862] = "80:0:0:84:84:4960:2920:48010:Low Shaman Blundy::0:0:0",
		[28863] = "80:0:0:84:84:4860:3060:49386:Craw MacGraw::0:0:0",
		[28864] = "80:0:0:84:84:4900:2980:46591:Colin Thundermar::0:0:0",
		[28860] = "80:0:0:84:84:4900:2980:46591:Colin Thundermar::0:0:0",
	},
	[81] = {
		[25671] = "80:0:0:28:25:5940:5679:40896:Lord Fallowmere::0:0:0",
	},
	[473] = {
		[11076] = "80:0:0:70:70:6300:8780:23149:Mistress of the Mines::11075:0:0",
	},
	[504] = {
		[13103] = "80:0:0:1:65:4040:6580:28705:Katherine Lee::0:0:0",
		[13100] = "80:0:0:1:65:4040:6580:28705:Katherine Lee::0:0:0",
		[13101] = "80:0:0:1:65:4040:6580:28705:Katherine Lee::0:0:0",
		[13102] = "80:0:0:1:65:4040:6580:28705:Katherine Lee::0:0:0",
		[13107] = "80:0:0:1:65:4040:6580:28705:Katherine Lee::0:0:0",
	},
	[490] = {
		[12437] = "80:0:0:74:73:1480:8660:27759:Commander Howser::0:0:0",
		[12289] = "80:0:0:74:73:3920:4380:27468:Sergeant Hartsman::0:0:0",
		[12323] = "80:0:0:74:73:2200:8080:27602:Sergeant Downey::0:0:0",
		[12314] = "80:0:0:74:73:2200:8120:27520:Baron Freeman::0:0:0",
		[12316] = "80:0:0:74:73:2200:8120:27562:Lieutenant Stuart::0:0:0",
		[12444] = "1104:0:0:74:73:2980:5980:27783:Scout Captain Carter::0:0:0",
		[12296] = "80:0:0:74:73:4040:4260:27484:Rheanna::0:0:0",
		[12268] = "80:0:0:74:73:3960:4320:27416:Pipthwack::0:0:0",
		[12244] = "80:0:0:74:73:3940:4340:27371:Synipus::0:0:0",
	},
	[491] = {
		[11391] = "80:0:0:71:69:3080:2859:24399:Steel Gate Chief Archaeologist::11390:0:0",
		[11153] = "80:0:0:71:68:2900:4200:23895:Bombardier Petrov::0:0:0",
	},
	[492] = {
		[14152] = "80:0:0:80:78:7620:1960:34880:Narasi Snowdawn::0:0:0",
		[13404] = "80:0:0:80:77:5400:4280:32444:Kibli Killohertz::0:0:0",
		[13788] = "80:32:0:80:77:7380:2000:33762:Crok Scourgebane::0:0:0",
		[13789] = "80:0:0:80:77:6979:2340:33763:Cellian Daybreak::0:0:0",
		[13790] = "80:0:0:80:77:6979:2340:33771:Luuri::0:0:0",
		[13791] = "80:32:0:80:77:7380:1940:33769:Zor'be the Bloodletter::0:0:0",
		[13284] = "80:0:0:80:77:6260:5160:31737:Skybreaker Squad Leader::0:0:0",
		[13666] = "80:0:0:80:77:7640:1940:33625:Arcanist Taelis::0:0:0",
		[13669] = "80:0:0:80:77:7640:1940:33625:Arcanist Taelis::0:0:0",
		[13670] = "80:0:0:80:77:7640:1940:33625:Arcanist Taelis::0:0:0",
		[13671] = "80:0:0:80:77:7640:1940:33646:Avareth Swiftstrike::0:0:0",
		[13292] = "80:0:0:80:77:6140:4740:30345:Chief Engineer Boltwrench::0:0:0",
		[13297] = "80:0:0:80:77:5620:3820:29799:Thassarian::0:0:0",
		[13300] = "80:0:0:80:77:5639:4160:31259:Absalan the Pious::0:0:0",
		[13682] = "80:0:0:80:77:6979:2340:33759:Eadric the Pure::0:0:0",
		[13309] = "80:0:0:80:77:6260:5120:31808:Ground Commander Koup::0:0:0",
		[14074] = "80:0:0:80:77:7620:1960:34880:Narasi Snowdawn::0:0:0",
		[14076] = "80:0:0:80:77:7620:1940:34912:Savinia Loresong::0:0:0",
		[14077] = "80:0:0:80:77:7620:1960:34880:Narasi Snowdawn::0:0:0",
		[14080] = "80:0:0:80:77:7620:1960:34880:Narasi Snowdawn::0:0:0",
		[13322] = "80:0:0:80:77:6140:4740:30345:Chief Engineer Boltwrench::0:0:0",
		[13323] = "80:0:0:80:77:5620:3820:29799:Thassarian::0:0:0",
		[14090] = "80:0:0:80:77:7620:1940:34912:Savinia Loresong::0:0:0",
		[13333] = "80:0:0:80:77:6220:4920:30344:High Captain Justin Bartlett::0:0:0",
		[14096] = "80:0:0:80:77:7620:1960:34880:Narasi Snowdawn::0:0:0",
		[13336] = "80:0:0:80:77:6180:5659:32302:Knight-Captain Drosche::0:0:0",
		[13592] = "80:0:0:80:77:7640:1920:33222:Sir Marcus Barlowe::0:0:0",
		[13847] = "80:0:0:80:77:7660:1920:33223:Captain Joseph Holley::0:0:0",
		[13851] = "80:0:0:80:77:7660:1940:33309:Clara Tumblebrew::0:0:0",
		[13852] = "80:0:0:80:77:7640:1980:33649:Flickin Gearspanner::0:0:0",
		[13854] = "80:0:0:80:77:7600:1900:33656:Ranii::0:0:0",
		[13855] = "80:0:0:80:77:7640:1900:33654:Airae Starseeker::0:0:0",
		[13603] = "80:0:0:80:77:7660:1920:33225:Marshal Jacob Alerius::0:0:0",
		[13350] = "80:0:0:80:77:5620:3820:29799:Thassarian::0:0:0",
		[13861] = "80:0:0:80:77:6979:2340:33759:Eadric the Pure::0:0:0",
		[13864] = "80:32:0:80:77:7380:2000:33762:Crok Scourgebane::0:0:0",
		[13743] = "80:0:0:80:77:7660:1940:33312:Lana Stouthammer::0:0:0",
		[13233] = "1104:0:0:80:77:6220:4920:30344:High Captain Justin Bartlett::0:0:0",
		[13742] = "80:0:0:80:77:7660:1940:33312:Lana Stouthammer::0:0:0",
		[13616] = "80:0:0:80:77:7660:1920:33225:Marshal Jacob Alerius::0:0:0",
		[13744] = "80:0:0:80:77:7660:1940:33315:Rollo Sureshot::0:0:0",
		[13745] = "80:0:0:80:77:7660:1940:33309:Clara Tumblebrew::0:0:0",
		[13746] = "80:0:0:80:77:7640:1980:33335:Ambrose Boltspark::0:0:0",
		[13747] = "80:0:0:80:77:7640:1980:33335:Ambrose Boltspark::0:0:0",
		[13748] = "80:0:0:80:77:7640:1980:33335:Ambrose Boltspark::0:0:0",
		[13749] = "80:0:0:80:77:7640:1980:33648:Tickin Gearspanner::0:0:0",
		[13750] = "80:0:0:80:77:7640:1980:33649:Flickin Gearspanner::0:0:0",
		[13280] = "1104:0:0:80:77:5699:6240:31776:Frazzle Geargrinder::13296:0:0",
		[13752] = "80:0:0:80:77:7600:1920:33593:Colosos::0:0:0",
		[13753] = "80:0:0:80:77:7600:1920:33593:Colosos::0:0:0",
		[13754] = "80:0:0:80:77:7600:1920:33593:Colosos::0:0:0",
		[13755] = "80:0:0:80:77:7600:1920:33655:Saandos::0:0:0",
		[13756] = "80:0:0:80:77:7600:1900:33656:Ranii::0:0:0",
		[13757] = "80:0:0:80:77:7620:1900:33592:Jaelyne Evensong::0:0:0",
		[13758] = "80:0:0:80:77:7620:1900:33592:Jaelyne Evensong::0:0:0",
		[13759] = "80:0:0:80:77:7620:1900:33592:Jaelyne Evensong::0:0:0",
		[13760] = "80:0:0:80:77:7620:1900:33652:Illestria Bladesinger::0:0:0",
		[13761] = "80:0:0:80:77:7640:1900:33654:Airae Starseeker::0:0:0",
		[13741] = "80:0:0:80:77:7660:1940:33312:Lana Stouthammer::0:0:0",
		[13382] = "80:0:0:80:77:5400:4280:32444:Kibli Killohertz::13381:0:0",
		[13625] = "80:0:0:80:77:7640:1940:33647:Scout Shalyndria::0:0:0",
		[13344] = "80:0:0:80:77:5620:3820:29799:Thassarian::0:0:0",
		[13600] = "80:0:0:80:77:7660:1920:33225:Marshal Jacob Alerius::0:0:0",
		[13289] = "80:0:0:80:77:5620:3820:29799:Thassarian::0:0:0",
		[13793] = "80:32:0:80:77:7360:2000:33770:Illyrie Nightfall::0:0:0",
		[13665] = "80:0:0:80:77:7660:1920:33223:Captain Joseph Holley::0:0:0",
		[14112] = "80:0:0:80:77:7620:1940:34912:Savinia Loresong::0:0:0",
	},
	[478] = {
		[11505] = "1104:0:0:1:63:5580:5380:24885:Exorcist Sullivan::0:0:0",
	},
	[465] = {
		[10106] = "1104:0:0:60:55:5639:6280:18266:Warrant Officer Tracy Proudwell::0:0:0",
	},
	[301] = {
		[25155] = "80:0:0:1:1:6380:6120:50480:Isabel Jones::0:0:0",
		[26192] = "80:0:0:1:10:5060:7160:42288:Robby Flay::0:0:0",
		[26153] = "80:0:0:1:10:5060:7160:42288:Robby Flay::0:0:0",
		[26442] = "80:0:0:1:10:5500:6939:5494:Catherine Leland::0:0:0",
		[26536] = "80:0:0:1:10:5500:6939:5494:Catherine Leland::0:0:0",
		[26420] = "80:0:0:1:10:5500:6939:5494:Catherine Leland::0:0:0",
		[26190] = "80:0:0:1:10:5060:7160:42288:Robby Flay::0:0:0",
		[26488] = "80:0:0:1:10:5500:6939:5494:Catherine Leland::0:0:0",
		[26177] = "80:0:0:1:10:5060:7160:42288:Robby Flay::0:0:0",
		[26183] = "80:0:0:1:10:5060:7160:42288:Robby Flay::0:0:0",
		[25105] = "80:0:0:1:1:6380:6120:50480:Isabel Jones::0:0:0",
		[26414] = "80:0:0:1:10:5500:6939:5494:Catherine Leland::0:0:0",
		[25157] = "80:0:0:1:1:6380:6120:50480:Isabel Jones::0:0:0",
		[25156] = "80:0:0:1:1:6380:6120:50480:Isabel Jones::0:0:0",
		[25154] = "80:0:0:1:1:6380:6120:50480:Isabel Jones::0:0:0",
	},
	[477] = {
		[11502] = "1104:0:0:70:64:5580:7360:24866:Lakoor::0:0:0",
	},
	[709] = {
		[27971] = "80:0:0:85:85:7374:5779:48255:Camp Coordinator Brack::0:0:0",
		[27987] = "80:0:0:85:85:7310:6071:48254:Sergeant Gray::0:0:0",
		[27972] = "80:0:0:85:85:7368:5772:48255:Camp Coordinator Brack::0:0:0",
		[28050] = "80:0:0:85:85:7370:5777:48255:Camp Coordinator Brack::0:0:0",
		[27973] = "80:0:0:85:85:7310:6071:48254:Sergeant Gray::0:0:0",
		[28130] = "80:0:0:85:85:7330:5940:47240:Commander Marcus Johnson::0:0:0",
		[27991] = "80:0:0:85:85:7304:6083:48254:Sergeant Gray::0:0:0",
		[27992] = "80:0:0:85:85:7465:5947:48250:Lieutenant Farnsworth::0:0:0",
		[27978] = "80:0:0:85:85:7294:6085:48254:Sergeant Gray::0:0:0",
		[27948] = "80:0:0:85:85:7365:5765:48255:Camp Coordinator Brack::0:0:0",
		[27949] = "80:0:0:85:85:7461:5968:48250:Lieutenant Farnsworth::0:0:0",
		[27966] = "80:0:0:85:85:7468:5940:48250:Lieutenant Farnsworth::0:0:0",
		[28137] = "80:0:0:85:85:7322:5927:47240:Commander Marcus Johnson::0:0:0",
		[27967] = "80:0:0:85:85:7466:5940:48250:Lieutenant Farnsworth::0:0:0",
		[27944] = "80:0:0:85:85:7376:5783:48255:Camp Coordinator Brack::0:0:0",
		[28046] = "80:0:0:85:85:7468:5940:48250:Lieutenant Farnsworth::0:0:0",
		[27975] = "80:0:0:85:85:7301:6082:48254:Sergeant Gray::0:0:0",
		[28065] = "80:0:0:85:85:7322:5927:47240:Commander Marcus Johnson::0:0:0",
		[27970] = "80:0:0:85:85:7376:5783:48255:Camp Coordinator Brack::0:0:0",
		[28059] = "80:0:0:85:85:7327:5908:47240:Commander Marcus Johnson::0:0:0",
		[28063] = "80:0:0:85:85:7330:5940:47240:Commander Marcus Johnson::0:0:0",
	},
	[495] = {
		[12869] = "80:0:0:78:77:2980:7560:29732:Fjorlin Frostbrow::0:0:0",
	},
	[708] = {
		[28185] = "80:0:0:85:85:5140:4940:48061:2nd Lieutenant Wansworth::0:0:0",
		[28223] = "80:0:0:85:85:5140:4940:48074:Marshal Fallows::0:0:0",
		[28122] = "80:0:0:85:85:5080:4960:48066:Sergeant Parker::0:0:0",
		[28186] = "80:0:0:85:85:5140:4940:48061:2nd Lieutenant Wansworth::0:0:0",
		[28120] = "80:0:0:85:85:5140:4940:48039:Commander Stevens::0:0:0",
		[28232] = "80:0:0:85:85:5140:4940:48074:Marshal Fallows::0:0:0",
		[28118] = "80:0:0:85:85:5140:4940:48039:Commander Stevens::0:0:0",
		[28165] = "80:0:0:85:85:5140:4940:48061:2nd Lieutenant Wansworth::0:0:0",
		[28162] = "80:0:0:85:85:5080:4960:48066:Sergeant Parker::0:0:0",
		[28188] = "80:0:0:85:85:5140:4940:48074:Marshal Fallows::0:0:0",
		[28117] = "80:0:0:85:85:5140:4940:48039:Commander Stevens::0:0:0",
		[28163] = "80:0:0:85:85:5080:4960:48066:Sergeant Parker::0:0:0",
	},
})
end