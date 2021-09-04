/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

waitUntil {!isNil "life_var_rcon_passwordOK"};

if(!isServer)exitwith{false};
if(!canSuspend)exitwith{[]spawn life_fnc_antihack_initialize};
if(missionNamespace getVariable ["life_var_antihack_loaded",false])exitwith{false};
if(isRemoteExecuted AND life_var_rcon_passwordOK)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_antihack_initialize.sqf`"] call life_fnc_rcon_ban;};

["Starting AntiHack!"] call life_fnc_antihack_systemlog;

life_var_antihack_loaded = false;
life_var_antihack_networkReady = false;
life_var_antihack_logs = [];

waitUntil {isFinal "extdb_var_database_key"};

try {
	private _config = (configFile >> "CfgAntiHack");
	private _admins = call life_fnc_antihack_getAdmins;
	private _rconReady = life_var_rcon_passwordOK;
	private _memoryhacks_client = [];
	private _memoryhacks_server = [];
	private _weaponclasses = [];
	private _weaponattachments = [];
	private _vehicleclasses = [];
	private _uniformclasses = [];
	private _headgearclasses = [];
	private _gogglesclasses = [];
	private _vestclasses = [];
	private _backpacksclasses = [];

	//--- Log RCON state
	[format["RCON Functions %1!",["Disabled, BANS will not work","Enabled"] select _rconReady]] call life_fnc_antihack_systemlog;

	//--- Get Config
	if(!isClass _config) throw "Config not found";
	private _dbLogs = getNumber(_config >> "dblogs") isEqualTo 1;
	private _checkrecoil = getNumber(_config >> "checkrecoil") isEqualTo 1;
	private _checkspeed = getNumber(_config >> "checkspeed") isEqualTo 1;
	private _checkdamage = getNumber(_config >> "checkdamage") isEqualTo 1;
	private _checksway = getNumber(_config >> "checksway") isEqualTo 1;
	private _checkmapEH = getNumber(_config >> "checkmapEH") isEqualTo 1;
	private _checkteleport = getNumber(_config >> "checkteleport") isEqualTo 1;
	private _checkvehicle = getNumber(_config >> "checkvehicle") isEqualTo 1;
	private _checkvehicleweapon = getNumber(_config >> "checkvehicleweapon") isEqualTo 1; 
	private _checkweapon = getNumber(_config >> "checkweapon") isEqualTo 1;  
	private _checkweaponattachments = getNumber(_config >> "checkweaponattachments") isEqualTo 1; 
	private _checkterraingrid = getNumber(_config >> "checkterraingrid") isEqualTo 1;
	private _checkdetectedmenus = getNumber(_config >> "checkdetectedmenus") isEqualTo 1;
	private _checkdetectedvariables = getNumber(_config >> "checkdetectedvariables") isEqualTo 1;
	private _checknamebadchars = getNumber(_config >> "checknamebadchars") isEqualTo 1;
	private _checknameblacklist = getNumber(_config >> "checknameblacklist") isEqualTo 1;
	private _checklanguage = getNumber(_config >> "checklanguage") isEqualTo 1;
	private _checkmemoryhack = getNumber(_config >> "checkmemoryhack") isEqualTo 1;
	private _interuptinfo = getNumber(_config >> "use_interuptinfo") isEqualTo 1;
	private _checkgear = getNumber(_config >> "checkgear") isEqualTo 1;
	private _checkuniform = getNumber(_config >> "checkuniform") isEqualTo 1;
	private _checkheadgear = getNumber(_config >> "checkheadgear") isEqualTo 1;
	private _checkgoggles = getNumber(_config >> "checkgoggles") isEqualTo 1;
	private _checkvests = getNumber(_config >> "checkvests") isEqualTo 1;
	private _checkbackpacks = getNumber(_config >> "checkbackpacks") isEqualTo 1;
	private _serverlanguage = getText(_config >> "serverlanguage");
	private _nameblacklist = getArray(_config >> "nameblacklist");
	private _detectedvariables = getArray(_config >> "detectedvariables");
	private _detectedmenus = getArray(_config >> "detectedmenus");
	private _badmenus = getArray(_config >> "badmenus");
	private _detectedstrings = getArray(_config >> "detectedstrings");
	private _vehiclewhitelist = getArray(_config >> "vehiclewhitelist");
	private _weaponwhitelist = getArray(_config >> "weaponwhitelist");
	private _weaponattacmentwhitelist = getArray(_config >> "weaponattacmentwhitelist");
	private _uniformwhitelist = getArray(_config >> "uniformwhitelist");
	private _headgearwhitelist = getArray(_config >> "headgearwhitelist");
	private _goggleswhitelist = getArray(_config >> "goggleswhitelist");
	private _vestwhitelist = getArray(_config >> "vestwhitelist");
	private _backpackwhitelist = getArray(_config >> "backpackwhitelist");

	//--- Setup memory hack arrays
	if(_checkmemoryhack)then{
		{
			_memoryhacks_client pushBackUnique _x;
			_memoryhacks_server pushBackUnique (toArray (call compile (_x#0)));
		}forEach [
			["getText(configFile >> 'RscDisplayOptionsVideo' >> 'controls' >> 'G_VideoOptionsControls' >> 'controls' >> 'HideAdvanced' >> 'OnButtonClick')",'RscDisplayOptionsVideo >> HideAdvanced','OnButtonClick'],
			["getText(configFile >> 'RscDisplayOptions' >> 'controls' >> 'BCredits' >> 'OnButtonClick')",'RscDisplayOptions >> BCredits','OnButtonClick'],
			["getText(configFile >> 'RscDisplayOptions' >> 'controls' >> 'ButtonCancel' >> 'OnButtonClick')",'RscDisplayOptions >> ButtonCancel','OnButtonClick'],
			["getText(configFile >> 'RscDisplayOptions' >> 'controls' >> 'ButtonCancel' >> 'action')",'RscDisplayOptions >> ButtonCancel','action'],
			["getText(configFile >> 'RscDisplayOptions' >> 'controls' >> 'BGameOptions' >> 'action')",'RscDisplayOptions >> BGameOptions','action'],
			["getText(configFile >> 'RscDisplayOptions' >> 'controls' >> 'BConfigure' >> 'action')",'RscDisplayOptions >> BConfigure','action'],
			["getText(configFile >> 'RscDisplayMPInterrupt' >> 'controls' >>'ButtonAbort' >> 'action')",'RscDisplayMPInterrupt >> ButtonAbort','action'],
			["getText(configFile >> 'RscDisplayMPInterrupt' >> 'controls' >>'ButtonAbort' >> 'OnButtonClick')",'RscDisplayMPInterrupt >> ButtonAbort','OnButtonClick']
		];
	};
	
	//--- Setup allowed vehicles
	if(_checkvehicle)then{
		private _configCarShops = missionConfigFile >> "CarShops";
		if(isClass _configCarShops) then{
			for "_i" from 0 to ((count _configCarShops) -1) do{
				{
					_vehicleclasses pushBackUnique toLower(_x#0);
				}forEach getArray(_configCarShops >> configName (_configCarShops select _i)  >> "vehicles");
			};
			{
				_vehicleclasses pushBackUnique toLower _x;
			}forEach _vehiclewhitelist;
		}else{
			_checkvehicle = false;
		};
	};

	//--- Setup allowed weapons
	if(_checkweapon)then{
		private _configWeaponShops = missionConfigFile >> "WeaponShops";
		if(isClass _configWeaponShops) then{
			for "_i" from 0 to ((count _configWeaponShops) -1) do{
				{
					_weaponclasses pushBackUnique toLower(_x#0);
				}forEach getArray(_configWeaponShops >> configName (_configWeaponShops select _i)  >> "items");
				
				//--- Setup allowed weapon attachments
				if(_checkweaponattachments)then{
					{
						_weaponattachments pushBackUnique toLower(_x#0);
					}forEach getArray(_configWeaponShops >> configName (_configWeaponShops select _i)  >> "accs");
				};
			};
			{_weaponclasses pushBackUnique toLower _x}forEach _weaponwhitelist;
			if(_checkweaponattachments)then{
				{_weaponattachments pushBackUnique toLower _x}forEach _weaponattacmentwhitelist;
			};
		}else{
			_checkweapon = false;
		};

		private _configLoadouts = missionConfigFile >> "Loadouts";
		if(isClass _configLoadouts) then{
			for "_i" from 0 to ((count _configLoadouts) -1) do{
				{
					_weaponclasses pushBackUnique toLower(_x#0);
				}forEach getArray(_configLoadouts >> configName (_configLoadouts select _i)  >> "weapon"); 
			};
		}else{
			_checkweapon = false;
		};
	};

	//--- Setup allowed gear
	if(_checkgear)then{
		private _configClothing = missionConfigFile >> "Clothing";
		if(isClass _configClothing) then{
			//--- Allowed uniforms
			if(_checkuniform)then{
				for "_i" from 0 to ((count _configClothing) -1) do{
					{
						_uniformclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configClothing >> configName (_configClothing select _i)  >> "uniforms"); 
				};
				{_uniformclasses pushBackUnique toLower _x}forEach _uniformwhitelist;
			};
			//--- Allowed headgear
			if(_checkheadgear)then{
				for "_i" from 0 to ((count _configClothing) -1) do{
					{
						_headgearclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configClothing >> configName (_configClothing select _i)  >> "headgear"); 
				};
				{_headgearclasses pushBackUnique toLower _x}forEach _headgearwhitelist;
			};
			//--- Allowed goggles
			if(_checkgoggles)then{
				for "_i" from 0 to ((count _configClothing) -1) do{
					{
						_gogglesclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configClothing >> configName (_configClothing select _i)  >> "goggles"); 
				};
				{_gogglesclasses pushBackUnique toLower _x}forEach _goggleswhitelist;
			};
			//--- Allowed vests
			if(_checkvests)then{
				for "_i" from 0 to ((count _configClothing) -1) do{
					{
						_vestclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configClothing >> configName (_configClothing select _i)  >> "vests"); 
				};
				{_vestclasses pushBackUnique toLower _x}forEach _vestwhitelist;
			};
			//--- Allowed backpacks
			if(_checkbackpacks)then{
				for "_i" from 0 to ((count _configClothing) -1) do{
					{
						_backpacksclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configClothing >> configName (_configClothing select _i)  >> "backpacks"); 
				};
				{_backpacksclasses pushBackUnique toLower _x}forEach _backpackwhitelist;
			};
		}else{
			_checkgear = false;
		};

		private _configLoadouts = missionConfigFile >> "Loadouts";
		if(isClass _configLoadouts) then{
			//--- Allowed uniforms
			if(_checkuniform)then{
				for "_i" from 0 to ((count _configLoadouts) -1) do{
					{
						_uniformclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configLoadouts >> configName (_configLoadouts select _i)  >> "uniform"); 
				};
			};
			//--- Allowed headgear
			if(_checkheadgear)then{
				for "_i" from 0 to ((count _configLoadouts) -1) do{
					{
						_headgearclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configLoadouts >> configName (_configLoadouts select _i)  >> "headgear"); 
				};
			};
			//--- Allowed vests
			if(_checkvests)then{
				for "_i" from 0 to ((count _configLoadouts) -1) do{
					{
						_vestclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configLoadouts >> configName (_configLoadouts select _i)  >> "vest"); 
				};
			};
			//--- Allowed backpacks
			if(_checkbackpacks)then{
				for "_i" from 0 to ((count _configLoadouts) -1) do{
					{
						_backpacksclasses pushBackUnique toLower(_x#0);
					}forEach getArray(_configLoadouts >> configName (_configLoadouts select _i)  >> "backpack"); 
				};
			};
		}else{
			_checkgear = false;
		};
	};
	
	//--- Load logs
	if(_dbLogs)then{
		private _logs = ["READ", "antihack_logs",[["Type","log","steamID"],[]],false] call life_fnc_database_request;
		{
			life_var_antihack_logs pushback _x;
		}forEach _logs;
	};
	publicVariable "life_var_antihack_logs";

	//--- random vars ref
	private _rndvars = [
		"_rnd_ahvar",
		"_rnd_sysvar",
		"_rnd_hcvar",
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
		"_rnd_threadthree",
		"_rnd_threadfour",
		"_rnd_threadfive",
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
		"_rnd_logme",
		"_rnd_mins2hrsmins",
		"_rnd_vehicleclasses",
		"_rnd_weaponclasses",
		"_rnd_weaponattachments",
		"_rnd_admincode"
	];

	//--- create random vars
	if(isNil "life_fnc_util_randomString") throw "Random string function not found";
	private _tempvars = [];
	_tempvars resize (count _rndvars);
	_tempvars params (_rndvars apply {private _ret=[_x,call life_fnc_util_randomString];[format["`%1` => `%2`",_ret#0,_ret#1]]call life_fnc_antihack_systemlog;_ret});
	_tempvars =nil;

	{_detectedstrings pushBackUnique _x} forEach _rndvars;
	_detectedvariables pushBackUnique _rnd_admincode;
	
	//--- Junk Code (Basic TODO: add fake code blocks and more random values)
	private _junkCode =  {
		private _junk = "";
		private _vars = [];
		_vars resize (random [10,80,250]);
		{
		   _junk = _junk + format["
		   %1=%2;",_x, selectRandom [true,false,[],random(999),serverTime]];
		} forEach (_vars apply {call life_fnc_util_randomString});
		_junk
	};

	//--- antihack expression
	private _antihackclient = "
		if(!isNull(missionNamespace getVariable ['"+_rnd_threadtwo+"',scriptNull]))exitWith{};
		if(isFinal '"+_rnd_kickme+"')then{private _log = 'System ran twice, possible hacker'; _log call "+_rnd_kickme+";['HACK',_log] call "+_rnd_logme+";};
		if(isFinal '"+_rnd_banme+"')then{private _log = 'System ran twice, possible hacker'; _log call "+_rnd_banme+";['HACK',_log] call "+_rnd_logme+";};
		"+(call _junkCode)+"
		"+_rnd_useRcon+" = " + str _rconReady + ";
		"+_rnd_admins+" = " +  str _admins +";
		"+(call _junkCode)+"
		waitUntil {!isNull player && {getClientStateNumber >= 8}};
		"+(call _junkCode)+"
		"+_rnd_steamID+" =   getPlayerUID player;
		"+_rnd_netID+" =     netId player;
		"+_rnd_adminlvl+" =  compileFinal ""private _lvl = 0;{if("+_rnd_steamID+" isEqualTo _x#1)exitWith{_lvl = _x#0;}}forEach "+_rnd_admins+";_lvl"";
		"+_rnd_isadmin+" =   (call "+_rnd_adminlvl+") > 0;
		"+_rnd_sendreq+" =   compileFinal """+ _rnd_netVar + " = [_this#0,"+_rnd_steamID+",_this#1];publicVariable '" + _rnd_netVar + "';"";
		"+_rnd_kickme+" =    compileFinal ""if("+_rnd_useRcon +")then{['kick',_this] call "+_rnd_sendreq+";}else{endMission 'END1';};"";
		"+_rnd_banme+" =     compileFinal ""if("+_rnd_useRcon +")then{['ban',_this] call "+_rnd_sendreq+"}else{_this call "+_rnd_kickme+";};"";
		"+_rnd_logme+" =     compileFinal ""['log',['ANTIHACK',_this#0,_this#1]] call "+_rnd_sendreq+";"";
		"+(call _junkCode)+"
		"+_rnd_vehicleclasses+" = "+str _vehicleclasses+";
		"+_rnd_weaponclasses+" = "+str _weaponclasses+";
		"+_rnd_weaponattachments+" = "+str _weaponattachments+";

		"+_rnd_mins2hrsmins+" = compile ""
			private _hours = floor((_this * 60 ) / 60 / 60);
			private _minutes = (((_this * 60 ) / 60 / 60) - _hours);
			if(_minutes == 0)then{_minutes = 0.0001;};
			_minutes = round(_minutes * 60);
			[_hours,_minutes]
		"";
		 
		"+_rnd_codeone+" =  compileFinal ""
			"+(call _junkCode)+"
			if((call "+_rnd_adminlvl+") >= 3)exitWith{diag_log 'Antihack Codeone Active!';};
			"+(call _junkCode)+" 
			";
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
			"+(call _junkCode)+"
			while {true} do {";
				if(_checkmapEH)then{ 
					_antihackclient = _antihackclient + "
						_eh = addMissionEventHandler['MapSingleClick', {}];
						if (_eh > _mapClickEH) then {
							if (_mapClickEH == -1) then {
								_mapClickEH = _eh;
							}else{
								private _log = format['EventHandlers Changed! - %1, should be %2 | MapSingleClick Cheat',_eh,_mapClickEH]; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							};
						};
						removeAllMissionEventHandlers 'MapSingleClick';
					";
				};
				if(_checkterraingrid)then{
					_antihackclient = _antihackclient + " 
						if(getTerrainGrid >= 50) then {
							private _log = format['No Grass! TerrainGrid set to %1 | No Grass Cheat',getTerrainGrid]; 
							_log call "+_rnd_banme+";
							['HACK',_log] call "+_rnd_logme+";
						};
					";
				};
				if(_checkrecoil)then{ 
					_antihackclient = _antihackclient + "
						if(unitRecoilCoefficient player != _recoil)then{
							if(unitRecoilCoefficient player == 0) then {
								private _log = 'Weapon Recoil Disabled! | No Recoil Cheat'; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							}else{
								if(unitRecoilCoefficient player != 1)then{
									private _log = format['Recoil Changed! %1 Should Be  %2 | No Recoil Cheat',unitRecoilCoefficient player,_recoil]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						};
					";
				}; 
				if(_checkspeed)then{ 
					_antihackclient = _antihackclient + "
						_speedCount = 0; 
						if (isNull objectParent player) then {
							_speedCount = if (speed player > 30) then {_speedCount + 1} else {0};
							if (_speedCount > 10) then {
								private _log = format['Moved Too Fast! - Moving at %1 on foot for over 5 seconds | Speed Hack',speed player]; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							};
						}else{
							_speedCount = 0;
						}; 
					";
				}; 
				if(_checkdamage)then{ 
					_antihackclient = _antihackclient + "
						if(!isDamageAllowed player) then { 
							private _log = format['Invincibility! AllowDamage set to %1',isDamageAllowed player]; 
							_log call "+_rnd_banme+";
							['HACK',_log] call "+_rnd_logme+";
						};
					";
				}; 
				if(_checksway)then{ 
					_antihackclient = _antihackclient + "
						if(getCustomAimCoef player != _sway)then{
							if(getCustomAimCoef player == 0) then {
								private _log = 'Weapon Sway Disabled!'; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							}else{
								if(getCustomAimCoef player != 1)then{
									private _log = format['WeaponSway Changed! %1 Should Be %2',getCustomAimCoef player,_sway]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						};
					";
				};
				if(_checkvehicle) then {
					_antihackclient = _antihackclient + "
						if((call "+_rnd_adminlvl+") < 4)then{
							private _vehicle = vehicle player;
							if(_vehicle != player) then {
								private _uuid = _vehicle getVariable ['oUUID',''];
								if(_uuid isEqualTo '' || !(toLower(typeName _vehicle) in "+_rnd_vehicleclasses+")) then {
									[[netId _vehicle],{private _vehicle = objectFromNetId(param[0,'']);deleteVehicle _vehicle;}] remoteExecCall ['call',2];
									private _log = format['Bad vehicle: %1',typeOf _vehicle]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						};
					";
				};
				if(_checkweapon) then {
					_antihackclient = _antihackclient + "
						private _weapon = currentWeapon player;
						if(_weapon isNotEqualTo '')then{
							if !(toLower _weapon in "+_rnd_weaponclasses+") then {
								private _log = format['Bad weapon: %1',_weapon]; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							};
						};
					";
					if(_checkweaponattachments)then{
						_antihackclient = _antihackclient + "
							{
								if(_x isNotEqualTo '')then{
									private _attachments = player weaponAccessories _x;
									if(count _attachments > 0)then{
										{
											private _attachment = _x;
											if(_attachment isNotEqualTo '')then{
												if !(toLower _attachment in "+_rnd_weaponattachments+") then {
													private _log = format['Bad weapon attachment: %1',_x]; 
													_log call "+_rnd_banme+";
													['HACK',_log] call "+_rnd_logme+";
												};	
											};
										}forEach _attachments;
									};
								};
							} forEach [primaryWeapon player,secondaryWeapon player,handgunWeapon player];
						";
					};
				};
				_antihackclient = _antihackclient + "
				uiSleep random[0.5,1,1.5];
			};
		"";";

		if(_interuptinfo)then{
			_antihackclient = _antihackclient + "
				"+_rnd_codetwo+" = compileFinal ""
					if("+_rnd_isadmin+")then{diag_log 'Antihack Codetwo Active!'};
					"+(call _junkCode)+"

					while{true}do{
						waitUntil{!(isNull (findDisplay 49))};
						private _text = '';";
						_antihackclient = _antihackclient + "
						waitUntil{ 
							private _RestartTime = life_var_rcon_RestartTime;
							private _players = count(allPlayers - entities 'HeadlessClient_F');
							private _text = format['%1 Life AntiCheat | Total Players Online (%3/%4) | Guid: (%2)',worldName,call(player getVariable ['BEGUID',{''}]), _players,((playableSlotsNumber west) + (playableSlotsNumber independent) + (playableSlotsNumber civilian)  + (playableSlotsNumber east) + 1)];";
							if(_rconReady)then
							{ 
								_antihackclient = _antihackclient + " 
									if(_RestartTime > 0)then{
										private _timeRestart = _RestartTime call "+_rnd_mins2hrsmins+";  
										if((_timeRestart#0) > 0)then{
											_text = format['%1 | Server Restart In: %2h %3mins',_text,_timeRestart#0,_timeRestart#1];
										}else{
											_text = format['%1 | Server Restart In: %2mins',_text,_timeRestart#1];
										};
									};
								";
							};
							_antihackclient = _antihackclient + "
							((findDisplay 49) displayCtrl 120) ctrlSetText _text;
							isNull (findDisplay 49) || (life_var_rcon_RestartTime isNotEqualTo _RestartTime) || (_players isNotEqualTo count(allPlayers - entities 'HeadlessClient_F'))
						};
					};
				"";
			";
		};

		_antihackclient = _antihackclient + "

		"+_rnd_threadone+" = [] spawn 
		{
			if((call "+_rnd_adminlvl+") >= 5)exitWith{diag_log 'Antihack Thread#1 Active!';};
			"+(call _junkCode)+"";

			if(_checkdetectedmenus)then{
				_antihackclient = _antihackclient + "
					terminate (missionNamespace getVariable ['"+_rnd_threadtwo_one+"',scriptNull]);
					"+_rnd_threadtwo_one+" = [] spawn{
						waitUntil{(!isNull (findDisplay 49)) && (!isNull (findDisplay 602))};  
						(findDisplay 49) closeDisplay 2; (findDisplay 602) closeDisplay 2;
						private _log = 'Opened Esacpe & Inventory Menus | Possible Inventory Glitch'; 
						_log call "+_rnd_kickme+";
						['HACK',_log] call "+_rnd_logme+";
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
									private _log = format['Bad Vehicle Weapons: (%1) Should have: (%2)',_hasWeps,_vehWeps]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						}; 
					";
				};
				if(_checkmemoryhack)then{
					_antihackclient = _antihackclient + "
						{
							private _currentHM = "+str _memoryhacks_client+"#_forEachIndex;
							private _clientHM = toArray(call compile (_currentHM#0));
							if(_clientHM isNotEqualTo _x)then{
								private _log = format['Memoryhack %1 %2 changed: %3, %4', _currentHM#1, _currentHM#2, toString _clientHM, toString _x]; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							};
						} forEach "+str _memoryhacks_server+";
					";
				};
				_antihackclient = _antihackclient + "
				uiSleep (random [1,2,5]);
			};
		};

		"+_rnd_threadtwo+" = [] spawn 
		{
			if("+_rnd_isadmin+")then{diag_log 'Antihack Thread#2 Active!'};
			"+(call _junkCode)+"

			terminate (missionNamespace getVariable ['"+_rnd_threadinterupt+"',scriptNull]);
			"+_rnd_ahvar+" = ['"+_rnd_playersvar+"',"+_rnd_netID+", ['"+_rnd_threadtwo_two+"',"+_rnd_codeone+"]];";
			
			if(_checklanguage)then{ 
				_antihackclient = _antihackclient + "
					"+(call _junkCode)+"
					if !("+_rnd_isadmin+")then{
						if (toLower(language) isNotEqualTo toLower("+_serverlanguage+"))then{ 
							_log = format['Bad Language! %1 Is Not Allowed',language];
							_log call "+_rnd_kickme+";
							['KICK',_log] call "+_rnd_logme+";
						};
					};
				";
			};
			if(_checknamebadchars)then{
				_antihackclient = _antihackclient + "
					"+(call _junkCode)+"
					if !("+_rnd_isadmin+")then{
						_chars = [];
						_lang =	 toLower(language);
						_badchar = false;
						"+(call _junkCode)+"
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
						"+(call _junkCode)+"
						{if([_x, profileName,false]call BIS_fnc_inString)exitWith{_badchar = true;}}foreach _chars;
						if(_badchar)then{
							private _log = format['Bad Name! Char: %1 Is Not Allowed',_x];
							_log call "+_rnd_kickme+";
							['KICK',_log] call "+_rnd_logme+";
						};
					};
				";
			};
			if(_checknameblacklist)then{
				_antihackclient = _antihackclient + "
					"+(call _junkCode)+"
						if !("+_rnd_isadmin+")then{
						{
							if([profileName, _x] call BIS_fnc_inString)exitWith{
								private _log = format['Bad Name! %1 Is Not Allowed',_x];
								_log call "+_rnd_kickme+";
								['KICK',_log] call "+_rnd_logme+";
							};
						}forEach "+str _nameblacklist+";
					};
				";
			};
			if(_checkdetectedmenus)then{
				_antihackclient = _antihackclient + "
					if((call "+_rnd_adminlvl+") < 6)then{
						{
							_x spawn {
								waitUntil{!isNull (findDisplay _this)};
								private _log = format['Bad Menu: %1',_this];
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							};
						}forEach " + str _detectedmenus + ";
					};
				";
			};
			if(_checkdetectedvariables)then{
				_antihackclient = _antihackclient + "
					if((call "+_rnd_adminlvl+") < 1)then{
						{
							_x spawn {
								waitUntil{!isNil _this};
								private _log = format['Bad Var: %1',_this]; 
								_log call "+_rnd_banme+";
								['HACK',_log] call "+_rnd_logme+";
							};
						} forEach "+str _detectedvariables+";
					};
				";
			};
			if(_checkteleport)then{
				_antihackclient = _antihackclient + "
					[]spawn{
						if ("+_rnd_isadmin+")exitWith{};
						while {true} do {
							private _checkTime = 5;
							private _oldVehicle = vehicle player;
							private _oldPos = getPosATL _oldVehicle;

							uiSleep _checkTime;

							private _newVehicle = vehicle player;
							private _newPos = getPosATL _newVehicle;
							if(_oldVehicle isEqualTo _newVehicle) then {
								private _maxSpeed = (30 / 3.6);
								if(_newVehicle != player) then {
									private _topSpeed = getNumber(configfile >> 'CfgVehicles' >> typeOf _newVehicle >> 'maxSpeed');
									_maxSpeed = ((_topSpeed / 3.6) * 1.5);
								};

								private _distance = _oldPos distance _newPos;

								if((_distance > _maxSpeed * _checkTime) && life_is_alive && (player == (driver _newVehicle)) && local _newVehicle) then {
									if!(player getVariable ['life_var_teleported',false]) then {
										private _log = format['Player teleported: moved %1 meters, in %2 seconds! (Max Allowed Speed: %3)',_distance,_checkTime,_maxSpeed]; 
										_log call "+_rnd_banme+";
										['HACK',_log] call "+_rnd_logme+";
									};
								};
							};
						};
					};
				";
			};

			_antihackclient = _antihackclient + "
			systemChat 'Antihack loading!';
			"+_rnd_sysvar+" = "+_rnd_ahvar+";
			"+(call _junkCode)+"
			publicVariable '"+_rnd_sysvar+"';
			waitUntil {isNil {missionNamespace getVariable '"+_rnd_sysvar+"'}};
			[] spawn {
				if((call "+_rnd_adminlvl+") <= 0)exitWith{};
				"+(call _junkCode)+"
				waitUntil{!isNil '"+_rnd_admincode+"'};
				["+_rnd_steamID+"] spawn "+_rnd_admincode+";
			};
			"+(call _junkCode)+"
			"+_rnd_ahvar+" = random(99999);
			"+(call _junkCode)+"

			while {true} do 
			{
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
						private _log = '`_rnd_ahvar` nil';
						_log call "+_rnd_banme+";
						['HACK',_log] call "+_rnd_logme+";
					};
				uiSleep 2;
			};
		};

		"+_rnd_threadthree+" = []spawn 
		{ 
			if("+_rnd_isadmin+")exitwith{diag_log 'Antihack Thread#2 Active!'};
			"+(call _junkCode)+"
			
			{
				_x spawn {
					"+(call _junkCode)+"
					while {true} do {
						private _display = displayNull;
						waitUntil{
							_display = findDisplay _this;
							!isNull _display
						};
						systemChat format['%1 Life AntiCheat: %2 has been closed.',worldName,str _display];
						['HACK',format['%1 has been closed.',str _display]] call "+_rnd_logme+";
						_display closeDisplay 0;
						closeDialog 0;closeDialog 0;closeDialog 0;
					};
				};	
			}forEach "+str _badmenus+";

			while {true} do {
				waitUntil{!isNull findDisplay 24 && !isNull findDisplay 49};
				private _dynamicText = uiNamespace getvariable ['BIS_dynamicText',displayNull];
				if(!isNull _dynamicText)then {
					private _ctrl = _dynamicText displayctrl 9999;
					private _ctrltext = ctrlText _ctrl;
					if(_ctrltext isNotEqualTo '')then {
						private _log = true;
						{
							if((toLower _ctrltext) find _x > -1)then {
								private _logmsg = format['Hackmenu found: %1 on %2 %3 - %4',_x,ctrlIDD _dynamicText,ctrlIDC _ctrl,_ctrltext]; 
								_logmsg call "+_rnd_banme+";
								['HACK',_logmsg] call "+_rnd_logme+";
								_log = false;
							};
						} forEach "+str _detectedstrings+";
						if(_log)then {
							['INFO',format['Possible Hackmenu found on CTRL: [%1] - TEXT: [%2]',_ctrl, _ctrltext]] call "+_rnd_logme+";
						};
					};
					(findDisplay 24) closeDisplay 0;
					(findDisplay 49) closeDisplay 0;
				};
				uiSleep 2;
			};
		};

		"+_rnd_threadfour+" = []spawn
		{
			if((call "+_rnd_adminlvl+") >= 3)exitWith{diag_log 'Antihack Thread#4 Active!';}; 
			private _detectedstrings = "+str _detectedstrings+"; 
			private _inittime = diag_tickTime;
			"+(call _junkCode)+"

			while {true} do {
				private _uptime = round((diag_tickTime - _inittime) / 60);
				if(_uptime > 0)then{
					{ 
						private _display = _x;  
						if(!isNull _display)then
						{
							{
								if(!isNull (_display displayCtrl _x))then {
									private _log = format['MenuBasedHack: %1 - %2',_display,_x]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							} forEach [16030,13163,989187,16100];
							
							{
								private _control = _x;
								if(_uptime mod 1 isEqualTo 0)then{
									private _controltype = ctrlType _control;
									if(_controltype isEqualTo 5)then {
										_size = lbSize _control;
										if(_size > 0)then {
											for '_i' from 0 to (_size-1) do {
												private _lbtxt = _control lbText _i;
												private _txtfilter = toArray _lbtxt;
												_txtfilter = _txtfilter - [94];
												_txtfilter = _txtfilter - [96];
												_txtfilter = _txtfilter - [180];
												private _lowerlbtxt = toLower(toString _txtfilter);
												{
													if(_lowerlbtxt find _x > -1)then {
														private _log = format['BadlbText: %1 FOUND [%2] ON %3 %4',_lbtxt,_x,_display,_control]; 
														_log call "+_rnd_banme+";
														['HACK',_log] call "+_rnd_logme+";
													};
												} forEach _detectedstrings;
											};
										};
									} else {
										if(_controltype isEqualTo 12)then
										{
											private _tvtxt = _control tvText (tvCurSel _control);
											private _txtfilter = toArray _tvtxt;
											_txtfilter = _txtfilter - [94];
											_txtfilter = _txtfilter - [96];
											_txtfilter = _txtfilter - [180];
											private _lowertvtxt = toLower(toString _txtfilter);
											{
												if(_lowertvtxt find _x > -1)then { 
													private _log = format['BadtvText: %1 FOUND [%2] ON %3 %4',_tvtxt,_x,_display,_control]; 
													_log call "+_rnd_banme+";
													['HACK',_log] call "+_rnd_logme+";
												};
											} forEach _detectedstrings;
										} else {
											if!(_controltype in [3,4,8,9,15,42,81,101,102])then{
												private _ctrlTxt = ctrlText _control;
												private _txtfilter = toArray _ctrlTxt;
												_txtfilter = _txtfilter - [94];
												_txtfilter = _txtfilter - [96];
												_txtfilter = _txtfilter - [180];
												private _lowerctrlTxt = toLower(toString _txtfilter);
												{
													if(_lowerctrlTxt find _x > -1)then {
														private _log = format['BadCtrlText: %1 FOUND [%2] ON %3 %4',_ctrlTxt,_x,_display,_control]; 
														_log call "+_rnd_banme+";
														['HACK',_log] call "+_rnd_logme+";
													};
												} forEach _detectedstrings;
											};
										};
									};
								};
							} forEach (allControls _display);
						}; 
					} forEach allDisplays;
					
					uiSleep 3;
				}else{
					uiSleep 15;
				};
			};	
		};
		
		"+_rnd_threadfive+" = []spawn
		{
			if((call "+_rnd_adminlvl+") >= 4)exitWith{diag_log 'Antihack Thread#5 Active!';};
			while {true} do {";
				if(_checkgear)then{
					if(_checkuniform)then{
						_antihackclient = _antihackclient + "
							private _uniform = uniform player;
							if(_uniform isNotEqualTo '')then{
								if !(toLower(_uniform) in "+str _uniformclasses+")then{
									private _log = format['Gearhack Bad Uniform: `%1` in not allowed',_uniform]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						";
					};
					if(_checkheadgear)then{
						_antihackclient = _antihackclient + "
							private _headgear = headgear player;
							if(_headgear isNotEqualTo '')then{
								if !(toLower(_headgear) in "+str _headgearclasses+")then{
									private _log = format['Gearhack Bad Headgear: `%1` in not allowed',_headgear]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						";
					};
					if(_checkgoggles)then{
						_antihackclient = _antihackclient + "
							private _goggles = goggles player;
							if(_goggles isNotEqualTo '')then{
								if !(toLower(_goggles) in "+str _gogglesclasses+")then{
									private _log = format['Gearhack Bad Goggles: `%1` in not allowed',_goggles]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+";
								};
							};
						";
					};
					if(_checkvests)then{
						_antihackclient = _antihackclient + "
							private _vest = vest player;
							if (_vest isNotEqualTo '')then{
								if !(toLower(_vest) in "+str _vestclasses+")then{
									private _log = format['Gearhack Bad Vest: `%1` in not allowed',_vest]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+"; 
								};
							};
						";
					};
					if(_checkbackpacks)then{
						_antihackclient = _antihackclient + "
							private _backpack = backpack player;
							if(_backpack isNotEqualTo '')then{
								if !(toLower(_backpack) in "+str _backpacksclasses+")then{
									private _log = format['Gearhack Bad Backpack: `%1` in not allowed',_backpack]; 
									_log call "+_rnd_banme+";
									['HACK',_log] call "+_rnd_logme+"; 
								};
							};
						";
					};
				};
				_antihackclient = _antihackclient + "
				uiSleep 3;
			};
		};
		
		"+(call _junkCode)+"
		waitUntil{isNull(missionNamespace getVariable ['"+_rnd_threadtwo+"',scriptNull])};
		private _log = 'Main thread terminated, possible hacker';
		_log call "+_rnd_kickme+";
		['HACK',_log] call "+_rnd_logme+";
	";
	
	//--- something broke with antihackclient expression
	if(isNil "_antihackclient")throw "Failed to load antihack";

	//--- setup network thread
	_antihackclient = [_antihackclient,_rnd_netVar,_rnd_sysvar,_rnd_hcvar] spawn life_fnc_antihack_setupNetwork;
	
	//--- something broke with thread
	if(isNull _antihackclient)throw "Failed to load antihack network";

	life_var_antihack_loaded = true;
	_antihackclient = nil;

	[_admins,_rconReady,_rnd_netVar,_rnd_admincode]spawn life_fnc_admin_initialize;
}catch {
	[format["Exception: %1",_exception]] call life_fnc_antihack_systemlog;
	
	life_var_antihack_loaded = false;
};

if(life_var_antihack_loaded)then{
	["System fully initialized!"] call life_fnc_antihack_systemlog;
};

life_var_antihack_loaded