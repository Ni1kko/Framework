/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isRemoteExecuted)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_antihack_initialize.sqf`"] call life_fnc_rcon_ban;};

["Starting AntiHack!"] call life_fnc_antihack_systemlog;

life_var_antihack_loaded = false;
life_var_antihack_networkReady = false;

try {
	private _config = (configFile >> "CfgAntiHack");
	private _admins = call life_fnc_antihack_getAdmins;
	private _rconReady = life_var_rcon_passwordOK;
	
	//--- Log RCON state
	[format["RCON Functions %1!",["Disabled, BANS will not work","Enabled"] select _rconReady]] call life_fnc_antihack_systemlog;

	//--- config
	if(!isClass _config) throw "Config not found";
	private _checkrecoil = getNumber(_config >> "checkrecoil") isEqualTo 1;
	private _checkspeed = getNumber(_config >> "checkspeed") isEqualTo 1;
	private _checkdamage = getNumber(_config >> "checkdamage") isEqualTo 1;
	private _checksway = getNumber(_config >> "checksway") isEqualTo 1;
	private _checkmapEH = getNumber(_config >> "checkmapEH") isEqualTo 1;
	private _checkvehicleweapon = getNumber(_config >> "checkvehicleweapon") isEqualTo 1; 
	private _checkterraingrid = getNumber(_config >> "checkterraingrid") isEqualTo 1;
	private _checkdetectedmenus = getNumber(_config >> "checkdetectedvariables") isEqualTo 1;
	private _checkdetectedvariables = getNumber(_config >> "checkdetectedvariables") isEqualTo 1;
	private _checknamebadchars = getNumber(_config >> "checknamebadchars") isEqualTo 1;
	private _checknameblacklist = getNumber(_config >> "checknameblacklist") isEqualTo 1;
	private _checklanguage = getNumber(_config >> "checklanguage") isEqualTo 1;
	private _serverlanguage = getText(_config >> "serverlanguage");
	private _nameblacklist = getArray(_config >> "nameblacklist");
	private _detectedvariables = getArray(_config >> "detectedvariables");
	private _detectedmenus = getArray(_config >> "detectedmenus");

	//--- random vars ref.
	private _rndvars = [
		"_rnd_ahvar",
		"_rnd_sysvar",
		"_rnd_useRcon",
		"_rnd_admins",
		"_rnd_adminlvl",
		"_rnd_steamID",
		"_rnd_netVar",
		"_rnd_threadone",
		"_rnd_threadtwo",
		"_rnd_threadtwo_one",
		"_rnd_threadinterupt",
		"_rnd_threadtwo_one",
		"_rnd_threadthree_gvars",
		"_rnd_threadthree_objvars",
		"_rnd_threadthree_pvars",
		"_rnd_threadthree_uivars",
		"_rnd_codeone",
		"_rnd_codetwo",
		"_rnd_sendreq",
		"_rnd_kickme",
		"_rnd_banme",
		"_rnd_runserver",
		"_rnd_runglobal",
		"_rnd_runtarget"
	];

	//--- create random vars
	if(isNil "life_fnc_util_randomString") throw "Random string function not found";
	private _tempvars = [];
	_tempvars resize (count _rndvars); 
	_tempvars params (_rndvars apply {private _ret=[_x,call life_fnc_util_randomString];[format["`%1` => `%2`",_ret#0,_ret#1]]call life_fnc_antihack_systemlog;_ret});
	_tempvars =nil;

	//--- antihack expression
	private _antihack = "
		if(!isNull(missionNamespace getVariable ['"+_rnd_threadone+"',scriptNull]))exitWith{};

		waitUntil {!isNull player && {getClientStateNumber >= 8}};

		"+_rnd_useRcon+" = " + str _rconReady + ";
		"+_rnd_steamID+" =     getPlayerUID player;
		"+_rnd_admins+" = " +  str _admins +";
		"+_rnd_adminlvl+" =  compileFinal ""private _lvl = 0;{if(_this isEqualTo _x#1 || _this isEqualTo _x#2)exitWith{_lvl = _x#0;}}forEach "+_rnd_admins+";_lvl"";
		"+_rnd_sendreq+" =   compileFinal """+ _rnd_netVar + " = [_this#0,"+_rnd_steamID+",_this#1];publicVariable '" + _rnd_netVar + "';"";
		"+_rnd_kickme+" =    compileFinal ""if("+_rnd_useRcon +")then{['kick',_this] call "+_rnd_sendreq+";}else{endMission 'END1';};"";
		"+_rnd_banme+" =     compileFinal ""if("+_rnd_useRcon +")then{['ban',_this] call "+_rnd_sendreq+"}else{_this call "+_rnd_kickme+";};"";
		"+_rnd_runserver+" = compileFinal ""['run-server',[_this#1,_this#0]] call "+_rnd_sendreq+";"";
		"+_rnd_runglobal+" = compileFinal ""['run-global',[_this#1,_this#0]] call "+_rnd_sendreq+";"";
		"+_rnd_runtarget+" = compileFinal ""['run-target',[_this#0,_this#2,_this#1]] call "+_rnd_sendreq+";"";
		
		if(typeName(missionNamespace getVariable ['"+_rnd_threadone+"','']) isNotEqualTo 'STRING')then{
			['System ran twice, possible hacker'] call "+_rnd_kickme+";
		};

		"+_rnd_threadone+" = [] spawn 
		{
			[format['%1 Joined',name player],'systemChat'] call "+_rnd_runglobal+";
			if(('"+_rnd_steamID+"' call "+_rnd_adminlvl+") >= 5)exitWith{};";
			if(_checklanguage)then{ 
				_antihack = _antihack + "
					if !(toLower(language) isEqualTo toLower("+str _serverlanguage+"))then{ 
						['Bad Language! ' + (language) + ' Is Not Allowed'] call "+_rnd_kickme+";
					};
				";
			};
			if(_checknamebadchars)then{
				_antihack = _antihack + "
					_chars = [];
					_lang =	 toLower(language);
					_badchar = false;

					if (_lang in ['english','german','italian','spanish'])then{
						_chars = ['Ă','Å','Ć','Č','Ċ','Đ','È','Ę','Ğ','Ģ','Ħ','Ï','Ĩ','Ĵ','ĵ','ĸ','Ŀ','Ľ','Ņ','Ŋ','Ő','Ô','Þ','Ř','Ş','Ţ','Ů','Û','Ŵ','Ŷ','Ż'];
					}else{
						_chars = switch(_lang)do{
							case 'russian': {['Ă','Å','Ć','Č','Ċ','Đ','È','Ę','Ğ','Ģ','Ħ','Ï','Ĩ','Ĵ','ĵ','Ŀ','Ľ','Ņ','Ŋ','Ő','Ô','Þ','Ř','Ş','Ţ','Ů','Û','Ŵ','Ŷ','Ż']};
							case 'french':  {['Ă','Å','Ć','Č','Ċ','Đ','Ę','Ğ','Ģ','Ħ','Ĩ','Ĵ','ĵ','ĸ','Ŀ','Ľ','Ņ','Ŋ','Ő','Þ','Ř','Ş','Ţ','Ů','Ŵ','Ŷ','Ż']}; 
							case 'polish':  {['Ă','Å','Ć','Č','Ċ','Đ','È','Ę','Ğ','Ģ','Ħ','Ï','Ĩ','Ĵ','ĵ','Ŀ','Ľ','Ņ','Ŋ','Ő','Ô','Þ','Ř','Ş','Ţ','Ů','Û','Ŵ','Ŷ']}; 
							case 'czech':   {['Ă','Å','Ć','Ċ','Đ','È','Ę','Ğ','Ģ','Ħ','Ï','Ĩ','Ĵ','ĵ','ĸ','Ŀ','Ľ','Ņ','Ŋ','Ő','Ô','Þ','Ş','Ţ','Û','Ŵ','Ŷ','Ż']};    
							default {[]};
						}; 
					};
					
					{if([_x, profileName,false]call BIS_fnc_inString)exitWith{_badchar = true;}}foreach _chars;
					if(_badchar)then{[('Bad Name! Char: (' + (_x) + ') Is Not Allowed')] call "+_rnd_kickme+";};
				";
			};
			if(_checknameblacklist)then{
				_antihack = _antihack + "
					{
						if([profileName, _x] call BIS_fnc_inString)exitWith{
							['Bad Name! ' + (_x) + ' Is Not Allowed'] call "+_rnd_kickme+";  
						};
					}forEach "+str _nameblacklist+";
				";
			};
			if(_checkdetectedmenus)then{
				_antihack = _antihack + "
					terminate (missionNamespace getVariable ['"+_rnd_threadtwo_one+"',scriptNull]);
					"+_rnd_threadtwo_one+" = [] spawn{
						waitUntil{(!isNull (findDisplay 49)) && (!isNull (findDisplay 602))};  
						(findDisplay 49) closeDisplay 2; (findDisplay 602) closeDisplay 2;
						['Opened Esacpe & Inventory Menus | Possible Inventory Glitch'] call "+_rnd_kickme+";
					};
				";
			};
			_antihack = _antihack + "
			while {true} do {";
				if(_checkvehicleweapon)then{ 
					_antihack = _antihack + "
						if(vehicle player != player) then {
							if(local (vehicle player)) then {
								_vehWeps = getArray(configFile >> 'cfgVehicles' >> typeof (vehicle player) >> 'weapons');
								_hasWeps = (weapons (vehicle player));
								if !(_vehWeps isEqualTo _hasWeps) then {
									deleteVehicle (vehicle player);
									[format['%1s Vehicle has: (%2) Should have: (%3) | Vehicle Weapon Hack',name player,str(_hasWeps),str(_vehWeps)]] call "+_rnd_banme+";
								};
							};
						}; 
					";
				};
				_antihack = _antihack + "
				uiSleep (random [1,2,5]);
			};
		};

		"+_rnd_codeone+" =  compileFinal ""
			if(('"+_rnd_steamID+"' call "+_rnd_adminlvl+") >= 3)exitWith{};";	
			if(_checkrecoil)then{
				_antihack = _antihack + "
					private _recoil = unitRecoilCoefficient player;
				";
			};
			if(_checksway)then{ 
				_antihack = _antihack + "
					private _sway = getCustomAimCoef player;
				";
			};
			if(_checkmapEH)then{ 
				_antihack = _antihack + "
					private _mapClickEH = -1;
					private _eh = -1;
				";
			};
			_antihack = _antihack + "	
			while {true} do {";
				if(_checkmapEH)then{ 
					_antihack = _antihack + "
						_eh = addMissionEventHandler['MapSingleClick', {}];
						if (_eh > _mapClickEH) then {
							if (_mapClickEH == -1) then {
								_mapClickEH = _eh;
							}else{
								[format['%1 EventHandlers Changed! - %2, should be %3 | MapSingleClick Cheat',name player,_eh,_mapClickEH]] call "+_rnd_banme+";
							};
						};
						removeAllMissionEventHandlers 'MapSingleClick';
					";
				};
				if(_checkterraingrid)then{
					_antihack = _antihack + " 
						if(getTerrainGrid >= 50) then {
							[format['%1 Has No Grass! %1 Has TerrainGrid set to %2 | No Grass Cheat',name player,str(getTerrainGrid)]] call "+_rnd_banme+";
						};
					";
				};
				if(_checkrecoil)then{ 
					_antihack = _antihack + "
						if(unitRecoilCoefficient player != _recoil && unitRecoilCoefficient player != 1) then { 
							[format['%1 Recoil Changed! - %2 Should Be %3 | Recoil Cheat',name player,str(unitRecoilCoefficient player),_recoil]] call "+_rnd_banme+";
						};
					";
				}; 
				if(_checkspeed)then{ 
					_antihack = _antihack + "
						_speedCount = 0; 
						if (isNull objectParent player) then {
							_speedCount = if (speed player > 30) then {_speedCount + 1} else {0};
							if (_speedCount > 10) then {
								[format['%1 Moved Too Fat! - Moving at %2 on foot for over 5 seconds | Speed Hack',name player,speed player]] call "+_rnd_banme+";
							};
						}else{
							_speedCount = 0;
						}; 
					";
				}; 
				if(_checkdamage)then{ 
					_antihack = _antihack + "
						if(!isDamageAllowed player) then { 
							[format['%1 Has Invincibility! %1 Has AllowDamage set to %2 | GodMode Cheat',name player,str(isDamageAllowed player)]] call "+_rnd_banme+";
						};
					";
				}; 
				if(_checksway)then{ 
					_antihack = _antihack + "
						if(getCustomAimCoef player != _sway && getCustomAimCoef player != 1)then{
							[format['%1 WeaponSway Changed! %2 Should Be  %3 | No Sway Cheat',name player,str(getCustomAimCoef player),str _sway]] call "+_rnd_banme+";
						}; 
					";
				}; 
				_antihack = _antihack + "
				uiSleep 1;
			};
		"";

		"+_rnd_threadtwo+" = [] spawn 
		{
			terminate (missionNamespace getVariable ['"+_rnd_threadtwo_one+"',scriptNull]);
			terminate (missionNamespace getVariable ['"+_rnd_threadinterupt+"',scriptNull]);
			"+_rnd_codetwo+" = compileFinal ""
				private _space = toArray (' ');for '_i' from 0 to (_this)-1 do{_space pushBack (32);};_space = (toString _space); 
				while{true}do{
					waitUntil{!(isNull (findDisplay 49))};
					((findDisplay 49) displayCtrl 120) ctrlSetText 'Life AntiCheat';
					((findDisplay 49) displayCtrl 115025) ctrlSetText format['%1Life Anti',_space];
					((findDisplay 49) displayCtrl 115035) ctrlSetText 'Cheat Online';
					waitUntil{(isNull (findDisplay 49))};      
				}; 
			"";";
			if(_checkdetectedmenus)then{
				_antihack = _antihack + "
					{
						[_x] spawn {
							waitUntil{!isNull (findDisplay _this)};
							[format['%1 Has Opened A Bad Menu: %1 | Script Kiddie',name player,_this]] call "+_rnd_banme+";
						};
					}forEach " + str _detectedmenus + ";
				";
			};
			if(_checkdetectedvariables)then{
				_antihack = _antihack + "
					{
						_x spawn {
							waitUntil{!isNil _this};
							[format['badvar `%1` found, possible hacker']] call "+_rnd_banme+";
						};
					} forEach "+str _detectedvariables+";
				";
			};
			_antihack = _antihack + "
			systemChat 'Antihack loaded!';
			"+_rnd_ahvar+" = ['"+_rnd_sysvar+"','"+_rnd_steamID+"', serverTime];
			publicVariable '"+_rnd_ahvar+"';
			while {true} do {
				if(isNull (missionNamespace getVariable ['"+_rnd_threadtwo_one+"',scriptNull]))then{
					"+_rnd_threadtwo_one+" = [] spawn "+_rnd_codeone+";
				};
				if(isNull (missionNamespace getVariable ['"+_rnd_threadinterupt+"',scriptNull]))then{
					"+_rnd_threadinterupt+" = (42) spawn "+_rnd_codetwo+";
				};
				if(isNil {missionNamespace getVariable '"+_rnd_ahvar+"'})then{
					['`_rnd_ahvar` nil, possible hacker'] call "+_rnd_banme+";
				};
				uiSleep 2;
			};
		};

		waitUntil{isNull(missionNamespace getVariable ['"+_rnd_threadone+"',scriptNull])};
		['Main thread terminated, possible hacker'] call "+_rnd_kickme+";
	";

	//--- something broke with expression
	if(isNil "_antihack")throw "Failed to load antihack";

	//--- setup network thread
	_antihack = [_antihack,_rnd_netVar,_rnd_sysvar] spawn life_fnc_antihack_setupNetwork;
	
	//--- something broke with thread
	if(isNull _antihack)throw "Failed to load antihack network";

	life_var_antihack_loaded = true;
}catch {
	[_exception] call life_fnc_antihack_systemlog;
	
	life_var_antihack_loaded = false;
};

_antihack = nil;

if(life_var_antihack_loaded)then{
	["System fully initialized!"] call life_fnc_antihack_systemlog;
};

life_var_antihack_loaded