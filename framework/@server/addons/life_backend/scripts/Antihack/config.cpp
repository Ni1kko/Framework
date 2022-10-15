class CfgPatches 
{
    class Antihack 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Systems"};
        authors[] = {"Ni1kko"};
    };
};
 
class CfgAntiHack
{
    //--- logging
    rptlogs = 1;                //Log to RPT file
    conlogs = 1;                //Log to Console
    extlogs = 1;                //Log to Extension
    dblogs = 1;                 //Log to Database
    dblogtypes[] = {            //Types of logs to save to database (0 = disabled, 1 enabled)
        { "KICK",   1 },
        { "BAN",    1 },
        { "HACK",   1 },
        { "INFO",   1 }
    };

    //--- options
    checklanguage = 0;           //check for language                        Notes: (admin lvl 1 and above excluded)
    checknamebadchars = 1;       //check for bad chars in players names      Notes: (admin lvl 1 and above excluded, bad chars can break BattleEye, Database, and many more things in arma)
    checknameblacklist = 1;      //check for blacklisted profile name        Notes: (admin lvl 1 and above excluded)
    checkteleport = 1;           //check for teleportion hack                Notes: (admin lvl 1 and above excluded)
    checkrecoil = 1;             //check for weapon recoil hack              Notes: (admin lvl 1 and above excluded)
    checkgear = 1;               //check for bad gear                        Notes: (admin lvl 3 and above excluded)
    checkuniform = 1;            //check for bad uniform                     Notes: (admin lvl 3 and above excluded)
    checkheadgear = 1;           //check for bad headgear                    Notes: (admin lvl 3 and above excluded)
    checkgoggles = 1;            //check for bad goggles                     Notes: (admin lvl 3 and above excluded)
    checkvests = 1;              //check for bad vests                       Notes: (admin lvl 3 and above excluded)
    checkbackpacks = 1;          //check for bad backpacks                   Notes: (admin lvl 3 and above excluded)
    checkweapon = 1;             //check for bad weapons                     Notes: (admin lvl 3 and above excluded)
    checkweaponattachments = 1;  //check for bad weapons attachments         Notes: (admin lvl 3 and above excluded)
    checkspeed = 1;              //check for walking speed hack              Notes: (admin lvl 3 and above excluded)
    checkdamage = 1;             //check for god mode hack                   Notes: (admin lvl 3 and above excluded)
    checkHidden = 1;             //check for invisibilty hack                Notes: (admin lvl 3 and above excluded)
    checksway = 1;               //check for weapon sway hack                Notes: (admin lvl 3 and above excluded)
    checkmapEH = 1;              //check for added map event handlers        Notes: (admin lvl 3 and above excluded)
    checkterraingrid = 1;        //check for no grass hack                   Notes: (admin lvl 3 and above excluded)
    checkvehicle = 1;            //check for added vehicles                  Notes: (admin lvl 4 and above excluded)
    checkvehicleweapon = 1;      //check for added vehicle weapons           Notes: (admin lvl 5 and above excluded)
    checkmemoryhack = 1;         //check for memoryhacks                     Notes: (admin lvl 5 and above excluded)
    checkdetectedmenus = 1;      //check for known hack menus                Notes: (admin lvl 6 and above excluded)          
    checkdetectedvariables = 1;  //check for known hack variables            Notes: (admin lvl 7 and above excluded)   
    
    
    //--- Admins
    use_databaseadmins = 1;      // Get all admins LVL 1 to LVL 99 from DB
    use_debugconadmins = 0;      // Get all admins from descrption.ext

    //--- Misc
    use_interuptinfo = 1;        //Custom escape menu text
    serverlanguage = 'English';  //Language all clients must have, if (checklanguage = 1)
    
    //--- names that you dont want players to use
    nameblacklist[] = {
        "Admin","Administor"
    };

    //--- bad menu IDD array (IDD's found in this array will be auto closed)
    badmenus[] = {
        2,3,7,17,19,25,26,27,28,29,30,31,32,37,40,41,43,44,45,51,52,53,56,69,74,85,
        106,126,127,129,132,146,147,148,150,152,153,155,157,159,162,163,169,
        262,312,314,632,1320,2121
    };

    //--- hack menu IDD array (IDD's found in this array will ban that player with them)
    detectedmenus[] = {
        -1337,133,164,167,1340,1341,1342,1343,1344,1345,1346,1347
    };

    //--- bad variables
    detectedvariables[] = {
        "bis_fnc_dbg_reminder_value","bis_fnc_dbg_reminder","bis_menu_groupcommunication","bis_fnc_addcommmenuitem_menu","gtp", "rscspectator","rscspectator_hints","rscspectator_display","rscspectator_playericon","gunrestrain",
        "rscspectator_view","rscspectator_map","rscspectator_vision","rscspectator_keys","gspawnv", "rscspectator_interface","gmoney","gkillall","time","servertime","myplayeruid","hhahaaaaar","charliesheenkeybinds","kickoff",
        "yolo","runonce","notakeybind","action1","supa_licenses","autokick","wallaisseikun","mainmenu","anarray","gefclose","gefwhite","gefred","gefgreen","gefcyan","firsthint","new_queued","fn_exec","fnd_fnc_select","fnx3",
        "antihackkick","tele","dmap","goldens_global_shit_yeah","glass911_run","geardialog_create","lystokeypress","thirtysix","ly_swaggerlikeus","jkeyszz","n2","boxofmagic","mainscripts","dmc_fnc_4danews","infistarbypass","exec_text","vehicle_dblclick","init_main",
        "esp_count","nute_dat_bomber","s_cash100k","xposplayer","ly_re_onetime","skar_checka","mainscriptsv4","viewdistance","check_load","already_load","meins","f1","dummy","plane_jump",
        "c_player","mouseclickeh","distp","nec2","menu_i_run_color_lp","glassv1nce_bindhandler","thecar","fastanimes","getinpassenger","iaimon","dmc_re_onetime","func_execonserver","fnc_serverkicknice",
        "kick_admins","dasmokeon","hovering","r_kelly_be_flying","slx_xeh_bwc_init_compile","vincelol_altislife","life_fnc_byassskaroah","ah_fnc_mp","jayre","fn_newsbanner","hack_news","trollfuncs",
        "fanatic_infipass","keybindings_xxx","andysclosed","userfuncs","altisfuncs","remexe","bb_nofatigue","bis_fnc_diagkey_var_code","first_page","get_in_d","i_t_s__m_e_o","smissles","whippy_esp",
        "targetfuncs2","life_fnc_antifreeeeze","ly_keyforward","ty_re_onetime","life_fnc_xaaxaa","mein1","goddamnvehiclesxd","mystic_fnc_esp_distance","esp_id_setter","dummymen","whipbut","userfuncs",
        "krohdofreedom","selectedplayer","lmenu1","ggplayer","throx_menu_item","lvl1","init_menu_slew","d_b_r_t_y_slew","v6_gef","xasfjisisafudmmyx","kekse","updated_re_36","first","second","paradox_s3tc4sh",
        "checkchatloop","bringmeup","finie_s_p","fnc_infiAdminKeyDown","jay_vehicle_list","shit","whsh506_m41n","finifeaturesformatted","nigger_init","bmcloos","exile_slayexiles",
        "buttons","opnmemeu","firstload","nss_ac_openvvs","nss_ac_openvas","nss_ac_setcaptive","nss_ac_invisible","nss_ac_mapteleport","nss_ac_opencode","nss_ac_freecam","nss_ac_godmode","nss_ac_execscript",
        "nss_ac_openspectator","menuinit","realscripts","targetplr","MLRN_RE","Running","RE","arsenalOpened","BIS_fnc_arsenal_fullArsenal","n912","TBMKnlist","PLAY","ALTISLIFENEXT3","SOMEONE_dsfnsjf",
        "FND_fnc_subs","setcash","Dummy_Ghost","entf","check_loaded","LY_Menu","AndysClosed","GOLDENS_GLOBAL_SHIT_YEAH","Fanatic_Main_Bereich","imgoingnukeyou","fnc_usec_damageHandler","CheatCurator","andy_loopz","InitFileOne","Status_BB","TZ_BB_A3","TZ_BB_KB_Hint","TZ_BB_BindHandler","AH_BRAZZERS_TZ_BB","kamakazi_lystic","fuckfest","LYSTIC_MENU_LOADED","D_AMEZ_COA",
        "Intro","Repair","Heal","T3le","TNK","I_like_turtles","BIGM","GMod","E3p","Does_Tonic_Like_to_take_Turtle_penis_in_the_ass_LODESTARS","lel","vars","PSwap","toLower_new","BCast","thfile","tlmadminrq","infiSTARBLACK","carepkg","scrollAim","BlurExec","sbpc","CALLRE",
        "menu_run","ZedProtect","actid1","vehicles1","MapClicked","MapClickedPosX","MouseUpEvent","scrollPlayerlist","keypress_xxx","D_AMEZ_COA","envi","G_A_N_G_S_T_A","ZoombiesCar","timebypass","returnString_z","isori","tangrowth27","PVAH_AdminRequest","AH_OFF_LOL","infiSTAR_fillRE",
        "qwak","infoe","font","title_dialog","sexymenu_adds_Star","boolean_1","initre337","skype_option","bleh","magnetomortal","fnc_allunits","sbp","PV_IAdminMenuCode","PVAH_WriteLogRequest","skype_img","Lhacks","Lpic","LtToTheRacker","Lexstr","take1","Called","epochExec","sdgff4535hfgvcxghn",
        "adadawer24_1337","fsdddInfectLOL","W_O_O_K_I_E_Car_RE","kW_O_O_K_I_E_Go_Fast","epchDeleted","lystobindkeys","lystoKeypress","fnc_usec_unconscious","toggle_1","shiftMenu","dbClicked","b_loop","re_loop","v_bowen","bowen","melee_startAttack","asdasdasd","antihax2","PV_AdminMenuCode","AdminLoadOK",
        "AdminLoadOKAY","PV_TMPBAN","T_o_g_g_l_e_BB","fixMenu","PV_AdminMenuCodee","AdminPlayer","PVAH_AdminRequestVariable","epochBackpack","JME_Red","JME_MENU_Sub","JME_menu_title","JME_Sub","JME_OPTIONS","god","heal","grass","fatguybeingchasedbyalion","night","day","infammo","nvg","thermal",
        "Keybinds","fredtargetkill","loopfredtpyoutome","epochTp","AdminLst","BB_Pr0_Esp","BBProEsp","epochMapMP","CALLRESVR","EPOCH_spawnVehicle_PVS","adminlite","adminlitez","antihacklite","inSub","scroll_m_init_star","markerCount","zombies","startmenu_star","LystoDone","MOD_EPOCH",
        "Admin_Lite_Menu","admingod","adminESPicons","fnc_MapIcons_infiSTAR","BIS_MPF_remoteExecutionServer4","adminadd","shnext","infiSTAR_fill_Weapons","adminZedshld","adminAntiAggro","admin_vehicleboost","admin_low_terrain","admin_debug","admincrate","exstr","nlist","PV_AdminMainCode","TPCOUNTER","PVDZ_Hangender",
        "lalf","toggle","iammox","telep","dayzlogin3","dayzlogin4","changeBITCHinstantly","antiAggro_zeds","BigFuckinBullets","abcdefGEH","adminicons","fn_esp","aW5maVNUQVI_re_1","passcheck","isInSub","qodmotmizngoasdommy","ozpswhyx","xdistance","wiglegsuckscock","diz_is_real__i_n_f_i_S_T_A_R",
        "pic","veh","unitList","list_wrecked","addgun","ESP","BIS_fnc_3dCredits_n","dayzforce_save","ViLayer","blackhawk_sex","activeITEMlist","items1","adgnafgnasfnadfgnafgn","Metallica_infiSTAR_hax_toggled","activeITEMlistanzahl","xyzaa","iBeFlying","rem","DAYZ_CA1_Lollipops","HMDIR","vehC","HDIR","carg0d",
        "fffffffffff","markPos","pos","TentS","VL","MV","monky","qopfkqpofqk","monkytp","pbx","nametagThread","spawnmenu","sceptile15","sandshrew","mk2","fuckmegrandma","mehatingjews","TTT5OptionNR","zombieDistanceScreen","cargodz","R3m0te_RATSifni","wepmenu","admin_d0","RAINBOWREMEXECVEH",
        "omgwtfbbq","namePlayer","thingtoattachto","HaxSmokeOn","testIndex","g0d","spawnvehicles_star","kill_all_star","sCode","dklilawedve","peter_so_fly_CUS","selecteditem","moptions","delaymenu","gluemenu","g0dmode","cargod","infiSTAR_fillHax","itemmenu","gmadmin","fapEsp","mapclick","VAGINA_secret",
        "spawnweapons1","abcd","skinmenu","playericons","changebackpack","keymenu","godall","theKeyControl","infiSTAR_FILLPLAYER","whitelist","pfEpochTele","custom_clothing","img","surrmenu","footSpeedIndex","ctrl_onKeyDown","plrshldblcklst","DEV_ConsoleOpen","executeglobal","cursoresp","Asdf","planeGroup",
        "teepee","spwnwpn","musekeys","dontAddToTheArray","morphtoanimals","aesp","LOKI_GUI_Key_Color","Monky_initMenu","tMenu","recon","curPos","playerDistanceScreen","ihatelife","debugConsoleIndex","MY_KEYDOWN_FNC","pathtoscrdir","Bowen_RANDSTR","ProDayz","idonteven","walrein820","RandomEx",
        "TAG_onKeyDown","changestats","derp123","heel","rangelol","unitsmenu","xZombieBait","plrshldblckls","ARGT_JUMP_s","ARGT_JUMP_d","globalplaya","ALL_MAGS_TO_SEARCH","helpmenu","godlol","rustlinginit","qofjqpofq","invall","initarr","reinit","byebyezombies","admin_toggled","fn_ProcessDiaryLink","ALexc","DAYZ_CREATEVEHICLE",
        "shnmenu","xtags","pm","lmzsjgnas","vm","bowonkys","glueallnigga","hotkeymenu","Monky_hax_toggled","espfnc","playeresp","zany","dfgjafafsafccccasd","atext","boost","nd","vspeed","Ug8YtyGyvguGF","inv","rspwn","pList","loldami","T","bowonky","aimbott","Admin_Layout","markeresp","allMrk","MakeRandomSpace",
        "Monky_funcs_inited","FUK_da_target","damihakeplz","damikeyz_veryhawt","mapopt","hangender","slag","jizz","kkk","ebay_har","sceptile279","TargetPlayer","tell_me_more_infiSTAR","airborne_spawn_vehicle_infiSTAR","sxy_list_stored","advert_SSH","antiantiantiantih4x","Flare8","Flare7","SuperAdmin_MENU",
        "bl4ck1ist","keybinds","actualunit","mark_player","unitList_vec","yo2","actualunit_vec","typeVec","mark","r_menu","hfghfg","vhnlist","work","Intro","cTargetPos","cpbLoops","cpLoopsDelay","Flare","Flare1","Flare2","Flare3","Flare4","Flare5","Flare6","kanghaskhan","palkia",
        "eExec_commmand","cockasdashdioh","fsdandposanpsdaon","antiloop","anti","spawn_explosion_target_ebay","whatisthis4","ratingloop_star","epochRemoteNukeAll","sandslash","muk","pidgeotto","charmeleon","pidgey","lapras","LYST1C_UB3R_L33T_Item","MathItem","fapLayer","cooldown",
        "raichu","infiSTAR_chewSTAR_dayz_1","infi_STAR_output","infi_STAR_code_stored","keybindings","keypress","menu_toggle_on","dayz_godmode","aiUnit","MENUTITLE","wierdo","runHack","Dwarden","poalmgoasmzxuhnotx","ealxogmniaxhj","ohhpz","fn_genStrFront","shazbot1","cip","Armor1","GMod",
        "kickable","stop","possible","friendlies","hacks","main","mapscanrad","maphalf","DelaySelected","SelectDelay","GlobalSleep","vehD","ALL_WEPS_TO_SEARCH","jopamenu","ggggg","tlm","Listw","toggle_keyEH","infammoON","pu","chute","dayzforce_savex","PVDZ_AdminMenuCode","PVDZ_SUPER_AdminList","DarkwrathBackpack",
        "PVDZ_hackerLog","BP_OnPlayerLogin","material","mapEnabled","markerThread","addedPlayers","playershield","spawnitems1","sceptile27","Proceed_BB","ESPEnabled","wpnbox","fnc_temp","MMYmenu_stored","VMmenu_stored","LVMmenu_stored","BIS_MPF_ServerPersistentCallsArray","PV_CHECK","admin_animate1",
        "patharray","ZobieDistanceStat","infiSTARBOTxxx","keyspressed","fT","tpTarget","HumanityVal","yanma","absol","SimpleMapHackCount","keyp","aggron","magazines_spawn","weapons_spawn","backpack_spawn","backpackitem_spawn","keybindings_exec","keypress_exec","MajorHageAssFuckinfBulletsDude",
        "Wannahaveexplosivesforbullets","TheTargetedFuckingPlayerDude","haHaFuckAntiHakcsManIbypasDatShit","aintNoAntiHackCatchMyVars","objMYPlayer","Awwwinvisibilty","vehiclebro","wtfyisthisshithere","terrainchangintime","Stats","menu","ssdfsdhsdfh","onisinfiniteammobra","youwantgodmodebro",
        "yothefuckingplayerishere","Namey","sendmsg12","jkh","DELETE_THIS","move_forward","leftAndRight","forwardAndBackward","upAndDown","distanceFromGround","hoverPos","bulletcamon","cheatlist","espOn","removegrass","timeday","infammo","norekoil","nocollide","esp2ez","fastwalk","entupautowalk",
        "BensWalker","dropnear","executer","killme","magnetmenu","loadmain","magnet","loadMenu","refreshPlayers","ALREADYRAN","players","BigBenBackpack","sendMessage","newMessage","W34p0ns","amm0","Att4chm3nt","F0od_Dr1nk","M3d1c4l","T0ol_it3ms","B4ckp4cks","It3m5","Cl0th1ng","walkloc","nwaf","cherno",
        "cherno_resident","cherno_resident_2","dubky","oaks","swaf","swmb","getX","PlayerShowDistance","M_e_n_u_2","colorme","keybindloop","Tractor_Time","murkrow","noctowl","isExecuted","piloswine","AddPlayersToMap","markers","miltank","GearAdd","GearRemove","Malvsm","Malcars","malfly","keyForward",
        "PermDialogSelected","TempDialogSelected","AdminDialogList","pfKeygen","pfScanUnits","pfPickPlayer","pfshnext","pfnlist","pfselecteditem","pfshnmenu","pfPlayerMonitor","pfPlayersToMonitor","pfShowPlayerMonitor","pfPlayerMonitorMutex","marker","JJJJ_MMMM___EEEEEEE_INIT_MENU","E_X_T_A_S_Y_Init_Menu",
        "monkaiinsalt","monkaiin","part88","adminKeybinds","PV_DevUIDs","fapEspGroup","Repair","RepairIT","rainbowTarget","rainbowTarget1","rainbowTarget2","rainbowTarget3","letmeknow","VehicleMenue","Menue_Vehicle","my_anus_hurtz","life_no_injection","Tonic_has_a_gaping_vagina","teletoplr","telet",
        "ygurv1f2","BIGM","E3p","fnc_PVAH_AdminReq","infiSTAR_MAIN_CODE","MAIN_CODE_INJECTED","D34DXH34RT_E5P","Arsenal","Jme_Is_God","B0X_CANN0N_T0GGLE","PL4YER_CANN0N_T0GGLE","aim","HOLY_FUCK_FDKFHSDJFHSDKJ_vehicles_m","lazy_ILHA_is_lazy","POOP_Item","die_menu_esp_v1","XXMMWW_main_menu","MM_150",
        "BIS_tracedShooter","JME_HAS_A_GIANT_DONG","nuke_vars","nukepos","fuckfest","fuckfestv2","FAG_NEON","Deverts_keyp","jfkdfjdfjdsfjdsfjkjflfjdlfjdlfjru_keyp","eroticTxt","asdadaio9d0ua298d2a0dza2","trap","boomgoats","morphme","morph","blfor","blfor2","blfor3","rdfor","rdfor2","rdfor3","napa","civ",
        "Detected_Remote_Execution","keybindz","PEDO_IS_FUKED","MAINON","PLAYERON","PLAYEROFFNEXT1","PLAYERNEXT2","ALTISLIFEON","ALTISLIFEOFFNEXT1","ALTISLIFENEXT2","ALTISLIFEOFFNEXT2","ALTISLIFENEXT3","FUNMENUON","FUNMENUOFFNEXT1","FUNMENUNEXT2","FUNMENUOFFNEXT2","FUNMENUNEXT3","MAINOFF","PLAYEROFF","ALTISLIFEOFF",
        "FUNMENUOFF","H4X_Miriweth_Menu_Click_Hax","IrEcOCMmeNEnd_God_MODE","TTTT_IIII___TTTTTTT_REPGAs","EC_GOD_TOGGLE","admin_d0_server","PedoMazing_Friends","ly5t1c","JJMMEE_Swagger","Bobsp","Speed_Hack_cus","pList_star_peter_cus","RGB","neo_throwing","Blue_I_Color_LP","box","bombs","InfiSTAR_RUNNING_AH_on_Player",
        "Orange_I_Color_LP","Menu_I_On_Color_LP","Menu_I_Off_Color_LP","Speed_Hack_cus","cus_SPEED_DOWN","pnc","SpyglassFakeTrigger","infammook","input_text","Tit_Choppertimer","GLASS911_Executer_for_menu","E5P","ThirtySix_Unlim_Ammo","ThirtySix_God","menuheader","life_fnc_sessionUpdateCalled",
        "blu_t_color_LP","FAG_RedSoldiers","titles_n_shit","eXecutorr","menu_headers","player_list","refresh_players","fn_loadMap","weapon_list","vehicle_list","get_display","create_display","CTRL_BTN_LIST","execMapFunc","mapFunc","OPEN_LISTS","init_menu","biggies_white_tex","Abraxas_Unl_Life","Abraxas_Life","waitFor","Mystic_ESP",
        "biggies_menu_open","scriptex3cuter","rym3nucl0s3","eses_alis","PersonWhomMadeThisCorroded_Menu","Flo_Simon_KillPopUp","keybindz2","text_colour","key_combos_ftw","PlayerInfiniteAmmo","Im_a_Variable","aaaa","fnc_LBDblClick_RIGHT","OMFG_MENU","N_6","RscCombo_2100_mini","RscListbox_1501_mini","andy_suicide","life_nukeposition",
        "JxMxE_hide","JME_Keybinds","JME_has_yet_to_fuck_this_shit","JME_deleteC","JME_Tele","JME_ANAL_PLOW","JME_M_E_N_U_initMenu","JME_M_E_N_U_hax_toggled","W_O_O_K_I_E_FUD_Pro_RE","W_O_O_K_I_E_FUD_Car_RE","W_O_O_K_I_E_FUD_Car_RE",
        "JxMxE_Veh_M","JxMxE_LifeCash500k","W_O_O_K_I_E_FUD_FuckUp_GunStore","W_O_O_K_I_E_FUD_M_E_N_U_initMenu","W_O_O_K_I_E_FuckUp_GunStore_a","JME_KillCursor","JME_OPTIONS","JME_M_E_N_U_fill_TROLLmenu","ASSPLUNGE","FOXBYPASS","POLICE_IN_HELICOPTA",
        "JxMxE_EBRP","W_O_O_K_I_E_M_E_N_U_funcs_inited","Menu_Init_Lol","E_X_T_A_S_Y_Atm","W_O_O_K_I_E_Pro_RE","W_O_O_K_I_E_Debug_Mon","W_O_O_K_I_E_Debug_1337","Veh_S_P_A_W_N_Shitt","sfsefse","tw4etinitMenu","tw4etgetControl",
        "JxMxEsp","JxMxE_GOD","JxMxE_Heal","efr4243234","sdfwesrfwesf233","sdgff4535hfgvcxghn","adadawer24_1337","lkjhgfuyhgfd","E_X_T_A_S_Y_M_E_N_U_funcs_inited","dayz_serverObjectMonitor","fsfgdggdzgfd","fsdddInfectLOL","Wookie_List",
        "JxMxE_TP","Wookie_Pro_RE","Wookie_Car_RE","Wookie_Debug_Mon","faze_funcs_inited","advertising_banner_infiSTAR","atext_star_xa","Monky_hax_dbclick","qopfkqpofqk","debug_star_colorful","AntiAntiAntiAntiHax","antiantiantiantih4x",
        "JxMxE_Infect","hub","scrollinit","gfYJV","Lystic_LMAOOOOOOOOOOOOOOOOOOO","Lystic_Re","Lysto_Lyst","E_X_T_A_S_Y_Keybinds","Menulocations","Lystic_Init","scroll_m_init_star","exstr1","pathtoscrdir3","Monky_funcs_inited","fn_filter","vehiList","Remexec_Bitch","zeus_star","igodokxtt","tmmenu","AntihackScrollwheel","survcam","infiniteammo",
        "JxMxE_secret","Monky_initMenu","player_zombieCheck","E_X_T_A_S_Y_Recoil","godlol","playericons","abcdefGEH","wierdo","go_invisible_infiSTAR","serverObjectMonitor","enamearr","initarr3","locdb","sCode","infAmmoIndex","init_Fncvwr_menu_star","altstate","black1ist","ARGT_JUMP","ARGT_KEYDOWN","ARGT_JUMP_w","ARGT_JUMP_a","bpmenu","color_black",
        "nukeDONEstar","Wookie_List","Wookie_Pro_RE","FUCKTONIC","E_X_T_A_S_Y_FuckUp_GunStore_a","E_X_T_A_S_Y_Cash_1k_t","E_X_T_A_S_Y_Cash_a","E_X_T_A_S_Y_LicenseDrive","E_X_T_A_S_Y_Menu_LOOOOOOOOOL","Metallica_vehicleg0dv3_infiSTAR",
        "JJJJ_MMMM___EEEEEEE_INIT_MENU","JJJJ_MMMM___EEEEEEE_GAPER","JJJJ_MMMM___EEEEEEE_SMOKExWEEDxEVERYDAY_BUM_RAPE","JJJJ_MMMM___EEEEEEE_OPTIONS","JJJJ_MMMM___EEEEEEE_M_E_N_U_fill_Target","E3p","Jesus_MODE","ESP","MissileStrike","AL_Liscenses","NoIllegal","NoWeight","m0nkyaatp_sadksadxa","m0nkyaatp_RANDSTR","myvar23","player_adminlevel","TNK","I_like_turtles",
        "BIGM","Does_Tonic_Like_to_take_Turtle_penis_in_the_ass_LODESTARS","Does_Tonic_Like_to_take_Turtle_penis_in_the_ass_LODESTAR1","GMod","No_No_No_Tonic_likes_A_Big_Fat_Sheep_Cock_Right_in_the_bum_G0d_Mode","Sload","aKFerm","aKMMenu","aKTitans","aKLikeaG0d","riasgremory_G0d_Mode","aKCarG0d","riasgremory_Car_Jesus","aKE5p","riasgremory_isseilol","aKPMark","l33tMapESPLunsear",
        "riasgremory_Noobs","riasgremory_Bitches","riasgremory_Map_Markers","aKUnMmo","jenesuispasuncheateur_unamo","aKVoit","Loljesaispasquoiecriremdr","isseigremory","gremorysama","aKTaCu","aKCardetroy","aKGetKey","aKKillcursor",
        "aKNoEscort","aKEscort","aKtroll","aKTPall","aKUnrestrain","aKNoEscortMe","aKNoTaze","aKJailplayer","aKLisense","riasgremory_titans_shit_reold","Tonic_merde","jaimepaslepoisin_HLEAL","TTTT_IIII___TTTTTTT_RAP_FR","TTTT_IIII___TTTTTTT_REPGA",
        "TTTT_IIII___TTTTTTT_REPGAs","jaimepaslepoisin_HLEAL","Root_Main4","Root_Pistol4","Root_Rifle4","Root_Machinegun4","Root_Sniper4","Root_Launcher4","Root_Attachement4","VAR56401668319_secret","myPubVar","XXMMWW_boxquad","Init_Menu_Fury","A3RANDVARrpv1tpv","fnc_nestf","XXMMWW_keybinds","smissles","wooden_velo","vabox","bis_fnc_camera_target",
        "life_var_cash", "life_var_bank"
    };

    //--- bad strings
    detectedstrings[] = {
        "menu loaded","rustler","hangender","hungender","douggem","monstercheats","bigben","fireworks"," is god","> g�ve ", "hydroxus","kill target","no recoil","rapid fire","menutest_","explode all","teleportall","ly�t�c m��u","insert script","3x3cutor",
        "destroyall","destroy all","code to execute","g-e-f","box-esp","god on","god mode","unlimited mags","_execscript","_theban","rhynov1","b1g_b3n","infishit","_escorttt", "e_x_t_a_s_y","weppp3","att4chm3nt","f0od_dr1nk","m3d1c4l","t0ol_it3ms","b4ckp4cks",
        "it3m5","cl0th1ng","lystic","extasy","glasssimon_flo","remote_execution","gladtwoown","_pathtoscripts","flo_simon","sonicccc_","fury_","phoenix_","_my_new_bullet_man","_jm3","thirtysix","dmc_fnc_4danews","w_o_o_k_i_e_m_e_n_u","xbowbii_","jm3_","wuat",
        "dmcheats.de","kichdm","_news_banner","fucked up","lystics menu","rsccombo_2100","\dll\datmalloc","rsclistbox_1501","rsclistbox_1500","\dll\tcmalloc_bi","___newbpass","updated_playerlist","recking_ki","gg_ee_ff","ggggg_eeeee_fffff","listening to jack",
        "_altislifeh4x","antifrezze","ownscripts","ownscripted","mesnu","mystic_","init re","init life re","spoody","gef_","throx_","_adasaasasa","_dsfnsjf","cheatmenu","in54nity","markad","fuck_me_","_v4fin","gggg_eeee_ffff","mord all","teleport all","__byass",
        "a3randvar","infinite ammo","player markers","+ _code +","randomvar","i can break these cuffs","give 100k","kill all","grimbae","pony menu","35sp","c4sh","t e l e p o r t","> c�p","> ammo","titanmods","jaymenu","eject eve","hacked by "
    };

    //---
    uniformwhitelist[]= {
        "U_O_CombatUniform_ocamo"
	};

    //---
	headgearwhitelist[]= {
        "H_Cap_headphones"
	};

    //---
	goggleswhitelist[]= {

	};

    //---
	vestwhitelist[]= {

	};

    //---
	backpackwhitelist[]= {

	};

    //---
    vehiclewhitelist[]={

    };

    //---
    weaponwhitelist[]={

    };
    
    //---
    weaponattacmentwhitelist[]={

    };
};

class CfgFunctions 
{
    class MPServer
    {
        class Antihack_Functions
        {
            file = "\life_backend\scripts\Antihack";
            class antihack_initialize {preInit = 1;}; 
            class antihack_systemlog {};
            class antihack_setupNetwork {};
            class antihack_getAdmins {};
            class antihack_getAdminLvl {};
        };
    };
};