/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(!canSuspend)exitwith{[]spawn life_fnc_antihack_initialize};
if(missionNamespace getVariable ["life_var_antihack_loaded",false])exitwith{false};
if(isRemoteExecuted AND life_var_rcon_passwordOK)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_antihack_initialize.sqf`"] call life_fnc_rcon_ban;};

waitUntil {!isNil "life_var_rcon_passwordOK"};
["Starting AntiHack!"] call life_fnc_antihack_systemlog;

life_var_antihack_loaded = false;
life_var_antihack_networkReady = false;
 
waitUntil {isFinal "extdb_var_database_key"};

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
	private _interuptinfo = getNumber(_config >> "use_interuptinfo") isEqualTo 1;
	private _serverlanguage = getText(_config >> "serverlanguage");
	private _nameblacklist = getArray(_config >> "nameblacklist");
	private _detectedvariables = getArray(_config >> "detectedvariables");
	private _detectedmenus = getArray(_config >> "detectedmenus");

	//--- random vars ref.
	private _rndvars = [
		"_rnd_ahvar",
		"_rnd_sysvar",
		"_rnd_playersvar",
		"_rnd_useRcon",
		"_rnd_admins",
		"_rnd_isadmin",
		"_rnd_adminlvl",
		"_rnd_steamID",
		"_rnd_netID",
		"_rnd_netVar",
		"_rnd_threadone",
		"_rnd_threadtwo",
		"_rnd_threadtwo_one",
		"_rnd_threadinterupt",
		"_rnd_threadtwo_two",
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
		"_rnd_runtarget",
		"_rnd_mins2hrsmins"
	];

	//--- create random vars
	if(isNil "life_fnc_util_randomString") throw "Random string function not found";
	private _tempvars = [];
	_tempvars resize (count _rndvars); 
	_tempvars params (_rndvars apply {private _ret=[_x,call life_fnc_util_randomString];[format["`%1` => `%2`",_ret#0,_ret#1]]call life_fnc_antihack_systemlog;_ret});
	_tempvars =nil;
	 
	//--- antihack expression
	private _antihackclient = "
		if(!isNull(missionNamespace getVariable ['"+_rnd_threadone+"',scriptNull]))exitWith{};
		if(isFinal '"+_rnd_kickme+"')then{'System ran twice, possible hacker' call "+_rnd_kickme+";};
		if(isFinal '"+_rnd_banme+"')then{'System ran twice, possible hacker' call "+_rnd_banme+";};

		"+_rnd_useRcon+" = " + str _rconReady + ";
		"+_rnd_admins+" = " +  str _admins +";
		"+_rnd_adminlvl+" = compileFinal ""private _lvl = 0;{if(_this isEqualTo _x#1 || _this isEqualTo _x#2)exitWith{_lvl = _x#0;}}forEach "+_rnd_admins+";_lvl"";
		"+_rnd_isadmin+" = (call "+_rnd_adminlvl+") > 0;

		waitUntil {!isNull player && {getClientStateNumber >= 8}};
		
		"+_rnd_steamID+" =   getPlayerUID player;
		"+_rnd_netID+" =     netId player;
		"+_rnd_sendreq+" =   compileFinal """+ _rnd_netVar + " = [_this#0,"+_rnd_steamID+",_this#1];publicVariable '" + _rnd_netVar + "';"";
		"+_rnd_kickme+" =    compileFinal ""if("+_rnd_useRcon +")then{['kick',_this] call "+_rnd_sendreq+";}else{endMission 'END1';};"";
		"+_rnd_banme+" =     compileFinal ""if("+_rnd_useRcon +")then{['ban',_this] call "+_rnd_sendreq+"}else{_this call "+_rnd_kickme+";};"";
		"+_rnd_runserver+" = compileFinal ""['run-server',[_this#1,_this#0]] call "+_rnd_sendreq+";"";
		"+_rnd_runglobal+" = compileFinal ""['run-global',[_this#1,_this#0]] call "+_rnd_sendreq+";"";
		"+_rnd_runtarget+" = compileFinal ""['run-target',[_this#0,_this#2,_this#1]] call "+_rnd_sendreq+";"";
		
		"+_rnd_threadone+" = [] spawn 
		{
			[format['%1 Joined',name player],'systemChat'] call "+_rnd_runglobal+";
			if(('"+_rnd_steamID+"' call "+_rnd_adminlvl+") >= 5)exitWith{diag_log 'Antihack Thread#1 Active!';};"; 
			if(_checkdetectedmenus)then{
				_antihackclient = _antihackclient + "
					terminate (missionNamespace getVariable ['"+_rnd_threadtwo_one+"',scriptNull]);
					"+_rnd_threadtwo_one+" = [] spawn{
						waitUntil{(!isNull (findDisplay 49)) && (!isNull (findDisplay 602))};  
						(findDisplay 49) closeDisplay 2; (findDisplay 602) closeDisplay 2;
						'Opened Esacpe & Inventory Menus | Possible Inventory Glitch' call "+_rnd_kickme+";
					};
				";
			};
			_antihackclient = _antihackclient + "
			while {true} do {";
				if(_checkvehicleweapon)then{ 
					_antihackclient = _antihackclient + "
						if(vehicle player != player) then {
							if(local (vehicle player)) then {
								_vehWeps = getArray(configFile >> 'cfgVehicles' >> typeof (vehicle player) >> 'weapons');
								_hasWeps = (weapons (vehicle player));
								if !(_vehWeps isEqualTo _hasWeps) then {
									deleteVehicle (vehicle player);
									format['%1s Vehicle has: (%2) Should have: (%3) | Vehicle Weapon Hack',name player,_hasWeps,_vehWeps] call "+_rnd_banme+";
								};
							};
						}; 
					";
				};
				_antihackclient = _antihackclient + "
				uiSleep (random [1,2,5]);
			};
		};
	
		"+_rnd_codeone+" =  compileFinal ""
			if(('"+_rnd_steamID+"' call "+_rnd_adminlvl+") >= 3)exitWith{diag_log 'Antihack Codeone Active!';};";
			if(_checkrecoil)then{
				_antihackclient = _antihackclient + "
					private _recoil = unitRecoilCoefficient player;
				";
			};
			if(_checksway)then{ 
				_antihackclient = _antihackclient + "
					private _sway = getCustomAimCoef player;
				";
			};
			if(_checkmapEH)then{ 
				_antihackclient = _antihackclient + "
					private _mapClickEH = -1;
					private _eh = -1;
				";
			};
			_antihackclient = _antihackclient + "	
			while {true} do {";
				if(_checkmapEH)then{ 
					_antihackclient = _antihackclient + "
						_eh = addMissionEventHandler['MapSingleClick', {}];
						if (_eh > _mapClickEH) then {
							if (_mapClickEH == -1) then {
								_mapClickEH = _eh;
							}else{
								format['%1 EventHandlers Changed! - %2, should be %3 | MapSingleClick Cheat',name player,_eh,_mapClickEH] call "+_rnd_banme+";
							};
						};
						removeAllMissionEventHandlers 'MapSingleClick';
					";
				};
				if(_checkterraingrid)then{
					_antihackclient = _antihackclient + " 
						if(getTerrainGrid >= 50) then {
							format['%1 Has No Grass! %1 Has TerrainGrid set to %2 | No Grass Cheat',name player,getTerrainGrid] call "+_rnd_banme+";
						};
					";
				};
				if(_checkrecoil)then{ 
					_antihackclient = _antihackclient + "
						if(unitRecoilCoefficient player != _recoil && unitRecoilCoefficient player != 1) then { 
							format['%1 Recoil Changed! - %2 Should Be %3 | Recoil Cheat',name player,unitRecoilCoefficient player,_recoil] call "+_rnd_banme+";
						};
					";
				}; 
				if(_checkspeed)then{ 
					_antihackclient = _antihackclient + "
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
					_antihackclient = _antihackclient + "
						if(!isDamageAllowed player) then { 
							format['%1 Has Invincibility! %1 Has AllowDamage set to %2 | GodMode Cheat',name player,isDamageAllowed player] call "+_rnd_banme+";
						};
					";
				}; 
				if(_checksway)then{ 
					_antihackclient = _antihackclient + "
						if(getCustomAimCoef player != _sway && getCustomAimCoef player != 1)then{
							format['%1 WeaponSway Changed! %2 Should Be  %3 | No Sway Cheat',name player,getCustomAimCoef player,_sway] call "+_rnd_banme+";
						};
					";
				}; 
				_antihackclient = _antihackclient + "
				uiSleep 1;
			};
		"";

		"+_rnd_mins2hrsmins+" = compile ""
			private _hours = floor((_this * 60 ) / 60 / 60);
			private _minutes = (((_this * 60 ) / 60 / 60) - _hours);
			if(_minutes == 0)then{_minutes = 0.0001;};
			_minutes = round(_minutes * 60);
			[_hours,_minutes]
		"";
		
		";
	
		if(_interuptinfo)then{
			_antihackclient = _antihackclient + " 
				"+_rnd_codetwo+" = compileFinal ""
					if("+_rnd_isadmin+")then{diag_log 'Antihack Codetwo Active!'};
					while{true}do{
						waitUntil{!(isNull (findDisplay 49))};
						private _text = '';";
						_antihackclient = _antihackclient + "
						waitUntil{
							private _textNew = format['%1 Life AntiCheat | Total Players Online (%3/%4) | Guid: (%2)',worldName,call(player getVariable ['BEGUID',{''}]), count(allPlayers - entities 'HeadlessClient_F'),((playableSlotsNumber west) + (playableSlotsNumber independent) + (playableSlotsNumber civilian)  + (playableSlotsNumber east) + 1)];";
							if(_rconReady)then{ 
								_antihackclient = _antihackclient + " 
									private _timeRestart = (life_var_rcon_RestartTime - life_var_rcon_upTime) call "+_rnd_mins2hrsmins+";  
									_textNew = format['%1 | Server Restart In: %2h %3min',_textNew,_timeRestart#0,_timeRestart#1];
								";
							};
							_antihackclient = _antihackclient + "
							if(_text isNotEqualTo _textNew)then{
								_text = _textNew;
								((findDisplay 49) displayCtrl 120) ctrlSetText _text;
							};
							uiSleep 2;
							isNull (findDisplay 49)
						};
					};
				"";
			";
		};

		_antihackclient = _antihackclient + "
		"+_rnd_threadtwo+" = [] spawn 
		{
			if("+_rnd_isadmin+")then{diag_log 'Antihack Thread#2 Active!'};
			terminate (missionNamespace getVariable ['"+_rnd_threadtwo_one+"',scriptNull]);
			terminate (missionNamespace getVariable ['"+_rnd_threadinterupt+"',scriptNull]);";
			
			if(_checklanguage)then{ 
				_antihackclient = _antihackclient + "
					if (toLower(language) isNotEqualTo toLower("+_serverlanguage+"))then{ 
						format['Bad Language! %1 Is Not Allowed',language] call "+_rnd_kickme+";
					};
				";
			};
			if(_checknamebadchars)then{
				_antihackclient = _antihackclient + "
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
				_antihackclient = _antihackclient + "
					{
						if([profileName, _x] call BIS_fnc_inString)exitWith{
							format['Bad Name! %1 Is Not Allowed',_x] call "+_rnd_kickme+";  
						};
					}forEach "+str _nameblacklist+";
				";
			};

			_antihackclient = _antihackclient + ""+_rnd_ahvar+" = ['"+_rnd_playersvar+"',"+_rnd_netID+", ['"+_rnd_threadtwo_two+"',"+_rnd_codeone+"]];";
			
			if(_checkdetectedmenus)then{
				_antihackclient = _antihackclient + "
					{
						[_x] spawn {
							waitUntil{!isNull (findDisplay _this)};
							format['%1 Has Opened A Bad Menu: %1 | Script Kiddie',name player,_this] call "+_rnd_banme+";
						};
					}forEach " + str _detectedmenus + ";
				";
			};
			if(_checkdetectedvariables)then{
				_antihackclient = _antihackclient + "
					{
						_x spawn {
							waitUntil{!isNil _this};
							format['badvar `%1` found, possible hacker',_this] call "+_rnd_banme+";
						};
					} forEach "+str _detectedvariables+";
				";
			};

			_antihackclient = _antihackclient + ""+_rnd_sysvar+" = "+_rnd_ahvar+";
			
			uiSleep (random[4,5,7]);
			systemChat 'Antihack loading!';
			publicVariable '"+_rnd_sysvar+"';
			waitUntil {isNil {missionNamespace getVariable '"+_rnd_sysvar+"'}};
			"+_rnd_ahvar+" = random(99999);

			while {true} do {
				uiSleep 2;";
					if(_interuptinfo)then{
						_antihackclient = _antihackclient + "
							if(isNull (missionNamespace getVariable ['"+_rnd_threadinterupt+"',scriptNull]))then{
								"+_rnd_threadinterupt+" = [] spawn "+_rnd_codetwo+";
							};
						";
					};
					_antihackclient = _antihackclient + "
				uiSleep 2;
					if(isNil {missionNamespace getVariable '"+_rnd_ahvar+"'})then{
						'`_rnd_ahvar` nil, possible hacker' call "+_rnd_banme+";
					};
				uiSleep 2;
			};
		};

		waitUntil{isNull(missionNamespace getVariable ['"+_rnd_threadone+"',scriptNull])};
		'Main thread terminated, possible hacker' call "+_rnd_kickme+";
	";
	
	//--- something broke with antihackclient expression
	if(isNil "_antihackclient")throw "Failed to load antihack";

	//--- setup network thread
	_antihackclient = [_antihackclient,_rnd_netVar,_rnd_sysvar] spawn life_fnc_antihack_setupNetwork;
	
	//--- something broke with thread
	if(isNull _antihackclient)throw "Failed to load antihack network";

	life_var_antihack_loaded = true;
}catch {
	[format["Exception: %1",_exception]] call life_fnc_antihack_systemlog;
	
	life_var_antihack_loaded = false;
};

_antihackclient = nil;

if(life_var_antihack_loaded)then{
	["System fully initialized!"] call life_fnc_antihack_systemlog;
};

life_var_antihack_loaded