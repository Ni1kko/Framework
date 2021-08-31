/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false}; 
if(missionNamespace getVariable ["life_var_admin_loaded",false])exitwith{false};
if(isRemoteExecuted AND life_var_rcon_passwordOK)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_admin_initialize.sqf`"] call life_fnc_rcon_ban;};
params ['_admins','_rconReady','_rnd_netVar','_rnd_admincode'];
 
["Starting Serveside Code!"] call life_fnc_admin_systemlog;

life_var_admin_loaded = false;

try {
	private _config = (configFile >> "CfgAdmin"); 
	 
	//--- Get Config
	if(!isClass _config) throw "Config not found";

	//--- random vars ref
	private _rndvars = [
		"_rnd_useRcon",
		"_rnd_isadmin",
		"_rnd_admins",
		"_rnd_adminlvl",
		"_rnd_getadminlvl",
		"_rnd_steamID",
		"_rnd_BEGuid",
		"_rnd_netID",
		"_rnd_runserver",
		"_rnd_runglobal",
		"_rnd_runtarget",
		"_rnd_sendreq",
		"_rnd_sendreqtarget",
		"_rnd_playerconnected",
		"_rnd_playerdisconnected",
		"_rnd_adminconnected",
		"_rnd_admindisconnected",
		"_rnd_kick",
		"_rnd_ban",
		"_rnd_log",
		"_rnd_init",
		"_rnd_openmenu",
		"_rnd_adminmenuDBLclick",
		"_rnd_adminmenuDBLclickObjs",
		"_rnd_adminmenu_updateobjlist",
		"_rnd_adminmenu_listCtrl",
		"_rnd_adminmenufunctions",
		"_rnd_titlecolor",
		"_rnd_notogglecolor",
		"_rnd_toggleoncolor",
		"_rnd_toggleoffcolor",
		"_rnd_playermenutoggle",
		"_rnd_godmodetoggle",
		"_rnd_vehiclemenutoggle",
		"_rnd_weaponmenutoggle",
		"_rnd_cratemenutoggle",
		"_rnd_adminmenu_cratebuttons",
		"_rnd_adminmenugetfunctions",
		"_rnd_adminmenu_getselectedtarget",
		"_rnd_hacklogtoggle",
		"_rnd_maptoggle",
		"_rnd_norecoiltoggle",
		"_rnd_infinteammotoggle",
		"_rnd_fastfiretoggle",
		"_rnd_nograsstoggle",
		"_rnd_maptptoggle",
		"_rnd_playericonstoggle",
		"_rnd_renderbonestoggle",
		"_rnd_vehicleiconstoggle",
		"_rnd_playermarkerstoggle",
		"_rnd_vehiclemarkerstoggle",
		"_rnd_invisibilitytoggle",
		"_rnd_vehgod_toggle",
		"_rnd_vehboost_toggle",
		"_rnd_aimarkerstoggle",
		"_rnd_drawmarkers",
		"_rnd_drawmarkers_evh",
		"_rnd_drawicons",
		"_rnd_drawicons_evh",
		"_rnd_mapsingleclick"
	];

	//--- create random vars
	if(isNil "life_fnc_util_randomString") throw "Random string function not found";
	private _tempvars = [];
	_tempvars resize (count _rndvars);
	_tempvars params (_rndvars apply {private _ret=[_x,call life_fnc_util_randomString];[format["`%1` => `%2`",_ret#0,_ret#1]]call life_fnc_admin_systemlog;_ret});
	_tempvars =nil;
	
	private _adminclient = "
		params ['_steamID'];
		"+_rnd_useRcon+" = " + str _rconReady + ";
 
		waitUntil {!isNull player && {getClientStateNumber >= 8}};
		
		"+_rnd_steamID+" =   	getPlayerUID player;
		"+_rnd_netID+" =     	netId player;
		"+_rnd_admins+" = 		compileFinal str("+str _admins+");
		"+_rnd_getadminlvl+" =  compileFinal ""private _lvl = 0;{if(_this isEqualTo _x#1 || _this isEqualTo _x#2)exitWith{_lvl = _x#0;}}forEach (call "+_rnd_admins+");_lvl"";
		"+_rnd_adminlvl+" =     "+_rnd_steamID+" call "+_rnd_getadminlvl+";
		"+_rnd_isadmin+" =      "+_rnd_adminlvl+" > 0;
		"+_rnd_sendreqtarget+" = compileFinal """+ _rnd_netVar + " = _this;publicVariable '" + _rnd_netVar + "';"";
		"+_rnd_sendreq+" =   	 compileFinal ""[_this#0,"+_rnd_steamID+",_this#1] call "+_rnd_sendreqtarget+";"";
		"+_rnd_runserver+" = 	 compileFinal ""['run-server',[_this#1,_this#0]] call "+_rnd_sendreq+";"";
		"+_rnd_runglobal+" = 	 compileFinal ""['run-global',[_this#1,_this#0]] call "+_rnd_sendreq+";"";
		"+_rnd_runtarget+" = 	 compileFinal ""['run-target',[_this#0,_this#2,_this#1]] call "+_rnd_sendreq+";"";
		"+_rnd_kick+" =    		 compileFinal ""if("+_rnd_useRcon +")then{['kick',_this#0,_this#1] call "+_rnd_sendreqtarget+";}else{endMission 'END1';};"";
		"+_rnd_ban+" =     		 compileFinal ""if("+_rnd_useRcon +")then{['ban',_this#0,_this#1] call "+_rnd_sendreqtarget+";}else{_this call "+_rnd_kick+";};"";
		"+_rnd_log+" =     		 compileFinal ""['log',_this] call "+_rnd_sendreq+";"";

		if(_steamID isNotEqualTo "+_rnd_steamID+" || '' in [_steamID,"+_rnd_steamID+"])exitWith{
			['kick','Error steamID mismatch, Possible hacker'] call "+_rnd_sendreq+";
			['log',['AUTH',format['Error steamID %1 should be %2, Attempted loading admin main code',_steamID,"+_rnd_steamID+"]]] call "+_rnd_sendreq+";
		};
		if!("+_rnd_isadmin+")exitWith{
			['kick','Error no admin lvl, Possible hacker'] call "+_rnd_sendreq+";
			['log',['AUTH','Error Admin level 0, Attempted loading admin main code']] call "+_rnd_sendreq+";
		};
		
		"+_rnd_titlecolor+" = [0.8,0.86,0.22,1];
		"+_rnd_notogglecolor+" = [1,1,1,1];
		"+_rnd_toggleoncolor+" = [0.29,0.68,0.31,1];
		"+_rnd_toggleoffcolor+" = [0,0.47,0.41,1];
		"+_rnd_playermenutoggle+" = false;
		"+_rnd_godmodetoggle+" = false;
		"+_rnd_vehiclemenutoggle+" = false;
		"+_rnd_weaponmenutoggle+" = false;
		"+_rnd_cratemenutoggle+" = false;
		"+_rnd_hacklogtoggle+" = false;
		"+_rnd_maptoggle+" = false;
		"+_rnd_maptptoggle+" = false;
		"+_rnd_playericonstoggle+" = false;
		"+_rnd_renderbonestoggle+" = false;
		"+_rnd_vehicleiconstoggle+" = false;
		"+_rnd_playermarkerstoggle+" = false;
		"+_rnd_vehiclemarkerstoggle+" = false;
		"+_rnd_aimarkerstoggle+" = false;
		"+_rnd_mapsingleclick+" = 'if(_alt && "+_rnd_maptptoggle+") then {(vehicle player) setpos _pos;};';

		"+_rnd_drawmarkers+" = compileFinal ""
			disableserialization;
			params['_ctrl'];
			
			if("+_rnd_playermarkerstoggle+") then {
				{
					_ctrl drawIcon ['iconMan',[1,0,1,1],getPos _x,24,24,getDir _x,name _x,1,0.03,'TahomaB','right'];
				} count allPlayers;
			};
			if("+_rnd_vehiclemarkerstoggle+") then {
				{
					if(_x isKindOf 'LandVehicle' || _x isKindOf 'Air' || _x isKindOf 'Ship') then {
						_ctrl drawIcon [getText(configFile >> 'CfgVehicles' >> typeof _x >> 'icon'),[1,1,1,1],getPos _x,24,24,getDir _x,getText(configFile >> 'CfgVehicles' >> typeof _x >> 'DisplayName'),1,0.03,'TahomaB','right'];
					};
				} count vehicles;
			};
			if("+_rnd_aimarkerstoggle+") then {
				{
					_ctrl drawIcon ['iconMan',[1,1,0,1],getPos _x,24,24,getDir _x,'AI',1,0.03,'TahomaB','right'];
				} count (allUnits-AllPlayers);
			};
		"";
		"+_rnd_drawicons+" = compileFinal ""
			private _render_points = [
				['spine3','rightshoulder'],
				['spine3','leftshoulder'],
				['pelvis','spine3'],
				['leftupleg','pelvis'],
				['rightupleg','pelvis'],
				['leftleg','leftupleg'],
				['rightleg','rightupleg'],
				['leftfoot','leftleg'],
				['rightfoot','rightleg'],
				['rightarm','rightshoulder'],
				['leftarm','leftshoulder'],
				['lefthand','leftarm'],
				['righthand','rightarm']
			];
			private _get_color = {
				params['_entity'];
				private['_return','_visibility'];
				_pos = (getposasl _entity) vectorAdd [0,0,1];
				if(_entity isKindOf 'Man') then {
					_pos = eyepos _entity;
				};
				_visibility = [_entity, 'VIEW',player] checkVisibility [eyePos player,_pos];
				
				_return = [0.77,0.11,0.11,1];
				if(_visibility > 0.8) then {
					_return = [0.11,0.77,0.11,1];
				};
				_return;
			};
			private _draw_icon = {
				params['_posAGL1','_text',['_color',[1,1,1,1]]];
				
				_scaleSub = (_x distance player)/(getObjectViewDistance select 0);
				
				
				_pos1 = _posAGL1 vectorAdd [0,0,0.5];
				
				drawIcon3D [
					'#(argb,8,8,3)color(0,0,0,0)',
					_color,
					_pos1,
					1,
					1,
					0,
					_text,
					0,
					0.035 - (0.03*_scaleSub),
					'EtelkaMonospaceProBold',
					'Center'
				];
			};
			private_draw_line = {
				params['_posAGL1','_posAGL2',['_color',[1,1,1,1]]];
				private['_sPos1','_sPos2','_pos1','_pos2','_icon'];
				_sPos1 = worldToScreen _posAGL1;
				_sPos2 = worldToScreen _posAGL2;
				
				if(count(_sPos1) == 0) exitWith {};
				if(count(_sPos2) == 0) exitWith {};

				_pos1 = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld _sPos1;
				_pos2 = ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld _sPos2;
				
				((findDisplay 12) displayCtrl 51) drawLine [_pos1,_pos2,_color];
				
				_icon = getText(configFile >> 'CfgVehicles' >> typeof player >> 'Icon');
				((findDisplay 12) displayCtrl 51) drawIcon [
					_icon,
					_color,
					_pos1,
					1,
					1,
					0,
					'.',
					0,
					0.01,
					'TahomaB',
					'Center'
				];
				((findDisplay 12) displayCtrl 51) drawIcon [
					_icon,
					_color,
					_pos2,
					1,
					1,
					0,
					'.',
					0,
					0.01,
					'TahomaB',
					'Center'
				];
			};
			if("+_rnd_vehicleiconstoggle+") then {
				{
					if(_x distance player < ((getObjectViewDistance select 0))) then {
						_color = [_x] call _get_color;
						[ASLtoAGL eyepos _x,name _x,_color] call _draw_icon;
						if("+_rnd_renderbonestoggle+") then {
							_target = _x;
							{
								_i1 = _x select 0;
								_i2 = _x select 1;
								
								_model1 = _target selectionPosition _i1;
								_model2 = _target selectionPosition _i2;
								
								_w1 = _target modelToWorld _model1;
								_w2 = _target modelToWorld _model2;
								
								[_w1,_w2,_color] call _draw_line;
								
								true
							} count _render_points;
							
							
							_model1 = _target selectionPosition 'spine3';
							
							_w1 = _target modelToWorld _model1;
							_w2 = ASLtoAGL eyepos _target;
							
							[_w1,_w2,_color] call _draw_line;
						};
					};
				} forEach allPlayers;
			};
			if("+_rnd_vehicleiconstoggle+") then {
				{
					if(_x distance player < ((getObjectViewDistance select 0))) then {
						_color = [_x] call _get_color;
						[(ASLtoAGL getposasl _x) vectorAdd [0,0,1],getText(configFile >> 'CfgVehicles' >> typeof _x >> 'DisplayName'),_color] call _draw_icon;
					};
				} forEach vehicles;
			};
		"";
		"+_rnd_adminmenu_getselectedtarget+" = compileFinal ""
			disableserialization;
			private _display = findDisplay 1776;
			private _ctrl = _display displayctrl 1778;
			private _sel = lbCurSel _ctrl;
			if(_sel < 0) exitWith {objNull};
			private _uid = _ctrl lbData _sel;
			private _target = objNull;
			{
				if(getplayeruid _x == _uid) exitWith {_target = _x;};
			} forEach allPlayers;
			_target;
		"";
		"+_rnd_adminmenugetfunctions+" = compileFinal ""
			private _godmode = {
				systemChat 'test';
			};
			private _infammo = { 
				if("+_rnd_infinteammotoggle+") then {
					while{"+_rnd_infinteammotoggle+"} do {
						(vehicle player) setVehicleAmmo 1;
						UiSleep 0.1;
					};
				};
			};
			private _norecoil = {
				params['_toggle'];
				_recoil = unitRecoilCoefficient player;
				_sway = getCustomAimCoef player; 
				player setUnitRecoilCoefficient (if(_toggle) then {life_var_OldRecoil = _recoil;0} else {life_var_OldRecoil});
				player setCustomAimCoef (if(_toggle) then {life_var_OldSway = _sway;0} else {life_var_OldSway});
			};
			private _fastfire = {
				if("+_rnd_fastfiretoggle+") then {
					while{"+_rnd_fastfiretoggle+"} do {
						(vehicle player) setWeaponReloadingTime [gunner (vehicle player), currentMuzzle (gunner (vehicle player)), 0];
						UiSleep 0.001;
					};
				};
			};
			private _nograss = {
				params['_toggle'];
				setTerrainGrid (if(_toggle) then {50} else {25});
			};
			private _arsenal = {
				closeDialog 0;
				['Open',true] spawn bis_fnc_arsenal;
			};
			private _heal = {
				resetCamShake; 
				player setDamage 0; 
			};
			private _repaircurs = {
				cursorTarget setDamage 0;
			};
			private	_deletecurs = {
				private _object = cursorTarget;
				[{
					params['_object']; 
					deleteVehicle _object;
				},[_object]] call "+_rnd_runserver+";
			};
			private _vehgod = {
				if("+_rnd_vehgod_toggle+") then {
					while{"+_rnd_vehgod_toggle+"} do {
						waitUntil{vehicle player != player || !"+_rnd_vehgod_toggle+"};
						_veh = vehicle player;
						_veh allowDamage false;
						waitUntil{vehicle player == player || !"+_rnd_vehgod_toggle+"};
						_veh allowDamage true;
					};
				};
			};
			private _vehboost = {
				if("+_rnd_vehboost_toggle+") then {
					while{"+_rnd_vehboost_toggle+"} do {
						if(vehicle player != player) then {
							if(inputAction 'carFastForward' > 0) then {
								_veh = velocity (vehicle player);
								_veh = _veh vectorAdd (vectorNormalized _veh);
								(vehicle player) setVelocity _veh;
							};
						};
						uiSleep 0.1;
					};
				};
			};
			private _vehrepair = {
				if(vehicle player != player) then {vehicle player setDamage 0;};
			};
			private _invisible = {
				params['_toggle'];
				[{
					params['_unit','_toggle'];
					_unit hideObjectGlobal _toggle;
				},[player,_toggle]] call "+_rnd_runserver+";
			};
			private _freecam = {
				closeDialog 0;
				call BIS_fnc_Camera;
			};
			private _healtarg = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					resetCamShake;
					player setDamage 0;
				}] call "+_rnd_runtarget+";
			};
			private _repairtarg = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					if(vehicle player != player) then {vehicle player setDamage 0;};
				}] call "+_rnd_runtarget+";
			};
			private _viewSteamInfo = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				private _uid = (getplayeruid _target);
				if!(isNil '_uid') then {
					private _name = (name _target);
					if!(isNil '_name') then {
						hint format ['%1`s UID: %2 \n---------------------------------------------------',_name,_uid];
					} else {
						hint format ['UID: %1 \n---------------------------------------------------',_uid];
					};
				};
			};
			private _viewinventory = {
				_target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				closeDialog 0;
				createGearDialog [_target,'RscDisplayInventory'];
			};
			private _toggle_vehicleMenu = {
				disableserialization;
				params['_toggle'];
				private _display = findDisplay 1776;
				private _objs = _display displayctrl 1780; 
				private _mainList = _display displayCtrl 1776;
				
				lbClear _objs;
				if(_toggle) then {
					[_objs,0] call "+_rnd_adminmenu_updateobjlist+";
					if(ctrlShown _objs) then {
						Weapon_Menu_Toggle = false;
						Crate_Menu_Toggle = false;
						for '_i' from 0 to (lbSize _mainList)-1 do {
							_index = _mainList lbData _i;
							if(_index != '') then {
								_j = parseNumber _index;
								_funcData = "+_rnd_adminmenufunctions+" select _j;
								_text = _funcData select 0;
								if(_text == 'Weapon Menu' || _text == 'Supply Crate(s)') then {
									_mainList lbSetColor [_i,"+_rnd_toggleoffcolor+"];
								};
							};
						};
					} else {
						_objs ctrlShow true;
					};
				} else {
					_objs ctrlShow false;
				};
			};
			private _toggle_map = {
				disableserialization;
				params['_toggle'];
				((findDisplay 1776) displayCtrl 1779) ctrlShow _toggle;
			};
			private _toggle_logs = {
				disableserialization;
				params['_toggle'];
				((findDisplay 1776) displayCtrl 1781) ctrlShow _toggle;
			};
			private _toggle_players = {
				disableserialization;
				params['_toggle'];
				((findDisplay 1776) displayCtrl 1778) ctrlShow _toggle;
			};
			"+_rnd_adminmenufunctions+" = [
				['- Main',0],
					['God Mode',1,_godmode,'"+_rnd_godmodetoggle+"'],
					['Infinite Ammo',1,_infammo,'"+_rnd_infinteammotoggle+"'],
					['No Recoil / No Sway',1,_norecoil,'"+_rnd_norecoiltoggle+"'],
					['Fast Fire',1,_fastfire,'"+_rnd_fastfiretoggle+"'],
					['No Grass',1,_nograss,'"+_rnd_nograsstoggle+"'], 
					['Arsenal',2,_arsenal],
					['Heal',2,_heal],
					['Repair Cursor',2,_repaircurs],
					['Delete Cursor',2,_deletecurs],

				['- Players',0],
					['Show Players',1,_toggle_players,'"+_rnd_playermenutoggle+"'],
					['Repair',2,_repairtarg],
					['Heal',2,_healtarg],

				['- Vehicles',0],
					['God Mode',1,_vehgod,'"+_rnd_vehgod_toggle+"'],
					['Boost',1,_vehboost,'"+_rnd_vehboost_toggle+"'],
					['Repair',2,_vehrepair],

				['- Spawning',0],
					['Vehicle Menu',1,_toggle_vehicleMenu,'"+_rnd_vehiclemenutoggle+"'],

				['- Icons',0],
					['Player Icons',1,{},'"+_rnd_playericonstoggle+"'],
					['Vehicle Icons',1,{},'"+_rnd_vehicleiconstoggle+"'], 
					['Render Bones',1,{},'"+_rnd_renderbonestoggle+"'],

				['- Map',0],
					['Show Map',1,_toggle_map,'"+_rnd_maptoggle+"'],
					['Alt+Click TP',1,{},'"+_rnd_maptptoggle+"'],
					['Player Markers',1,{},'"+_rnd_playermarkerstoggle+"'],
					['Vehicle Markers',1,{},'"+_rnd_vehiclemarkerstoggle+"'], 
					['AI Markers',1,{},'"+_rnd_aimarkerstoggle+"'],

				['- Recon',0],
					['Invisibility',1,_invisible,'"+_rnd_invisibilitytoggle+"'],
					['FreeCam',2,_freecam],
					['View Steam Info',2,_viewSteamInfo],
					['View Inventory',2,_viewinventory],
					['Show Logs',1,_toggle_logs,'"+_rnd_hacklogtoggle+"'],

				

				[format['%1 Admin Menu By: Lystic & Ni1kko',worldName],0]
			];
		"";
		"+_rnd_adminmenuDBLclick+" = compileFinal ""
			disableserialization;
			params['_ctrl','_lbIndex'];
			_data = _ctrl lbData _lbIndex;
			if(_data == '') exitWith {};
			_index = parseNumber(_data);
			_funcData = "+_rnd_adminmenufunctions+" select _index;
			_type = _funcData select 1;
			if(_type != 1 && _type != 2) exitWith {};
			_code = _funcData select 2;
			if(_type == 1) then {
				_toggleVar = _funcData select 3;
				_value = missionNamespace getVariable[_toggleVar,false];
				_value = !_value;
				missionNamespace setVariable[_toggleVar,_value];
				if(_value) then {
					_ctrl lbSetColor [_lbIndex,"+_rnd_toggleoncolor+"];
				} else {
					_ctrl lbSetColor [_lbIndex,"+_rnd_toggleoffcolor+"];
				};
				[_value] spawn _code;
			} else {
				[] spawn _code;
			};
		"";
		"+_rnd_adminmenuDBLclickObjs+" = compileFinal ""
			disableserialization;
			params['_ctrl','_lbIndex'];
			private _classname = _ctrl lbData _lbIndex;
			
			if("+_rnd_vehiclemenutoggle+") then 
			{
				private _distance = if(vehicle player == player) then {7} else {14};
				private _position = (getposatl (vehicle player)) vectorAdd ((vectorDir (vehicle player)) vectorMultiply _distance);
				private _direction = getdir vehicle player;
				[{
					params['_classname','_position','_direction','_uid'];
					
					_vehicle = _classname createVehicle [0,0,0];
					_vehicle setPosATL _position;
					_vehicle setDir _direction;
					clearWeaponCargoGlobal _vehicle;
					clearMagazineCargoGlobal _vehicle;
					clearItemCargoGlobal _vehicle;
					clearBackpackCargoGlobal _vehicle;
					_vehicle setVariable ['oUUID',_uid,true];
				},[_classname,_position,_direction,"+_rnd_steamID+"]] call "+_rnd_runserver+";
			};
			if("+_rnd_weaponmenutoggle+") then 
			{
				private _object = 'groundweaponholder' createVehicle [0,0,0];
				private _object setposatl getposatl player; 
				private _item = _classname;
				
				if(isClass (configFile >> 'CfgWeapons' >> _item)) then {
					if((toLower(_item) find 'tacs_' == 0) || (toLower(_item) find 'item' == 0) || (toLower(_item) find 'h_' == 0) || (toLower(_item) find 'u_' == 0) || (toLower(_item) find 'v_' == 0) || (toLower(_item) find 'minedetector' == 0) || (toLower(_item) find 'binocular' == 0) || (toLower(_item) find 'rangefinder' == 0) || (toLower(_item) find 'NVGoggles' == 0) || (toLower(_item) find 'laserdesignator' == 0) || (toLower(_item) find 'firstaidkit' == 0) || (toLower(_item) find 'medkit' == 0) || (toLower(_item) find 'toolkit' == 0) || (toLower(_item) find 'muzzle_' == 0) || (toLower(_item) find 'optic_' == 0) || (toLower(_item) find 'acc_' == 0) || (toLower(_item) find 'bipod_' == 0)) then {
						_object addItemCargoGlobal [_item,1];
					} else {
						_object addWeaponCargoGlobal [_item,1];
						_mags = getArray(configFile >> 'CfgWeapons' >> _item >> 'Magazines');
						if(count(_mags) > 0) then {
							private _mag = _mags select floor(random(count(_mags)));
							private _maxAmmo = getNumber(configFile >> 'CfgMagazines' >> _mag >> 'count');
							_object addMagazineAmmoCargo [_mag,3,_maxAmmo];
						};
					};
				};
			};
			if("+_rnd_cratemenutoggle+") then 
			{
				private _position = (vehicle player) modelToWorld [0,3,0];
				private _direction = getDir vehicle player;
				systemchat 'Crates will be deleted after restart!';

				[{
					params['_classname','_position','_direction'];
					private _crateClass = getText(configFile >> 'CfgAdmin' >> 'Crates' >> _classname >> 'CrateClass');
					private _items = getArray(configFile >> 'CfgAdmin' >> 'Crates' >> _classname >> 'Items');
					private _crate = createVehicle [_crateClass, _position, [], 0.5, 'NONE'];
					_crate setDir _direction;
					
					{
						_crate addItemCargoGlobal _x;
					} forEach _items;

				},[_classname,_position,_direction]] call "+_rnd_runserver+";				
			};
		"";
		"+_rnd_adminmenu_cratebuttons+" = compileFinal ""
			disableSerialization;
			params['_displayName','_class'];
			_ctrl = uiNamespace getVariable '"+_rnd_adminmenu_listCtrl+"';
			_index = _ctrl lbAdd _displayName;
			_ctrl lbSetData [_index,_class];
			_ctrl lbSetColor [_index,"+_rnd_notogglecolor+"];
		"";
		"+_rnd_adminmenu_updateobjlist+" = compileFinal ""
			disableSerialization;
			params['_ctrl','_type'];
			if(_type == 2) then {
				uiNamespace setVariable ['"+_rnd_adminmenu_listCtrl+"',_ctrl];
				private _id = netId player;
				[{
					params ['_id'];
					private _cfg = configFile >> 'CfgAdmin' >> 'Crates';
					for '_i' from 0 to (count(_cfg))-1 do {
						private _entry = _cfg select _i;
						if(isClass _entry) then {
							private _class = configName _entry;
							private _displayName = getText(_entry >> 'DisplayName');
							[_displayName,_class] remoteExec ['"+_rnd_adminmenu_cratebuttons+"', -2, _id];
						};
					};
				},[_id]] spawn "+_rnd_runserver+";
			} else { 
				private _cfg = if(_type == 0) then {configFile >> 'CfgVehicles'} else {configFile >> 'CfgWeapons'};
				for '_i' from 0 to count(_cfg)-1 do {
					private _entry = _cfg select _i;
					if(isClass _entry) then {
						if(getNumber(_entry >> 'scope') == 2) then {
							if(getText(_entry >> 'Picture') != '') then {
								_class = configName _entry;
								if(_type != 0 || _class isKindOf 'LandVehicle' || _class isKindOf 'Air' || _class isKindOf 'Ship') then {
									private _pic = getText(_entry >> 'Picture');
									private _displayName = getText(_entry >> 'DisplayName');
									private _index = _ctrl lbAdd _displayName;
									_ctrl lbSetData [_index,_class];
									_ctrl lbSetColor [_index,"+_rnd_notogglecolor+"];
									_ctrl lbSetPicture [_index,_pic];
								};
							};
						};
					};
				};
			};
		"";
		"+_rnd_openmenu+" = compileFinal ""
			disableserialization;
			createDialog 'RscDisplayAdminMenu';
			private _display = findDisplay 1776;
			private _main = _display displayctrl 1776;
			private _title = _display displayctrl 1777;
			private _plrs = _display displayctrl 1778;
			private _objs = _display displayctrl 1780;
			private _log = _display displayctrl 1781;

			{
				_text = _x select 0;
				_type = _x select 1;
				if(_forEachIndex != 0) then {
					if(_type == 0) then {
						_main lbAdd '';
					};
				};
				_index = _main lbAdd _text;
				_main lbSetData [_index,str(_forEachIndex)];
				if(_type == 0) then {
					_main lbSetColor [_index,"+_rnd_titlecolor+"];
				};
				if(_type == 1) then {
					_variable = _x select 3;
					_value = missionNamespace getVariable [_variable,false];
					if(_value) then {
						_main lbSetColor [_index,"+_rnd_toggleoncolor+"];
					} else {
						_main lbSetColor [_index,"+_rnd_toggleoffcolor+"];
					};
				};
				if(_type == 2) then {
					_main lbSetColor [_index,"+_rnd_notogglecolor+"];
				};
			} forEach "+_rnd_adminmenufunctions+";
			_main ctrlAddEventHandler ['LBDblClick',"+_rnd_adminmenuDBLclick+"];
			
			_plrs ctrlShow "+_rnd_playermenutoggle+";
			{
				private _veh = vehicle _x;
				private _name = name _x;
				private _uid = getplayeruid _x;
				private _icon = getText(configFile >> 'CfgVehicles' >> typeof _veh >> 'Picture');
				private _type = if(_uid call "+_rnd_getadminlvl+" > 0) then {'Admin'} else {'Player'};
				private _index = _plrs lbAdd (_name + ' | ' + _uid + ' | ' + _type);
				_plrs lbSetData [_index,_uid];
				if(_type == 'Admin') then {
					_plrs lbSetColor [_index,"+_rnd_toggleoffcolor+"];
				} else {
					_plrs lbSetColor [_index,"+_rnd_notogglecolor+"];
				};
				_plrs lbSetPicture [_index,_icon];
			} forEach allPlayers;
			_map = _display displayctrl 1779;
			_map ctrlShow "+_rnd_maptoggle+";
			_map ctrlAddEventHandler ['Draw', "+_rnd_drawmarkers+"];

			_objs ctrlShow ("+_rnd_weaponmenutoggle+" || "+_rnd_vehiclemenutoggle+" || "+_rnd_cratemenutoggle+");
			_objs ctrlAddEventHandler ['LBDblClick',"+_rnd_adminmenuDBLclickObjs+"];

			if("+_rnd_weaponmenutoggle+") then {
				[_objs,1] call "+_rnd_adminmenu_updateobjlist+";
			} else {
				if("+_rnd_vehiclemarkerstoggle+") then {
					[_objs,0] call "+_rnd_adminmenu_updateobjlist+";
				} else {
					if("+_rnd_cratemenutoggle+") then {
						[_objs,2] call "+_rnd_adminmenu_updateobjlist+";
					};
				};
			};

			_log ctrlShow "+_rnd_hacklogtoggle+";
			private _index = _log lbAdd '        Log List';
			_log lbSetColor[_index,"+_rnd_titlecolor+"];
	
			private _logs = missionNamespace getVariable ['life_var_admin_logs',[]];
			for '_i' from 0 to (count(_logs) - 1) do {
				private _message = _logs select _i;
				private _array = _message splitString '| ';
				private _type = _array select 0;
				private _uid = _array select 1;
				private _reason = _array select 2;
				private _color = switch (toLower(_type)) do {
					case 'ban': {[1,0,0,1]};
					case 'kick': {[1,1,0,1]};
					case 'servere': {[1,0.5,3,0,1]};
					case 'info': {[0.2,0.2,0.2,1]};	
					default {[1,1,1,1]};
				}; 
				private _index = _log lbAdd _message;
				_log lbSetData [_index,'LogMessage_' + (str (_i))];
				_log lbSetColor [_index,_color];
			};
		"";
		"+_rnd_init+" = compileFinal ""
			if(("+_rnd_steamID+" call "+_rnd_getadminlvl+") <= 0) exitwith{};
			"+_rnd_drawmarkers_evh+" = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ['Draw', "+_rnd_drawmarkers+"];
			"+_rnd_drawicons_evh+" = addMissionEventHandler ['Draw3D',"+_rnd_drawicons+"];
			onMapSingleClick "+_rnd_mapsingleclick+";
			[] call "+_rnd_adminmenugetfunctions+";
			life_fnc_admin_showmenu = missionNamespace getVariable['"+_rnd_openmenu+"',{}];
			(findDisplay 46) displayAddEventHandler ['KeyDown',{
				params['_display','_key'];
				if(_key == 0xD2) exitWith {
					if(isNull(findDisplay 1776))then{
						[] spawn "+_rnd_openmenu+";
					}else{
						(findDisplay 1776) closeDisplay 2;
						closeDialog 2;
					};
					true;
				};
				false;
			}];
			systemChat '--------------------------------------------------------------------------------------';
			systemChat 'Welcome Admin, OPEN Menu using INSERT or using Y-Menu';
			systemChat '--------------------------------------------------------------------------------------';
		"";

		[] spawn "+_rnd_init+";
	";
	
	private _adminserver = "
		['Admin Server Code Loading'] call life_fnc_admin_systemlog;
		"+_rnd_admins+" = compileFinal str("+str _admins+");
		"+_rnd_getadminlvl+" = compileFinal ""private _lvl = 0;{if(_this isEqualTo _x#1 || _this isEqualTo _x#2)exitWith{_lvl = _x#0;};}forEach (call "+_rnd_admins+");_lvl"";
		"+_rnd_adminconnected+" = compileFinal ""
			params['_name','_steamID','_ownerID',_adminlvl];
			if(_adminlvl <= 0)exitWith{};
			['Admin connected'] call life_fnc_admin_systemlog;
			_ownerID publicVariableClient '"+_rnd_admincode+"';
		"";
		"+_rnd_admindisconnected+" = compileFinal ""
			params['_name','_steamID','_ownerID',_adminlvl];
			if(_adminlvl <= 0)exitWith{};
			['Admin disconnected'] call life_fnc_admin_systemlog;
		"";
		"+_rnd_playerconnected+" = addMissionEventHandler ['PlayerConnected',{
			params [
				['_directPlayID',-100,[0]],
				['_steamID','',['']],
				['_name','',['']],
				['_didJIP',false,[false]],
				['_ownerID',-100,[0]],
				['_directPlayIDStr','',['']],
				['_customArgs',[]]
			];
 
			private _adminlvl = _steamID call "+_rnd_getadminlvl+";
			private _isadmin = _adminlvl > 0;

			if(!_isadmin)exitWith{['Player connected'] call life_fnc_admin_systemlog;};
			[_name,_steamID,_ownerID,_adminlvl] spawn "+_rnd_adminconnected+";
		},[]];
		"+_rnd_playerdisconnected+" = addMissionEventHandler ['PlayerDisconnected',{
			params [
				['_directPlayID',-100,[0]],
				['_steamID','',['']],
				['_name','',['']],
				['_didJIP',false,[false]],
				['_ownerID',-100,[0]],
				['_directPlayIDStr','',['']],
				['_customArgs',[]]
			];
 
			private _adminlvl = _steamID call "+_rnd_adminlvl+";
			private _isadmin = _adminlvl > 0;

			if(!_isadmin)exitWith{['Player disconnected'] call life_fnc_admin_systemlog;};
			[_name,_steamID,_ownerID,_adminlvl] spawn "+_rnd_admindisconnected+";
		},[]];
		 
		life_var_admin_loaded = true;
		['Admin Server Code Loaded'] call life_fnc_admin_systemlog;
	";
	
	//--- something broke with adminclient expression
	if(isNil "_adminclient" || isNil "_adminserver")throw "Failed to load admin system";

	//--- Compile AdminClient
	private _compiletime = diag_tickTime;
	["Compiling Admin Client Code"] call life_fnc_admin_systemlog;
	_adminclient = compileFinal _adminclient;
	[format["Admin Client Code Compiled... compile took %1 seconds",(diag_tickTime - _compiletime)]] call life_fnc_admin_systemlog;
	missionNamespace setVariable [_rnd_admincode,_adminclient];
	 
	//--- Compile AdminServer
	_compiletime = diag_tickTime;
	["Compiling Admin Server Code"] call life_fnc_admin_systemlog;
	_adminserver = compile _adminserver;
	[format["Admin Server Code Compiled... compile took %1 seconds",(diag_tickTime - _compiletime)]] call life_fnc_admin_systemlog;
	nul = 0 spawn _adminserver;
	 
}catch {
	[format["Exception: %1",_exception]] call life_fnc_admin_systemlog;
	life_var_admin_loaded = false;
};
 
true