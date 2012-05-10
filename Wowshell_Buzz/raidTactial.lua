local addon,ns = ...
local tacFunc = CreateFrame("Frame")
local bg = "Interface\\AddOns\\Wowshell_UFShell\texture\\statusbarTexture"


local tactial = {
	["灵魂洪炉"]	= {
			{name = "布隆亚姆", model = 30226, raiders = "P1被点名远离BOSS,DPS集火紫色灵魂球,球吃控制;P2靠近BOSS,被恐惧进入风暴者迅速返回中心,治疗加好被恐惧者。"},
			{name = "噬魂者", model = 30148, raiders = "男人脸注意打断\"魅影冲击\"技能,红色连线出现时立即停止攻击;胖子脸远离鬼魂;女人脸躲开正面\"哀嚎之魂\"技能的扫射范围。"},
		},
		["萨隆矿坑"]	= {
			{name = "熔炉领主加费斯特", model = 30843, raiders = "BOSS\"投掷萨钢\"时躲开地上阴影;在萨钢石后面可以卡视角消除\"极寒冰霜\"DEBUFF,DEBUFF也可以驱散,切勿超过10层。"},
			{name = "依克和科瑞克", model = 30347, raiders = "\"毒气新星\"时远离BOSS;被点名\"失序追击\"人员头上有箭头速度远离BOSS;\"爆裂弹幕\"时躲开紫色爆炸范围;绿水有毒不要站。"},
			{name = "天灾领主泰兰努斯", model = 30277, raiders = "点名\"白霜\"远离人群;点名\"霸主的烙纹\"有红色连线,立即停止攻击;BOSS变大后伤害增加,坦克开技能或风筝BOSS在冰面。"},
		},
		["映像大厅"]	= {
			{name = "小怪", model = 30977, raiders = "战斗前站在墙角卡小怪视野,等坦克建立好仇恨再分散;尽量控制法师或者猎人怪单点击杀;及时驱散队友魔法和诅咒。"},
			{name = "法瑞克", model = 30972,raiders = "优先驱散队友DEBUFF,BOSS释放恐惧前保证队友高血量,坦克中\"颤栗打击\"后注意开技能保命,\"颤栗打击\"也可驱散。"},
			{name = "玛维恩", model = 30973, raiders = "所有人远离黑水;治疗加好中\"苦难共享\"技能的队友,但不要驱散该DEBUFF;\"血肉腐化\"技能期间注意自保。"},
			{name = "逃离巫妖王", model = 25932, raiders = "远离巫妖王,靠近冰墙进行战斗;坦克拉憎恶怪背对人群;优先击杀法系怪,注意打断其施法,及时驱散队友诅咒。"},
		},
		["冠军的试炼"]	= {
			{name = "阵营勇士", model = 28918, raiders = "P1,使用\"冲锋\"和\"戳刺\"配合\"破盾\"击杀敌人,BOSS落马起身及时踩踏;P2,躲好DZ的\"毒药瓶\"ZS的\"旋风斩\",打断萨满治疗术,法师急速BUFF及时偷取或驱散。"},
			{name = "银色神官帕尔崔丝", model = 29490, raiders = "\"忏悔\"之后转火召唤的回忆幻象,打断或驱散\"神圣之火\",偷取或驱散BOSS与回忆幻象身上的\"恢复\"。"},
			{name = "纯洁者耶德瑞克", model = 29616, raiders = "当使用\"光辉\"技能时背对BOSS防止致盲,BOSS使用\"正义之锤\"时及时驱散BOSS目标身上的\"制裁之锤\"。"},
			{name = "黑骑士", model = 29837, raiders = "驱散T的疾病,加好\"缓刑\",躲好食尸鬼爆炸;P2,驱散T的疾病,跑开\"亵渎\"范围,躲好食尸鬼爆炸;P3,加好\"死亡印记\"目标,保持全队满血。"},
		},
		["乌特加德城堡"]	= {
			{name = "凯雷塞斯王子", model = 25338, raiders = "BOSS\"召唤骷髅\"出现时T拉好A掉,治疗加好中了\"冰之坟墓\"的人,DPS第一时间转火\"冰之坟墓\",闪现、冰箱、无敌、徽章可解除。"},
			{name = "建筑师斯卡瓦尔德&控制者达尔隆", model = 22194, raiders = "拉好控制者召唤的小怪,建筑师施放\"激怒\"时注意保命,加好被\"冲锋\"的人血,BOSS死后会复活但无法杀死,成功击杀另外一个以后获胜。"},
			{name = "劫掠者因格瓦尔", model = 26351, raiders = "BOSS释放\"恐怖咆哮\"的时候不要施法,T拉BOSS背对人群防止\"顺劈斩\"和\"黑暗打击\",P2阶段注意跑开暗影战斧的\"旋风斩\"范围。"},
		},
		["魔枢"]	= {
			{name = "阵营指挥官", model = 24352, raiders = "躲好BOSS的\"旋风斩\",加好被\"冲锋\"的目标,拉离其他未引到的小怪,防止BOSS\"群体恐惧\"冲进怪堆。"},
			{name = "大魔导师泰蕾丝塔", model = 24066, raiders = "远离中\"火焰炸弹\"的目标,BOSS施放\"重力之井\"用瞬发治疗和DPS,BOSS血量66%和33%会使用\"分身\",躲好冰分身的\"暴风雪\",驱散奥分身\"变羊术\"。"},
			{name = "阿诺玛鲁斯", model = 26259, raiders = "BOSS血量降低到50%会\"裂隙充能\"并召唤\"混乱裂隙\",转火\"混乱裂隙\",注意加好中\"奥术吸引\"的目标以及全队的血。"},
			{name = "塑树者奥莫洛克", model = 26298, raiders = "BOSS施放\"法术反射\"所有法系停手,跑好\"水晶尖刺\",秒掉BOSS召唤的\"小花\"防止被定身,BOSS血量20%会\"激怒\",T开技能保命。"},
			{name = "克莉斯塔萨", model = 24307, raiders = "DPS不要站龙头和龙尾防止\"扫尾\"和\"水晶喷吐\",\"极度寒冷\"DEBUFF会无限叠加通过跳跃和移动人物来及时解除,\"冻结\"后及时驱散,血量20%以下\"激怒\"所有人开技能保命。"},
		},
		["艾卓-尼鲁布"]	= {
			{name = "看门者克里克希尔", model = 27394, raiders = "3位守护者,优先击杀法系怪,BOSS战加好当前T的血,驱散\"疲劳诅咒\",BOSS召唤小虫治疗尽量向T靠拢方便群拉,10%血BOSS\"激怒\"开技能自保。"},
			{name = "哈多诺克斯", model = 26776, raiders = "及时跑开\"毒云\",第一时间驱散\"吸血毒药\"并且在DEBUFF持续期间别死人,BOSS使用\"穿刺护甲\"治疗注意加好T,T开技能保命。"},
			{name = "阿努巴拉克", model = 27856, raiders = "\"虫群风暴\"期间加好全队和T血,别站BOSS面前防止被\"猛击\"秒,BOSS每减少25%血会下地,T注意拉好精英小怪,小心地面突起的白刺,可以提前躲开。"},
		},
		["安卡赫特：古代王国"]	= {
			{name = "纳多克斯长老", model = 27407, raiders = "驱散\"巢穴热疫\"疾病,T群拉好BOSS召唤的小虫,BOSS每减少25%血量召唤\"安卡哈尔守护者\",迅速转火守护者,治疗自己保命。"},
			{name = "塔达拉姆王子", model = 27406, raiders = "召唤\"火焰之球\"所有人尽量站分散减少治疗压力,BOSS每减少25%血量会对某一玩家使用\"吸血鬼拥抱\",无法治疗但可以套盾,所有人打BOSS4W血以后停止。"},
			{name = "埃曼尼塔(英雄模式)", model = 28133, raiders = "T靠墙拉BOSS以防被击飞,注意解毒、解魔法,BOSS施放\"迷你\"所有人靠近健康的蘑菇并打掉以解DEBUFF,所有人禁止释放AOE技能。"},
			{name = "耶戈达·觅影者", model = 26777, raiders = "近战注意躲避\"飓风打击\",迅速跑开\"雷霆震击\"范围,BOSS每减少25%血量会升空召唤\"暮光志愿者\",转火志愿者,若没杀掉T注意开技能。"},
			{name = "传令官沃拉兹", model = 27408, raiders = "加好\"暗影箭雨\"造成的伤害,BOSS每减少33%血会使用\"疯狂\",所有人优先击杀治疗者化身,输出低的注意保命等别人帮杀,打断职业注意打断鞭笞。"},
		},
		["达克萨隆要塞"]	= {
			{name = "托尔戈", model = 26352, raiders = "分散站位,小怪死了T把BOSS拉开以防尸爆,注意及时驱散\"感染之伤\"。"},
			{name = "召唤者诺沃斯", model = 26292, raiders = "迅速清理小怪,优先击杀法系怪,解除\"痛苦之怒\"诅咒效果,及时躲开\"暴风雪\"范围。打断寒冰箭,治疗注意团血。"},
			{name = "暴龙之王爵德", model = 5240, raiders = "尽量驱散\"低吼咆哮\",T中了\"穿刺猛击\"注意开技能保命,治疗给中\"悲惨撕咬\"的人抬满血,BOSS召唤小龙T注意拉住不让小龙打治疗,看见提示\"爵德阴险的举起爪子\"时T注意保命。"},
			{name = "先知萨隆亚", model = 27072, raiders = "驱散\"生命诅咒\"效果,及时躲开\"毒云\",骷髅阶段T用\"嘲讽\"+\"白骨护盾\"技能(2、3技能),其他人用\"杀戮打击\"+\"生命之触\"技能(1、4技能)输出。"},
		},
		["紫罗兰监狱"]	= {
			{name = "埃雷克姆", model = 27488, raiders = "驱散或偷取\"嗜血\"和\"闪电护盾\",打断\"治疗链\",优先击杀BOSS不需要杀随从。"},
			{name = "拉文索尔", model = 10193,raiders = "离开\"熔岩灼烧\"范围,请勿站BOSS正面防止被\"火焰吐息\"造成伤害,全力击杀BOSS防止\"灼热之焰\"堆叠太高。"},
			{name = "湮灭者祖拉玛特", model = 27855, raiders = "中了\"虚空变换\"的人优先寻找\"虚空斥候\"击杀,其他人全力击杀BOSS防止\"黑暗之影\"堆叠太高。"},
			{name = "谢沃兹",  model = 27486, raiders = "所有人远离\"虚灵之球\"防止被传送并增加BOSS伤害,T也需要拉BOSS远离\"虚灵之球\",驱散\"奥术易伤\"DEBUFF。"},
			{name = "艾库隆", model = 27487, raiders = "迅速打破\"水之护盾\",快速击杀\"艾库隆水滴\"或开启墙上的红色水晶防御结界击杀,防止水滴与BOSS融合。"},
			{name = "摩拉格", model = 20590, raiders = "\"腐蚀粘液\"堆叠太多层T开保命技能,治疗加好中\"注视之光\"的人。"},
			{name = "塞安妮苟萨", model = 27508, raiders = "除T以外所有人不要站龙头和龙尾防止\"无法控制的能量\"和\"扫尾\",驱散\"无法控制的能量\"的DOT和\"魔法破坏\"DEBUFF,跑开\"暴风雪\"范围,\"奥术真空\"后DPS等T上仇恨再输出。"},
		},
		["古达克"]	= {
			{name = "斯拉德兰", model = 27422, raiders = "T中了\"强力撕咬\"注意开保命技能,近战注意躲开\"剧毒新星\"15码AOE范围,BOSS召唤小蛇迅速击杀。"},
			{name = "达卡莱巨像",model = 26589, raiders = "BOSS血量下降50%会分裂成为\"达卡莱元素\",注意躲开元素的\"粘液堆\"范围,BOSS合体时施放\"涌动\"的时候躲开正面冲锋路径。"},
			{name = "莫拉比", model = 27059, raiders = "BOSS释放\"地震\"时注意治疗,在\"震耳咆哮\"技能时,治疗注意预读T,BOSS施放\"变身\"尽量打断。"},
			{name = "凶残的伊克(英雄模式)", model = 26644, raiders = "所有人不要站BOSS正面防止被\"喷吐\",BOSS跳跃以后所有人停手等T建立仇恨,全力输出防止90秒后BOSS\"狂暴\"。"},
			{name = "迦尔达拉", model = 27061, raiders = "注意躲开\"旋风斩\"AOE范围,BOSS变身犀牛后加好被\"穿刺\"的人,\"雷霆一击\"和\"犀牛冲撞\"技能时注意自保和治疗。"},
		},
		["岩石大厅"]	= {
			{name = "克莱斯塔卢斯", model = 20909, raiders = "治疗加好\"践踏\",BOSS\"大地碎裂\"击飞后施放\"碎裂\"时所有人保持距离15码防止距离过近被误伤秒杀。"},
			{name = "悲伤圣女", model = 26657, raiders = "驱散\"悲伤之柱\"DOT,所有人躲开\"悲伤风暴\"的范围,BOSS施放\"心碎\"时治疗先给T加满HOT防止被忏悔后治疗真空,T注意开保命技能。"},
			{name = "远古法庭", model = 169, raiders = "全程T拉好小怪,P2阶段驱散职业注意驱散中了黑球DEBUFF的人,P3阶段注意跑开\"凝视光线\"AOE范围。"},
			{name = "塑铁者斯约尼尔", model = 27483, raiders = "中了\"静电充能\"的人要远离队友,BOSS施放\"闪电之环\"的时候所有人跑开防止DEBUFF叠的过多被秒,BOSS30%血量后施放\"狂乱\"治疗加好T,T注意开保命技能。"},
		},
		["净化斯坦索姆"]	= {
			{name = "肉钩", model = 26579, raiders = "法系与治疗尽量远离BOSS避免被\"疾病驱逐\"沉默,治疗加好中了\"收缩之链\"的人,如治疗中则T开保命技能。"},
			{name = "塑血者沙尔拉姆", model = 26581, raiders = "解除\"扭曲血肉诅咒\"DEBUFF,第一时间击杀召唤的\"食尸鬼\"防止\"食尸鬼爆炸\"造成AOE伤害。"},
			{name = "时光领主埃博克", model = 26580, raiders = "解除\"消耗诅咒\"DEBUFF,所有人靠近BOSS输出防止BOSS\"时间扭曲\"后随机冲锋秒人。"},
			{name = "永恒腐蚀者(英雄模式)", model = 19326, raiders = "治疗全力加好\"腐蚀瘟疫\"的目标掉血每3秒8%的血量,T拉BOSS背对人群防止\"虚空打击\"对队友造成伤害。"},
			{name = "玛尔加尼斯", model = 26582, raiders = "驱散BOSS自己的\"吸血鬼之触\"BUFF,驱散中\"睡眠\"DEBUFF的人,T拉BOSS背对人群,队友分散站开防止\"腐臭蜂群\"造成AOE伤害。"},
		},
		["黑石岩窟"]	= {
			{name = "摧骨者罗姆欧格", model = 33147, raiders = "开boss前清光附近小怪,否则附近的小怪会被boss喊过来add,被\"苦痛之链\"锁住后第一时间打掉锁链,所有人远离boss避免旋风斩,Boss召唤出的小怪由T拉住让boss自己旋风斩劈死即可。"},
			{name = "柯尔拉，暮光之兆", model = 31546, raiders = "分三个人挡三道光线,身上的debuff叠到70~80层时离开光线(暗影斗篷、无敌、披风可解除),debuff一消失继续去挡,一定要打断BOSS的恐惧技能。"},
			{name = "卡尔什·断钢", model = 31710, raiders = "让boss靠近中间的火,boss每获得一层debuff,受到的伤害增加,同时也会释放一次AOE。掌握好时间及层数,最好保持boss身上debuff不要断。"},
			{name = "如花", model = 34433, raiders = "注意及时解除恐惧,普通模式小狗和boss仇恨不连接,可以先杀小狗再BOSS,不用全杀(小狗全死后BOSS会狂暴)。"},
			{name = "升腾者领主奥西迪斯", model = 36465, raiders = "T只拉BOSS,其他一人风筝小怪,每隔一段时间BOSS会和影子换位并清空仇恨,注意第一时间控制好目标仇恨。"},
		},
		["旋云之巅"]	= {
			{name = "大宰相埃尔坦", model = 35181, raiders = "开战后外围会出现旋风,站在旋风和boss之间输出,当旋风向BOSS聚拢时近战离开,全程注意保持和旋风的距离,碰到旋风攻击速度会减少很多。"},
			{name = "阿尔泰鲁斯", model = 34265, raiders = "看场上风向,处在逆风位置时穿过BOSS一下,尽量保持顺风,躲好Boss释放的龙息及地上的旋风。"},
			{name = "阿萨德", model = 35388, raiders = "平时分散站位,避免闪电链穿多人,第一时间驱散\"静滞之握\"(跳跃也可闪开),boss召唤法阵后全都站在法阵内,不然会被A死。"},
		},
		["潮汐王座"]	= {
			{name = "纳兹夏尔女士", model = 34342, raiders = "分散站位,避免致命孢子影响队友,躲好脚下的喷泉,第一时间打断\"震爆\",小怪阶段控制2个法系怪,杀近战,躲好旋风。"},
			{name = "指挥官乌尔索克", model = 33792, raiders = "T拉着BOSS绕屋子走,躲开BOSS砸地,不要待在黑圈里,加好被抓住的人,狂怒时注意T血。"},
			{name = "蛊心魔古厄夏", model = 32259, raiders = "P1阶段T把boss背对人群,尽量打断施法读条并注意躲开地刺,p2阶段注意躲开绿色迷雾输出,出保护罩后法系dps停手(可偷,可驱散),黑色连线时治疗注意团血。"},
			{name = "厄祖玛特", model = 32911, raiders = "P1阶段近战注意恐兽跳起后远离并躲开黑水,p2阶段t风筝血肉DPS击杀工兵,不要长时间站在黑水里,p3阶段全力输出BOSS。"},
		},
		["巨石之核"]	= {
			{name = "克伯鲁斯", model = 33477, raiders = "地上阶段远离地上的红水晶并第一时间打掉,地下阶段t拉住小怪,所有人第一时间躲开地上的烟雾。"},
			{name = "岩皮", model = 36476, raiders = "躲好地上的岩浆圈,Boss在地面全屏Aoe躲在柱子后面卡视角,近战注意,不能找boss红圈内的石柱躲,否则照样挨打,空中阶段不要被落下来的石柱砸到。"},
			{name = "欧泽鲁克", model = 36475, raiders = "T拉好BOSS背离人群,BOSS抬腿放地刺的瞬间往BOSS背后跑。BOSS放昏迷前所有人用技能打一下BOSS获得流血DOT来解除昏迷,当提示\"感受大地之力\"时,迅速远离BOSS。"},
			{name = "高阶女祭司艾苏尔", model = 26448, raiders = "地上出什么躲什么(出烟不躲瞬死),及时打断BOSS的\"原力之握\",将跑过来得信徒都引入重力之井会直接秒杀。"},
		},
		["格瑞姆巴托"]	= {
			{name = "乌比斯将军", model = 31498, raiders = "T把BOSS拉至背对人群,治疗注意刷掉坦克身上的流血效果。小怪杀掉,注意英雄模式紫色小怪控制好不要杀。BOSS盯人冲锋时要及时避开。"},
			{name = "铸炉之主索郎格斯", model = 33429,  raiders = "三种随机形态:盾形态时全体站BOSS身后输出,注意及时调整位置;剑形态时治疗加好,原地输出(可缴械);锤形态时风筝BOSS,躲开地上的火焰。"},
			{name = "达加·燃影者", model = 31792, raiders = "被火元素连线的人迅速远离火元素,同时所有DPS集火秒掉火元素。龙下来后,提前跑到BOSS的背后,不要被火喷到,不要站光圈里。"},
			{name = "埃鲁达克", model = 33428, raiders = "BOSS对人放黑影时立即跑开,门口刷小怪时,分配好减速人员,必须在小怪跑进来开蛋之前击杀两个小怪。BOSS放暗影强风时,所有人躲到漩涡中间。"},
		},
		["托维尔失落之城"]	= {
			{name = "胡辛姆将军", model = 34743, raiders = "坦克尽量把BOSS往一边拉,保证有地方没地雷。躲地雷,躲光圈,记得躲远一些,地雷爆炸范围大约8码。"},
			{name = "锁喉", model = 33438, raiders = "近战站鳄鱼侧面输出,杀完鳄鱼速度恢复。躲好旋风斩,能AOE的帮忙AOE小鳄鱼,中标记的注意自保,驱散好毒。"},
			{name = "高阶预言者巴林姆", model = 34744, raiders = "P1躲开光柱,风筝火凤凰,治疗驱散瘟疫。P2速度Rush黑凤凰,灵魂碎片出现后,坦克将黑暗凤凰拉开,避免融合,灵魂碎片可以减速。"},
			{name = "希亚玛特", model = 35231, raiders = "P1杀好小怪,优先打远程小怪,躲开地上的云;P2技能全开狠打。"},
		},
		["死亡矿井"]	= {
			{name = "格拉布托克", model = 37410, raiders = "P1无脑输出,注意boss有时会清仇恨注意嘲讽,p2阶段躲好火墙,坦克拉小怪,其他人全力打BOSS。"},
			{name = "赫利克斯·破甲", model = 33002, raiders = "中间的轨道不要站人,中炸弹的远离人群,躲开地上的炸弹。"},
			{name = "死神5000", model = 35606, raiders = "一个近战去下面开伐木机,用技能杀死火炉中出的火元素,千万不要让火元素上来。其他人在上面通道打BOSS,躲开BOSS的旋转爪子挠人,不躲必死！"},
			{name = "撕心狼将军", model = 35739, raiders = "出小怪优先杀小怪,最后一次出三个小怪的时候可直接rush boss。"},
			{name = "\"队长\"曲奇", model = 1305, raiders = "BOSS无仇恨,点地上的食物,躲开绿全力输出,坏食物的debuff可以用好食物消除。"},
			{name = "梵妮莎·范克里夫", model = 32806, raiders = "闯关阶段：躲好地上的火,天上的冰,死了释放跑本。BOSS战：打好小怪,BOSS烧船时,点船旁边的绳子逃避爆炸。"},
		},
		["影牙城堡"]	= {
			{name = "灰葬男爵", model = 34610, raiders = "P1分配一人打断痛苦与折磨,窒息术所有人空血后,注意要让BOSS的死亡缓刑爆1到2下再打断,p2黑暗大天使时全力输出。"},
			{name = "席瓦莱恩男爵", model = 37288, raiders = "坦克拉好,集火杀BOSS召唤的狼人,治疗注意驱散诅咒。"},
			{name = "指挥官斯普林瓦尔", model = 37287, raiders = "优先击杀小怪,躲好Boss喷火,不要站在绿圈里,小怪的邪恶活化尽量打断。"},
			{name = "瓦尔登勋爵", model = 34612, raiders = "分散站位,地上出什么躲什么,boss喷绿毒时要保持移动或原地跳,喷红色毒的时候不能移动并全力输出。"},
			{name = "高弗雷勋爵", model = 34611, raiders = "远程治疗站在台子上面,近战和坦克在台子下面攻击,boss召唤食尸鬼时坦克注意拉住,中debuff的即时解,否则必死,漫天弹幕坦克近战注意跑向boss背面输出。"},
		},
		["起源大厅"]	= {
			{name = "神殿守护者安努尔", model = 35067, raiders = "地上出什么躲什么,BOSS无敌时,双人下台阶,一人引蛇一人开机关,注意脚底下的蓝火。"},
			{name = "地怒者塔赫", model = 31450, raiders = "坦克拉BOSS背对人群,其他人不要站正面,躲开地上的土圈,远程上骆驼可以移动施法,但宠物会消失。"},
			{name = "安拉斐特", model = 34580 , raiders = "第一时间躲开boss施放到地上的黑圈,全力输出,英雄模式下黑圈会一直存在,T注意把boss拉到没有黑圈的地方。"},
			{name = "伊希斯特", model = 33465, raiders = "出小怪近战帮助打一下,boss放闪光弹注意背对,boss分身只需集火打掉一个即可。"},
			{name = "阿穆纳伊", model = 32943, raiders = "驱散好\"枯萎\",出小怪打小怪,无脑输出。"},
			{name = "塞特斯", model = 33055, raiders = "BOSS无仇恨,普通模式不用管小怪,无脑输出boss,英雄模式注意第一时间打掉传送门,坦克风筝小怪,dps输出boss和传送门,第三个传送门后可以全力rush boss。"},
			{name = "拉夏", model = 33177, raiders = "注意打断,BOSS所有技能读条都可以打断,地上出什么躲什么,太阳祝福时所有技能全开rush Boss。"},
		},
		["祖尔格拉布"]	= {
			{name = "小怪攻略", model = 37973, raiders = "冰锅:下一次攻击冰冻并减少目标80%生命值(BOSS无效);火锅:山寨版自焚;毒锅:减免自然伤害90%。"},
			{name = "高阶祭司温诺西斯", model = 15217, raiders = "打断\"赫希斯的低语\",连线玩家速度相互跑开,全程躲开地面绿线和毒圈,75%变身后躲开BOSS正面,50%上台,躲好绿线追踪。"},
			{name = "血领主曼多基尔", model = 11288, raiders = "第一时间急火奥根,冲锋必死(大天使点掉)等NPC救即可,注意脚下扇形AOE伤害技能。"},
			{name = "格里雷克", model = 8390, raiders = "被追逐玩家风筝BOSS,躲开脚下地动波。"},
			{name = "哈扎拉尔", model = 15267, raiders = "打断\"愤怒\",远离房间边缘,出梦魇时没定身玩家速秒小怪解救4位队员。"},
			{name = "乌苏雷", model = 15269, raiders = "BOSS背对人群,躲开闪电云,注意分散躲避闪电棒。"},
			{name = "雷纳塔基", model = 37830, raiders = "加好被伏击的玩家,躲开刀扇路线。"},
			{name = "高阶祭司基尔娜拉", model = 37805, raiders = "带着BOSS清掉小豹子再输出BOSS,BOSS50%血之前要清光小豹子,注意打断引导技能,躲好风墙。"},
			{name = "赞吉尔", model = 37813, raiders = "躲开BOSS正面火线,BOSS召唤大个,被点的跑,DPS(远程吃冰锅)急火;召唤僵尸,坦克吃火,DPS打掉;全屏毒伤,全员吃绿锅。"},
			{name = "碎神者金度", model = 37789, raiders = "清两侧小怪再开BOSS,将BOSS拉出绿罩,哈卡阴影时全员进绿罩,P2阶段出现三条锁链,T拉台下大个,被大个点名站在紫色圈附近就能打破紫圈,然后跑开集急火锁链,3条都清;清掉灵魂并躲脚下火圈。"},
		},
		["祖阿曼"]	= {
			{name = "埃基尔松", model = 21630, raiders = "当白鸟抓住玩家时速度打掉白鸟,分散站位,boss即将释放闪电技能所有人集中在BOSS脚下,结束再分散,木桩BOSS。"},
			{name = "纳洛拉克", model = 21631, raiders = "人形态会冲锋最外圈玩家,并受到物理伤害提高500%DEBUF,三个玩家轮流去最外圈,避免同一玩家被冲锋两次,熊形态木桩,注意熊会群体沉默。"},
			{name = "加亚莱", model = 21633, raiders = "躲开BOSS喷火,只杀掉一边巨魔小怪,龙鹰吃一切控制技能,出现速度清掉;当BOSS释放炸弹技能时躲开炸弹。"},
			{name = "哈尔拉兹", model = 21632, raiders = "P1时BOSS会释放治疗图腾,坦第一时间拉出绿圈即可,留下少量图腾可以恢复玩家生命;P2时治疗加好被豹子急火的目标,闪电图腾第一时间打掉,反复几次即可。"},
			{name = "妖术领主玛拉卡斯", model = 22332, raiders = "先杀小怪,BOSS随机会对一名玩家释放灵魂虹吸,期间可使用该职业的技能,技能可打断,结束后BOSS会释放AOE技能,治疗注意群补。"},
			{name = "达卡拉", model = 38118, raiders = "P1:躲旋风斩,加好重伤;P2随机2种形态,熊:冲锋最远目标,除T外轮流吃,优先驱散T麻痹;山鹰:施法会受伤害,优先打图腾,躲好风;龙鹰:躲好火圈和火柱;猫:速度杀小豹子,被点名开技能自保T可嘲讽。"},
		},
		["时光之末"]	= {
			{name = "贝恩的残影", model = 38791, raiders = "远程治疗可分散台子站位,避免集体落水,但注意保持治疗距离;坦克/治疗落水后容易倒坦,注意开大招保命;DPS可捡BOSS投掷过来的图腾然后扔BOSS。"},
			{name = "吉安娜的残影", model = 38802, raiders = "收集16个碎片后吉安娜才会出现,DPS打断寒冰箭,躲避寒冰之刃;BOSS丢光核后,靠近的人立刻去踩;开打前清完附近小怪,吉安娜闪现很远容易引到。"},
			{name = "希尔瓦娜斯的残影", model = 39559, raiders = "注意躲好地上的紫色毒区;包围圈出现后不要跑出圈,集中击杀一个食尸鬼,然后从它背后的路跑出。"},
			{name = "泰兰德的残影", model = 39617, raiders = "小怪需拉到光柱中才能击杀;躲好月影枪;DPS注意打断\"星尘\"施法技能;30%血后注意躲天上掉下来的艾露恩之泪。"},
			{name = "姆诺兹多", model = 38931, raiders = "点地图中央的大沙漏能重置技能CD及复活;战斗开始嗜血等大招不要保留;躲避地上炸弹,坦克拉BOSS背对人群,注意挪动BOSS给DPS留出站位。"},
		},
		["暮光审判"]	= {
			{name = "阿奎里恩", model = 39397, raiders = "打掉萨尔冰墓可解放他;注意躲避天上掉下来的巨石(落下前地上出现蓝圈);BOSS血量30%后,开所有大技能尽全力输出。"},
			{name = "埃希拉?黎明克星", model = 38995, raiders = "BOSS施放烟雾弹后,坦克迅速将BOSS拉出烟雾弹的范围;dps和治疗尽量在图腾范围内站位;治疗和远程DPS躲在坦克身后就不会被飞刀沉默。"},
			{name = "大主教本尼迪塔斯", model = 38991, raiders = "沿途小怪优先杀眼球;注意躲避地上的净化圣光和腐败暮光,跑到萨满放的水盾后面可躲避BOSS大招,还能增加攻击伤害。"},
		},
		["永恒之井"]	= {
			{name = "佩罗萨恩", model = 39182, raiders = "躲地上的火焰,玩家中了魔化腐朽后,治疗不要轻易刷血,否则会受到反伤;BOSS消失后,尽可能的躲避眼睛的追捕,BOSS抓到人坦克注意开技能;20%血量后注意BOSS狂暴。"},
			{name = "艾萨拉", model = 39391, raiders = "迅速击杀被激活的NPC,躲避地上的蓝色火焰,注意打断BOSS的大招。"},
			{name = "玛诺洛斯与瓦罗森", model = 38996, raiders = "T拉住瓦罗森和小怪即可,玛诺洛斯交给伊利丹;躲好地上的绿色火焰;击杀瓦罗森后捡起他的剑扔向玛诺洛斯,杀掉攻击泰兰德的削弱者,然后输出玛诺洛斯,坦克站传送门处拉好刷新的小怪。"},
		},
		["巨龙之魂"]	= {
			{name = "莫卓克", model = 39094,raiders = "人群靠近王的脚,红球出现往那儿跑;黑水石柱后藏好,反复三次王就倒。"},
			{name = "督军佐诺兹", model = 39138, raiders = "BOSS背对人群,全团分成近战远程两组相互撞球(近战BOSS脚下,远程BOSS背后20码),撞七次以后让王撞球;王开AOE的时候所有人集中站到BOSS脚下,反复三次王就挂。"},
			{name = "不眠的约萨希", model = 39101, raiders = "软泥出现后按照 紫>绿>红>蓝 的优先顺序击杀,打掉一个后集中到BOSS脚下;BOSS招啥打啥,有蓝色光球优先打。"},
			{name = "缚风者哈格拉", model = 39318, raiders = "BOSS集中攻击时坦克退后几步;冰阶段所有人都站到外圈,注意躲外圈顺时针移动的冰浪,打掉四个水晶;雷阶段所有人去外圈打掉小怪后绕着外围跑,让水晶传电。"},
			{name = "奥卓克希昂", model = 39009, raiders = "主坦中DEBUFF副坦嘲讽,DEBUFF倒计时还剩3-4秒再去点屏幕中央按钮消DEBUFF;BOSS放暮光之时就点屏幕中央按钮躲技能。"},
			{name = "战斗大师黑角", model = 39399, raiders = "远程优先打飞龙,坦克拉好近战怪,背对人群;地上黑圈要躲开,小怪冲锋和BOSS冲击波注意躲开,地上会有视觉效果。"},
			{name = "死亡之翼的背脊", model = 35268, raiders = "DPS看标记打触手,触手杀一个就行;触手打死后刷新的大怪血较低就停手,等其DEBUFF叠到9层拉到BOSS护甲边击杀,坦克跑回人群躲紧接着的爆炸;爆炸后肌腱一露出就全力轰,打掉三块看动画。"},
			{name = "死亡之翼的疯狂", model = 40087, raiders = "按照红>绿>黄>蓝的台子顺序战斗,先杀大触手再打爪子;刺穿时T注意点屏幕中央按钮或开大技能;刷新的小怪拉到黄圈内速清;注意速度转火点掉源质箭;P2站绿台子清掉一波大触手后全力RUSH。"},
		},
	}


local setModel = function(m,displayId)
	local defaultModel = "Interface\\Buttons\\talktomequestionmark.m2"
	local initModel = function(m)
		m:ClearModel()
		m:SetModel(defaultModel)
		m:SetPortraitZoom(0)
		m:SetCamDistanceScale(1)
		m:SetPosition(0,0,0)
		m:SetRotation(0)
	end
	if displayId then 
		initModel(m)
		m:SetDisplayInfo(displayId)
	else
		initModel(m)
	end
end
tacFunc.SetTip = function(t,m)
	local zone = GetZoneText()
	local flag = false
	for k in pairs(tactial) do
		if k == zone then 
			flag = true
		end
	end
	if not flag then
		print("|cffffff00[精灵副本攻略]:当前区域暂无副本攻略可供查询|r")
		t:Hide()
		m:Hide()
		return 
	end
	if flag then 
		local n = GetNumRaidMembers()
		local p = GetNumPartyMembers()
		local msgType = "say"
		if p > 0 and n == 0 then
			msgType = "party"
		elseif n > 0 then 
			msgType = "raid"
		elseif p == 0 and n == 0 then 
			msgType = "say"
		end

		for i = 1, #tactial[zone] do
			t.buttons[i].name:SetText(tactial[zone][i].name)
			t.buttons[i]:SetScript("OnClick",function(self,key)
				local title =	string.format("%s","魔兽精灵副本指南")
				local bossInfo = string.format("%s:%s",zone,tactial[zone][i].name)
				local bossTap = string.format("%s",tactial[zone][i].raiders)
				SendChatMessage(title,msgType)
				SendChatMessage(bossInfo,msgType)
				SendChatMessage(bossTap,msgType)
			end)
			t.buttons[i]:SetScript("OnEnter",function(self)
				t.buttons[i].name:SetTextColor(1,1,0,1)
				t.buttons[i].name:SetShadowColor(0,0,0,1)
				t.buttons[i].name:SetShadowOffset(2,-2)
				setModel(m,tactial[zone][i].model)
			end)
			t.buttons[i]:SetScript("OnLeave",function(self)
				t.buttons[i].name:SetTextColor(1,1,1,1)
				t.buttons[i].name:SetShadowColor(0,0,0,0)
				t.buttons[i].name:SetShadowOffset(0,0)
				setModel(m)
			end)
		end
	end
end

tacFunc.ClearTip = function(t,m)
	m:UnregisterAllEvents()
	m:ClearModel()
	for i = 1, #t.buttons do
		t.buttons[i]:SetScript("OnEnter",nil)
		t.buttons[i]:SetScript("OnLeave",nil)
		t.buttons[i]:SetScript("OnClick",nil)
		t.buttons[i].name:SetText("")
	end
end

ns.tactial = tactial
ns.tacFunc = tacFunc
