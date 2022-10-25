#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params ['_admins','_rconReady','_rnd_netVar','_rnd_adminvehiclevar','_rnd_admincode'];

if(!isServer)exitwith{false}; 
if(missionNamespace getVariable ["life_var_admin_loaded",false])exitwith{false};
if(isRemoteExecuted AND life_var_rcon_passwordOK)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_admin_initialize.sqf`"] call MPServer_fnc_rcon_ban;};

["Starting Serveside Code!"] call MPServer_fnc_admin_systemlog;

life_var_admin_loaded = false;
life_var_admin_logs = [];

try {
	private _config = (configFile >> "CfgAdmin"); 
	private _tempvars = [];

	//--- Get Config
	if(!isClass _config) throw "Config not found";
	private _dbLogs = getNumber(_config >> "dblogs") isEqualTo 1;
	private _adminIGL = getNumber(_config >> "ingamelogs") isEqualTo 1;
	private _adminIGL_minlvl = getNumber(_config >> "ingamelogs_minlvl");

	//--- Load logs
	if(_dbLogs)then{
		private _logs = ["READ", "admin_logs",[["Type","log","steamID"],[]],false] call MPServer_fnc_database_request;
		{
			life_var_admin_logs pushback _x;
		}forEach _logs;
	};
	publicVariable "life_var_admin_logs";

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
		"_rnd_godmodetoggleThread",
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
		"_rnd_mapsingleclick",
		"_rnd_adminmenu_getstringinput",
		"_rnd_adminmenu_inputkeyevent",
		"_rnd_adminmenu_inputctrl",
		"_rnd_adminmenu_inputsubmittedtext",
		"_rnd_adminmenu_inputsubmittedentry",
		"_rnd_adminmenu_getposfrommap",
		"_rnd_adminmenu_spectateevent",
		"_rnd_adminmenu_mappos",
		"_rnd_adminmenu_addlogs2list",
		"_rnd_fnc_joinAdminChat",
		"_rnd_fnc_leaveAdminChat",
		"_rnd_fnc_adminShopMenu",
		"_rnd_fnc_adminShopVehMenu",
		"_rnd_fnc_adminShopClothingMenu",
		"_rnd_fnc_adminShopWepMenu",
		"_rnd_fnc_adminShopMarketMenu"
	];

	//--- create random vars
	if(isNil "MPServer_fnc_util_randomString") throw "Random string function not found";
	_tempvars resize (count _rndvars);
	_tempvars params (_rndvars apply {private _ret=[_x,call MPServer_fnc_util_randomString];[format["`%1` => `%2`",_ret#0,_ret#1]]call MPServer_fnc_admin_systemlog;_ret});
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
		"+_rnd_kick+" =    		 compileFinal ""if("+_rnd_useRcon +")then{['kick',_this#0,_this#1] call "+_rnd_sendreqtarget+";}else{['Antihack Kick',_this#1,'Antihack'] call MPClient_fnc_endMission;};"";
		"+_rnd_ban+" =     		 compileFinal ""if("+_rnd_useRcon +")then{['ban',_this#0,_this#1] call "+_rnd_sendreqtarget+";}else{['Antihack Ban',_this#1,'Antihack'] call MPClient_fnc_endMission;};"";
		"+_rnd_log+" =     		 compileFinal ""['log',['ADMIN',_this#0,_this#1]] call "+_rnd_sendreq+";"";

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
		"+_rnd_godmodetoggleThread+" = scriptNull;
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
		"+_rnd_fnc_adminShopMenu+" = {
			disableSerialization;
			MPClient_var_SelectedAdminShop = '';
			
			private _display = createDialog ['RscDisplayChooseEditorLayout',true];

			(_display displayctrl 1000) ctrlSetText 'Admin Shop Menu';
			
			lbClear (_display displayctrl 101);
			{ 
				(_display displayctrl 101) lbAdd _x; 
				(_display displayctrl 101) lbSetData [_ForEachIndex, _x];
			} forEach [
				'clothing',
				'weapons',
				'market',
				'vehicle'
			];
			(_display displayctrl 101) ctrlAddEventHandler ['LbSelChanged',{disableSerialization; MPClient_var_SelectedAdminShop = lbData[101,_this#1]}];
			(_display displayctrl 101) ctrlCommit 0;
			
			(_display displayctrl 1) ctrlSetText 'Confirm';
			(_display displayctrl 1) buttonSetAction '
			if(count MPClient_var_SelectedAdminShop isEqualTo 0)then{hint ""No Admin Shop Selected!""}else{
				switch MPClient_var_SelectedAdminShop do 
				{
					case ""clothing"": {[findDisplay 164] call "+_rnd_fnc_adminShopClothingMenu+"};
					case ""weapons"": {[findDisplay 164] call "+_rnd_fnc_adminShopWepMenu+"};
					case ""vehicle"": {[findDisplay 164] call "+_rnd_fnc_adminShopVehMenu+"};
					case ""market"": {[findDisplay 164] call "+_rnd_fnc_adminShopMarketMenu+"};
				}
			};';
			(_display displayctrl 1) ctrlCommit 0;

		};
		"+_rnd_fnc_adminShopVehMenu+" = {
			disableSerialization;
			MPClient_var_SelectedAdminVehicleShop = '';

			private _display = createDialog ['RscDisplayChooseEditorLayout',true];
			
			(_display displayctrl 1000) ctrlSetText 'All Vehicle Shops';

			lbClear (_display displayctrl 101);	
			{ 
				(_display displayctrl 101) lbAdd format ['[%1] %2', getText(missionConfigFile >> 'cfgVehicleTraders' >> _x >> 'side'), _x]; 
				(_display displayctrl 101) lbSetData [_ForEachIndex, _x];
			} forEach (('true' configClasses (missionConfigFile >> 'cfgVehicleTraders')) apply {configName _x});
			
			(_display displayctrl 101) ctrlAddEventHandler ['LbSelChanged',{disableSerialization; MPClient_var_SelectedAdminVehicleShop = lbData[101,_this#1]}];
			(_display displayctrl 101) ctrlCommit 0;
			
			(_display displayctrl 1) ctrlSetText 'Confirm';
			(_display displayctrl 1) buttonSetAction 'if(count MPClient_var_SelectedAdminVehicleShop isEqualTo 0)then{hint ""No Admin Shop Selected!""}else{life_var_adminShop = true;[toString [34,34],toString [34,34],toString [34,34],[MPClient_var_SelectedAdminVehicleShop]] spawn MPClient_fnc_vehicleShopMenu};';
			(_display displayctrl 1) ctrlCommit 0; 
		};
		"+_rnd_fnc_adminShopWepMenu+" = {
			disableSerialization;
			MPClient_var_SelectedAdminWeaponShop = '';

			private _display = createDialog ['RscDisplayChooseEditorLayout',true];
			
			(_display displayctrl 1000) ctrlSetText 'All Weapon & item Shops';

			lbClear (_display displayctrl 101);	
			{ 
				(_display displayctrl 101) lbAdd format ['[%1] %2', getText(missionConfigFile >> 'cfgWeaponShops' >> _x >> 'side'), getText(missionConfigFile >> 'cfgWeaponShops' >> _x >> 'name')]; 
				(_display displayctrl 101) lbSetData [_ForEachIndex, _x];
			} forEach (('true' configClasses (missionConfigFile >> 'cfgWeaponShops')) apply {configName _x});
			
			(_display displayctrl 101) ctrlAddEventHandler ['LbSelChanged',{disableSerialization; MPClient_var_SelectedAdminWeaponShop = lbData[101,_this#1]}];
			(_display displayctrl 101) ctrlCommit 0;
			
			(_display displayctrl 1) ctrlSetText 'Confirm';
			(_display displayctrl 1) buttonSetAction 'if(count MPClient_var_SelectedAdminWeaponShop isEqualTo 0)then{hint ""No Admin Shop Selected!""}else{life_var_adminShop = true;[toString [34,34],toString [34,34],toString [34,34],MPClient_var_SelectedAdminWeaponShop] spawn MPClient_fnc_weaponShopMenu};';
			(_display displayctrl 1) ctrlCommit 0; 
		};
		"+_rnd_fnc_adminShopMarketMenu+" = {
			disableSerialization;
			MPClient_var_SelectedAdminMarketShop = '';
			
			private _display = createDialog ['RscDisplayChooseEditorLayout',true];
		
			(_display displayctrl 1000) ctrlSetText 'All Market Shops';

			lbClear (_display displayctrl 101);	
			{ 
				(_display displayctrl 101) lbAdd format ['[%1] %2', getText(missionConfigFile >> 'cfgVirtualShops' >> _x >> 'side'),localize getText(missionConfigFile >> 'cfgVirtualShops' >> _x >> 'name')]; 
				(_display displayctrl 101) lbSetData [_ForEachIndex, _x];
			} forEach (('true' configClasses (missionConfigFile >> 'cfgVirtualShops')) apply {configName _x});
			
			(_display displayctrl 101) ctrlAddEventHandler ['LbSelChanged',{disableSerialization; MPClient_var_SelectedAdminMarketShop = lbData[101,_this#1]}];
			(_display displayctrl 101) ctrlCommit 0;
			
			(_display displayctrl 1) ctrlSetText 'Confirm';
			(_display displayctrl 1) buttonSetAction 'if(count MPClient_var_SelectedAdminMarketShop isEqualTo 0)then{hint ""No Admin Shop Selected!""}else{life_var_adminShop = true;[player,toString [34,34],toString [34,34],MPClient_var_SelectedAdminMarketShop] spawn MPClient_fnc_virt_menu;};';
			(_display displayctrl 1) ctrlCommit 0; 
		};
		"+_rnd_fnc_adminShopClothingMenu+" = {
			disableSerialization;
			MPClient_var_SelectedAdminClothingShop = '';
			life_var_adminShop = true;
			
			private _display = createDialog ['RscDisplayChooseEditorLayout',true];
		
			(_display displayctrl 1000) ctrlSetText 'All Clothing Shops';

			lbClear (_display displayctrl 101);	
			{ 
				(_display displayctrl 101) lbAdd format ['[%1] %2', getText(missionConfigFile >> 'cfgClothing' >> _x >> 'side'), localize getText(missionConfigFile >> 'cfgClothing' >> _x >> 'title')]; 
				(_display displayctrl 101) lbSetData [_ForEachIndex, _x];
			} forEach (('true' configClasses (missionConfigFile >> 'cfgClothing')) apply {configName _x});
			
			(_display displayctrl 101) ctrlAddEventHandler ['LbSelChanged',{disableSerialization; MPClient_var_SelectedAdminClothingShop = lbData[101,_this#1]}];
			(_display displayctrl 101) ctrlCommit 0;
			
			(_display displayctrl 1) ctrlSetText 'Confirm';
			(_display displayctrl 1) buttonSetAction 'if(count MPClient_var_SelectedAdminClothingShop isEqualTo 0)then{hint ""No Admin Shop Selected!""}else{[toString [34,34],toString [34,34],toString [34,34],MPClient_var_SelectedAdminClothingShop] spawn MPClient_fnc_clothingMenu;};';
			(_display displayctrl 1) ctrlCommit 0; 
		};
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
		"+_rnd_adminmenu_getstringinput+" = compileFinal ""
			disableserialization;
			if(!isNil '"+_rnd_adminmenu_inputkeyevent+"') exitWith {};
			
			private _display = findDisplay 1776;
			private _ctrl = _display ctrlCreate ['RscEdit',-1];
			_ctrl ctrlSetPosition [0,0.475,1,0.05];
			_ctrl ctrlSetBackgroundColor [0.10,0.10,0.10,1];
			_ctrl ctrlSetText 'Enter Message Here & Press Enter';
			_ctrl ctrlCommit 0;
			uiNamespace setVariable ['"+_rnd_adminmenu_inputctrl+"',_ctrl];
			
			"+_rnd_adminmenu_inputsubmittedentry+" = false;
			"+_rnd_adminmenu_inputsubmittedtext+" = '';
			"+_rnd_adminmenu_inputkeyevent+" = _display displayAddEventHandler ['KeyDown',{
				params['_display','_key'];
				
				if(_key == 0x1C) exitWith {
					_display displayRemoveEventHandler ['KeyDown',"+_rnd_adminmenu_inputkeyevent+"];
					"+_rnd_adminmenu_inputkeyevent+" = nil;
					private _ctrl = uiNamespace getVariable '"+_rnd_adminmenu_inputctrl+"';
					"+_rnd_adminmenu_inputsubmittedtext+" = ctrlText _ctrl;
					"+_rnd_adminmenu_inputsubmittedentry+" = true;
					ctrlDelete _ctrl;
					true;
				};
				false;
			}];
			waitUntil{"+_rnd_adminmenu_inputsubmittedentry+" || isNull _display};
			if(isNull _display) exitWith {
				"+_rnd_adminmenu_inputsubmittedentry+" = nil;
				"+_rnd_adminmenu_inputkeyevent+" = nil;
				"+_rnd_adminmenu_inputsubmittedtext+" = nil;
				'';
			};
			private _text = "+_rnd_adminmenu_inputsubmittedtext+";
			"+_rnd_adminmenu_inputsubmittedtext+" = nil;
			"+_rnd_adminmenu_inputsubmittedentry+" = nil;
			_text;
		"";
		"+_rnd_adminmenu_getposfrommap+" = compileFinal ""
			player linkitem 'itemMap';
			closeDialog 0;
			openMap true;
			if(!isNil '"+_rnd_adminmenu_mappos+"') then {
				"+_rnd_adminmenu_mappos+" = [0,0,0];
			};
			"+_rnd_adminmenu_mappos+" = [];
			onMapSingleClick '
				openMap false;
				[] spawn LYS_fnc_OpenMenu;
				"+_rnd_adminmenu_mappos+" = _pos;
				onMapSingleClick "+_rnd_mapsingleclick+";
			';
			waitUntil{!("+_rnd_adminmenu_mappos+" isEqualTo [])};
			_pos = "+_rnd_adminmenu_mappos+";
			"+_rnd_adminmenu_mappos+" = nil;
			_pos;
		"";
		"+_rnd_adminmenugetfunctions+" = compileFinal ""
			private _godmode = { 
				if("+_rnd_godmodetoggle+")then
				{
					"+_rnd_godmodetoggleThread+" = [] spawn {
						scriptName 'MPClient_fnc_godMode';
						['INFO','Enabled Invincibility'] call "+_rnd_log+";
						titleText [localize 'STR_ANOTF_godModeOn','PLAIN']; 
						titleFadeOut 2;
						while{"+_rnd_godmodetoggle+"}do{
							life_var_hunger = 1000;
							life_var_thirst = 1000;
							life_var_bleeding = false;
							life_var_painShock = false;
							life_var_critHit = false;
							player allowDamage false;
							waitUntil{
								sleep 6;
								if(isNil 'life_var_thirst')then{life_var_thirst = 1000};
								if(isNil 'life_var_hunger')then{life_var_hunger = 1000};
								if(isNil 'life_var_bleeding')then{life_var_bleeding = false};
								if(isNil 'life_var_painShock')then{life_var_painShock = false};
								if(isNil 'life_var_critHit')then{life_var_critHit = false}; 
								(
									isDamageAllowed player
									OR
									life_var_thirst <= 60 
									OR 
									life_var_hunger <= 60 
									OR 
									life_var_bleeding 
									OR 
									life_var_painShock 
									OR 
									life_var_critHit
								)
							};
						};
					};
				}else{
					['INFO','Disabled Invincibility'] call "+_rnd_log+";
					titleText [localize 'STR_ANOTF_godModeOff','PLAIN']; titleFadeOut 2;
					player allowDamage true;
					terminate "+_rnd_godmodetoggleThread+";
					life_var_hunger = 100;
					life_var_thirst = 100;
				};
			};
			private _infammo = { 
				if("+_rnd_infinteammotoggle+") then {
					['INFO','Enabled infinte ammo'] call "+_rnd_log+";
					while{"+_rnd_infinteammotoggle+"} do {
						(vehicle player) setVehicleAmmo 1;
						sleep 0.1;
					};
				};
			};
			private _norecoil = {
				params['_toggle'];
				_recoil = unitRecoilCoefficient player;
				_sway = getCustomAimCoef player; 
				player setUnitRecoilCoefficient (if(_toggle) then {life_var_OldRecoil = _recoil;0} else {life_var_OldRecoil});
				player setCustomAimCoef (if(_toggle) then {life_var_OldSway = _sway;0} else {life_var_OldSway});
				if(_toggle)then{
					['INFO','Enabled no recoil'] call "+_rnd_log+";
				};
			};
			private _fastfire = {
				if("+_rnd_fastfiretoggle+") then { 
					['INFO','Enabled fastfire'] call "+_rnd_log+";
					while{"+_rnd_fastfiretoggle+"} do {
						(vehicle player) setWeaponReloadingTime [gunner (vehicle player), currentMuzzle (gunner (vehicle player)), 0];
						sleep 0.001;
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
				['INFO','Opened Arsenal'] call "+_rnd_log+";
			};
			private _resetHypothalamus = {
				resetCamShake; 
				life_var_hunger = 100;
				life_var_thirst = 100;
				life_var_bleeding = false;
				life_var_painShock = false;
				life_var_critHit = false;
			};
			private _heal = {
				resetCamShake; 
				player setDamage 0;
				life_var_hunger = 100;
				life_var_thirst = 100;
				life_var_bleeding = false;
				life_var_painShock = false;
				life_var_critHit = false;
				['INFO','SelfHealed'] call "+_rnd_log+";
			};
			private _repaircurs = {
				if(isNull cursorTarget)exitwith{};
				cursorTarget setDamage 0;
				if(damage cursorTarget isEqualTo 0)then{
					['INFO',format['Repaired (%1)',typeOf(_object)]] call "+_rnd_log+";
				};
			};
			private	_deletecurs = { 
				if(isNull cursorTarget)exitwith{};
				[] spawn{
					private _object = cursorTarget;
					private _type = typeOf _object;
					[{
						params['_object']; 
						deleteVehicle _object;
					},[_object]] call "+_rnd_runserver+"; 
					sleep 15;
					if(isNull _object)then{
						['INFO',format['Deleted (%1)',_type]] call "+_rnd_log+";
					};
				};
			};
			private _vehgod = {
				if("+_rnd_vehgod_toggle+") then { 
					['INFO',format['Enabled Vehicle Invincibility On Their (%1)',typeOf(vehicle player)]] call "+_rnd_log+";
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
					['INFO',format['Boosted Thier (%1)',typeOf(vehicle player)]] call "+_rnd_log+";
					while{"+_rnd_vehboost_toggle+"} do {
						if(vehicle player != player) then {
							if(inputAction 'carFastForward' > 0) then {
								_veh = velocity (vehicle player);
								_veh = _veh vectorAdd (vectorNormalized _veh);
								(vehicle player) setVelocity _veh;
							};
						};
						sleep 0.1;
					};
				};
			};
			private _vehrepair = {
				if(vehicle player != player) exitWith {};
				vehicle player setDamage 0;
				['INFO',format['Repaired Their (%1)',typeOf(vehicle player)]] call "+_rnd_log+";
			};
			private _invisible = {
				params['_toggle'];
				[{
					params['_unit','_toggle'];
					_unit hideObjectGlobal _toggle;
				},[player,_toggle]] call "+_rnd_runserver+";
				if(_toggle)then{
					['INFO','Went Invisible'] call "+_rnd_log+";
				};
			};
			private _freecam = {
				closeDialog 0;
				call BIS_fnc_Camera;
				['INFO','Opened freecam'] call "+_rnd_log+";
			};
			private _healtarg = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					resetCamShake; 
					player setDamage 0;
					life_var_hunger = 100;
					life_var_thirst = 100;
					life_var_bleeding = false;
					life_var_painShock = false;
					life_var_critHit = false;
				}] call "+_rnd_runtarget+";
				['INFO',format['Healed %1',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _resetHypothalamusTarg = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					resetCamShake; 
					life_var_hunger = 100;
					life_var_thirst = 100;
					life_var_bleeding = false;
					life_var_painShock = false;
					life_var_critHit = false;
				}] call "+_rnd_runtarget+";
			};
			private _repairtarg = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				if(vehicle player == player) exitWith {};
				[_target,{
					if(vehicle player != player) then {vehicle player setDamage 0;};
				}] call "+_rnd_runtarget+"; 
				['INFO',format['Repaired %1 (%2)',getPlayerUID _target, typeOf(vehicle player)]] call "+_rnd_log+";
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
					['INFO',format['Requested %1 Steam Information',getPlayerUID _target]] call "+_rnd_log+";
				};
			};
			private _viewinventory = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				closeDialog 0;
				createGearDialog [_target,'RscDisplayInventory'];
				['INFO',format['Viewed %1 Inventory',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _toggle_weaponMenu = {
				disableserialization;
				params['_toggle'];
				private _display = findDisplay 1776;
				private _objs = _display displayctrl 1780;
				private _mainList = _display displayCtrl 1776;
				
				lbClear _objs;
				if(_toggle) then {
					[_objs,1] call "+_rnd_adminmenu_updateobjlist+";
					if(ctrlShown _objs) then {
						Vehicle_Menu_Toggle = false;
						Crate_Menu_Toggle = false;
						for '_i' from 0 to (lbSize _mainList)-1 do {
							private _index = _mainList lbData _i;
							if(_index != '') then {
								private _j = parseNumber _index;
								private _funcData = "+_rnd_adminmenufunctions+" select _j;
								private _text = _funcData select 0;
								if(_text == 'Vehicle Menu' || _text == 'Supply Crate(s)') then {
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
							private _index = _mainList lbData _i;
							if(_index != '') then {
								private _j = parseNumber _index;
								private _funcData = "+_rnd_adminmenufunctions+" select _j;
								private _text = _funcData select 0;
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
			private _toggle_supplies = {
				disableserialization;
				params['_toggle'];
				private _display = findDisplay 1776;
				private _objs = _display displayctrl 1780;
				private _mainList = _display displayCtrl 1776;
				lbClear _objs;
				if(_toggle) then {
					[_objs,2] call "+_rnd_adminmenu_updateobjlist+";
					if(ctrlShown _objs) then {
						Weapon_Menu_Toggle = false;
						Vehicle_Menu_Toggle = false;
						for '_i' from 0 to (lbSize _mainList)-1 do {
							private _index = _mainList lbData _i;
							if(_index != '') then {
								private _j = parseNumber _index;
								private _funcData = "+_rnd_adminmenufunctions+" select _j;
								private _text = _funcData select 0;
								if(_text == 'Weapon Menu' || _text == 'Vehicle Menu') then {
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
			private _airdrop = {
				private _pos = call "+_rnd_adminmenu_getposfrommap+";
				if(_pos isEqualTo [0,0,0]) exitWith {};
				[{
					params ['_location'];


				},[_pos]] call "+_rnd_runserver+";
				['INFO','Requested airdrop'] call "+_rnd_log+";
			};
			private _messageall = {
				private _input = call "+_rnd_adminmenu_getstringinput+";
				if(_input == '') exitWith {};
				['Admin Message\n\n' + _input] remoteExec ['hint',0];
				['INFO',format ['Messaged Everyone With %1',_input]] call "+_rnd_log+";
			};
			private _messagetarget = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				private _input = call "+_rnd_adminmenu_getstringinput+";
				if(_input == '') exitWith {};
				['Admin Message\n\n' + _input] remoteExec ['hint',_target];
				['INFO',format ['Messaged %1 With %2',getPlayerUID _target,_input]] call "+_rnd_log+";
			};
			private _bantarget = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				private _reason = call "+_rnd_adminmenu_getstringinput+";
				if(_reason == '') then {};
				[getplayeruid _target,_reason] call "+_rnd_ban+";
				['INFO',format ['Banned %1 For %2',getPlayerUID _target,_reason]] call "+_rnd_log+";
			};
			private _kicktarget = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				private _reason = call "+_rnd_adminmenu_getstringinput+";
				if(_reason == '') then {};
				[getplayeruid _target,_reason] call "+_rnd_kick+";
				['INFO',format ['Kicked %1 For %2',getPlayerUID _target,_reason]] call "+_rnd_log+";
			};
			private _knockout = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{ 

				}] call "+_rnd_runtarget+";
				['INFO',format ['Knocked out %1',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _killtarg = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					player setDamage 1;
				}] call "+_rnd_runtarget+";
				['INFO',format ['Killed %1',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _breaklegs = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					player setHitPointDamage ['HitLegs',1];
				}] call "+_rnd_runtarget+";
				['INFO',format ['Broke %1 legs',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _spectate = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				closeDialog 0;		
				if(!isNil '"+_rnd_adminmenu_spectateevent+"') then {
					(findDisplay 46) displayRemoveEventHandler ['KeyDown',"+_rnd_adminmenu_spectateevent+"];
				};
				_target switchCamera 'EXTERNAL';
				"+_rnd_adminmenu_spectateevent+" = (findDisplay 46) displayAddEventHandler ['KeyDown',{
					params['_display','_key'];
					if(_key == 0x01) exitWith {
						player switchCamera 'EXTERNAL';
						(findDisplay 46) displayRemoveEventHandler ['KeyDown',"+_rnd_adminmenu_spectateevent+"];
						"+_rnd_adminmenu_spectateevent+" = nil;
						true;
					};
					false;
				}];
				['INFO',format ['Spectated %1',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _lockinput = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					disableUserInput true;
				}] call "+_rnd_runtarget+";
				['INFO',format ['Locked %1 Input',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _unlockinput = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					disableUserInput false;
				}] call "+_rnd_runtarget+";
				['INFO',format ['Unlocked %1 Input',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _blackscreen = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					1776 cutText ['','BLACK FADED'];
				}] call "+_rnd_runtarget+";
				['INFO',format ['Blackscreen %1',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _clearscreen = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				[_target,{
					1776 cutText ['','PLAIN'];
				}] call "+_rnd_runtarget+";
				['INFO',format ['Cleared %1 Blackscreen',getPlayerUID _target]] call "+_rnd_log+";
			};
			private _tphere = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {}; 
				_target setVariable ['teleported',true,true];
				private _oldPos = (getPosATL _target);
				private _newpos = (getPosATL player);
				if((vehicle player) != player) then {
					_target moveInAny (vehicle player);
					if(vehicle _target != vehicle player) then {
						private _pos = (getPos (vehicle player)) findEmptyPosition [0,20];
						if(_pos != []) then {
							_newpos = _pos;
							_target setPos _newpos;
						} else {
							_target setPosATL _newpos;
						};
					};
				} else {
					_target setPosATL _newpos;
				}; 
				['INFO',format ['Teleported %1 %2Meters to there location',getPlayerUID _target,_oldPos distance2D _newpos]] call "+_rnd_log+";
				_target spawn { 
					scriptName 'MPClient_fnc_telported';
					sleep 5;
					_this setVariable ['teleported',false,true];
				};
			};
			private _tpto = {
				private _target = call "+_rnd_adminmenu_getselectedtarget+";
				if(isNull _target) exitWith {};
				player setVariable ['teleported',true,true];
				private _oldPos = (getPosATL player);
				private _newpos = (getPosATL _target);
				if((vehicle _target) != _target) then {
					_freeSpace = {(vehicle player) emptyPositions _x} forEach ['Commander','Driver','Gunner','Cargo'];
					if(_freeSpace > 0) then {
						player moveInAny (vehicle _target);
						_newpos = getPos (vehicle _target);
					} else {
						_newpos = getPos (vehicle _target);
						player setPos [_newpos select 0,_newpos select 1,0];
					};
				} else {
					player setPosATL _newpos;
				};
				['INFO',format ['Teleported %1Meters to %2 location',_oldPos distance2D _newpos,getPlayerUID _target]] call "+_rnd_log+";
				player spawn { 
					scriptName 'MPClient_fnc_telported';
					sleep 5;
					_this setVariable ['teleported',false,true];
				};
			};
			private _lockserv = {
				[{
					'#lock' call MPServer_fnc_rcon_sendCommand;
				}] call "+_rnd_runserver+";
				hint 'Server Locked!';
				['INFO','Locked Server'] call "+_rnd_log+";
			};
			private _unlockserv = {
				[{
					'#unlock' call MPServer_fnc_rcon_sendCommand;
				}] call "+_rnd_runserver+";
				hint 'Server Unlocked!';
				['INFO','Unlocked Server'] call "+_rnd_log+";
			};
			private _restart = {
				[{
					'#lock' call MPServer_fnc_rcon_sendCommand;
					[]spawn{
						[[],{
							if(!hasInterface)exitWith{}; 
							[] call MPClient_fnc_updatePlayerData; 
							hint 'Admin Restart, Data saved... You will be kicked';
						}]remoteExec ['call',-2];
						sleep 45;
						[] call MPServer_fnc_rcon_kickAll;
						sleep 5;
						'#shutdown' call MPServer_fnc_rcon_sendCommand;
					};
				}] call "+_rnd_runserver+";
				['INFO','Restarted Server'] call "+_rnd_log+";
			}; 
			private _openShopsMenu = {
				(findDisplay 1776) closeDisplay 2;
				closeDialog 2;
				[]spawn "+_rnd_fnc_adminShopMenu+"; 
			};
			"+_rnd_adminmenufunctions+" = [
				['- Main',0],
					['God Mode',1,_godmode,'"+_rnd_godmodetoggle+"'],
					['Infinite Ammo',1,_infammo,'"+_rnd_infinteammotoggle+"'],
					['No Recoil / No Sway',1,_norecoil,'"+_rnd_norecoiltoggle+"'],
					['Fast Fire',1,_fastfire,'"+_rnd_fastfiretoggle+"'],
					['No Grass',1,_nograss,'"+_rnd_nograsstoggle+"'], 
					['Arsenal',2,_arsenal],
					['Reset Hypothalamus',2,_resetHypothalamus],
					['Heal',2,_heal],
					['Repair Cursor',2,_repaircurs],
					['Delete Cursor',2,_deletecurs],
					['Shops',2,_openShopsMenu],

				['- Players',0],
					['Show Players',1,_toggle_players,'"+_rnd_playermenutoggle+"'],
					['TP Here',2,_tphere],
					['TP To',2,_tpto], 
					['Ban',2,_bantarget],
					['Kick',2,_kicktarget],
					['Knockout',2,_knockout],
					['Break Legs',2,_breaklegs],
					['Kill',2,_killtarg],
					['Repair',2,_repairtarg],
					['Heal',2,_healtarg],
					['Reset Hypothalamus',2,_resetHypothalamusTarg],
					['Message',2,_messagetarget],
					['Lock Input',2,_lockinput],
					['Unlock Input',2,_unlockinput],
					['Black Screen',2,_blackscreen],
					['Clear Screen',2,_clearscreen],

				['- Vehicles',0],
					['God Mode',1,_vehgod,'"+_rnd_vehgod_toggle+"'],
					['Boost',1,_vehboost,'"+_rnd_vehboost_toggle+"'],
					['Repair',2,_vehrepair],

				['- Spawning',0],
					['Weapon Menu',1,_toggle_weaponMenu,'"+_rnd_weaponmenutoggle+"'],
					['Vehicle Menu',1,_toggle_vehicleMenu,'"+_rnd_vehiclemenutoggle+"'],
					['Supply Crate(s)',1,_toggle_supplies,'"+_rnd_cratemenutoggle+"'],
					['Airdrop',2,_airdrop],

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
					['Spectate',2,_spectate],
					['Invisibility',1,_invisible,'"+_rnd_invisibilitytoggle+"'],
					['FreeCam',2,_freecam],
					['View Steam Info',2,_viewSteamInfo],
					['View Inventory',2,_viewinventory],
					['Show Logs',1,_toggle_logs,'"+_rnd_hacklogtoggle+"'],
				
				['- Server',0],
					['Restart',2,_restart],
					['Lock',2,_lockserv],
					['Unlock',2,_unlockserv], 
					['Mass Message',2,_messageall],
 

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
					_vehicle setVariable ["+_rnd_adminvehiclevar+", true, true];
					_vehicle setPlateNumber format ['Admin: %1',_uid select[10, 7]];
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
				_object setPosATL (getPosATL player); 
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
					private _vitems = getArray(configFile >> 'CfgAdmin' >> 'Crates' >> _classname >> 'VItems');
					private _crate = createVehicle [_crateClass, _position, [], 0.5, 'NONE'];
					_crate setDir _direction;
					
					{
						_crate addItemCargoGlobal _x;
					} forEach _items;

					 
					{ 
						private _var = format ['life_inv_%1',[missionConfigFile >> 'cfgVirtualItems' >> _x#0 >> 'variable'] call BIS_fnc_returnConfigEntry];
						private _ci = _crate getVariable [_var,0];
						if(_ci > 0)then{
							_x set[1, _ci];
						};
						_crate setVariable [_var, _x#1, true];
					} forEach _vitems;
 
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
		"+_rnd_adminmenu_addlogs2list+" = compileFinal ""
			params ['_logctrl','_section','_entries']; 
			private _index = _logctrl lbAdd format['- %1',_section];
			_logctrl lbSetColor[_index,"+_rnd_titlecolor+"];
			{
				_x params ['_type','_message','_steamID']; 
				private _index = _logctrl lbAdd format['%1 | %2',_steamID, _message];
				private _color = switch (toUpper _type) do {
					case 'BAN':  {[1,   1,   0,   1]};
					case 'KICK': {[1,   0.5, 3,   1]};
					case 'HACK': {[1,   0,   0,   1]};
					case 'INFO': {[0.2, 0.2, 0.2, 1]};	
					default      {[1,   1,   1,   1]};
				};
				_logctrl lbSetData [_index,'LogMessage_' + (str (_forEachIndex))];
				_logctrl lbSetColor [_index,_color];
				_logctrl lbSetColorRight [_index,_color];
			} forEach _entries;
		"";
		"+_rnd_openmenu+" = compileFinal ""
			disableserialization;
			createDialog 'RscDisplayAdminMenu';
			private _display = findDisplay 1776;
			private _main = _display displayctrl 1776;
			private _title = _display displayctrl 1777;
			private _plrs = _display displayctrl 1778;
			private _objs = _display displayctrl 1780;
			private _log = (findDisplay 1776) displayctrl 1781;
			private _index = -1;
			  
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

				switch (_type) do 
				{
					case 0: {_main lbSetColor [_index,"+_rnd_titlecolor+"]};
					case 1: {
						if(missionNamespace getVariable [_x param [3, ''],false]) then {
							_main lbSetColor [_index,"+_rnd_toggleoncolor+"];
						} else {
							_main lbSetColor [_index,"+_rnd_toggleoffcolor+"];
						};
					};
					case 2: {_main lbSetColor [_index,"+_rnd_notogglecolor+"]};
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
			
			private _antihacklogs = missionNamespace getVariable ['life_var_antihack_logs',[]];
			[_log,'Antihack Log List',_antihacklogs] call "+_rnd_adminmenu_addlogs2list+"; 
			";
			if(_adminIGL)then{ 
				_adminclient = _adminclient + "
					if(("+_rnd_steamID+" call "+_rnd_getadminlvl+") >= "+str _adminIGL_minlvl+")then{
						private _adminlogs = missionNamespace getVariable ['life_var_admin_logs',[]];
						[_log,'Admin Log List (Only viewable with admin LVL "+str _adminIGL_minlvl+"+)',_adminlogs] call "+_rnd_adminmenu_addlogs2list+";
					};
				";
			};
			_adminclient = _adminclient + "
		"";
		"+_rnd_init+" = compileFinal ""
			if(("+_rnd_steamID+" call "+_rnd_getadminlvl+") <= 0) exitwith{};
			"+_rnd_drawmarkers_evh+" = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ['Draw', "+_rnd_drawmarkers+"];
			"+_rnd_drawicons_evh+" = addMissionEventHandler ['Draw3D',"+_rnd_drawicons+"];
			onMapSingleClick "+_rnd_mapsingleclick+";
			[] call "+_rnd_adminmenugetfunctions+";
			MPClient_fnc_admin_showmenu = missionNamespace getVariable['"+_rnd_openmenu+"',{}];
			(findDisplay 46) displayAddEventHandler ['KeyDown',{
				params['_display','_key'];
				if(_key == 0xB8) exitWith {
					if(isNull(findDisplay 1776))then{
						[] spawn "+_rnd_openmenu+";
					}else{
						(findDisplay 1776) closeDisplay 2;
						closeDialog 2;
					};
					true;
				};
				if(_key == 0x3C) exitWith {
					if(!isNull(findDisplay 1776))then{
						(findDisplay 1776) closeDisplay 2;
					};
					closeDialog 2;
					[]spawn "+_rnd_fnc_adminShopMenu+"; 
					true;
				};
				false;
			}];

			[]spawn{
				waitUntil{!isNil 'life_radio_staff'};
				["+_rnd_fnc_joinAdminChat+",[player]] call "+_rnd_runserver+";
			};

			systemChat '--------------------------------------------------------------------------------------';
			systemChat 'Welcome Admin, you can open the admin tools with the DIK: <menu key>';
			systemChat '--------------------------------------------------------------------------------------';
		"";

		[] spawn "+_rnd_init+";
	";
	
	private _adminserver = "
		['Admin Server Code Loading'] call MPServer_fnc_admin_systemlog;
		"+_rnd_admins+" = compileFinal str("+str _admins+");
		"+_rnd_getadminlvl+" = compileFinal ""private _lvl = 0;{if(_this isEqualTo _x#1 || _this isEqualTo _x#2)exitWith{_lvl = _x#0;};}forEach (call "+_rnd_admins+");_lvl"";
		"+_rnd_adminconnected+" = compileFinal ""
			params['_name','_steamID','_ownerID','_adminlvl'];
			if(_adminlvl <= 0)exitWith{};
			['Admin connected'] call MPServer_fnc_admin_systemlog;
			_ownerID publicVariableClient '"+_rnd_admincode+"';
		"";
		"+_rnd_admindisconnected+" = compileFinal ""
			params['_name','_steamID','_ownerID','_adminlvl'];
			if(_adminlvl <= 0)exitWith{};
			['Admin disconnected'] call MPServer_fnc_admin_systemlog;
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

			if(!_isadmin)exitWith{['Player connected'] call MPServer_fnc_admin_systemlog;};
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
 
			private _adminlvl = _steamID call "+_rnd_getadminlvl+";
			private _isadmin = _adminlvl > 0;

			if(!_isadmin)exitWith{['Player disconnected'] call MPServer_fnc_admin_systemlog;};
			[_name,_steamID,_ownerID,_adminlvl] spawn "+_rnd_admindisconnected+";
		},[]];
		 
		[]spawn{
			waitUntil{!isNil 'life_radio_staff'};
			publicVariable 'life_radio_staff';
			"+_rnd_fnc_joinAdminChat+" = compileFinal ""life_radio_staff radioChannelAdd [param [0,objNull]]"";publicVariable '"+_rnd_fnc_joinAdminChat+"';
			"+_rnd_fnc_leaveAdminChat+" = compileFinal ""life_radio_staff radioChannelRemove [param [0,objNull]]"";publicVariable '"+_rnd_fnc_leaveAdminChat+"';
		};
		life_var_admin_loaded = true;
		['Admin Server Code Loaded'] call MPServer_fnc_admin_systemlog;
	";
	
	//--- something broke with adminclient expression
	if(isNil "_adminclient" || isNil "_adminserver")throw "Failed to load admin system";

	//--- Compile AdminClient
	private _compiletime = diag_tickTime;
	["Compiling Admin Client Code"] call MPServer_fnc_admin_systemlog;
	_adminclient = compileFinal _adminclient;
	[format["Admin Client Code Compiled... compile took %1 seconds",(diag_tickTime - _compiletime)]] call MPServer_fnc_admin_systemlog;
	missionNamespace setVariable [_rnd_admincode,_adminclient];
	 
	//--- Compile AdminServer
	_compiletime = diag_tickTime;
	["Compiling Admin Server Code"] call MPServer_fnc_admin_systemlog;
	_adminserver = compile _adminserver;
	[format["Admin Server Code Compiled... compile took %1 seconds",(diag_tickTime - _compiletime)]] call MPServer_fnc_admin_systemlog;
	nul = 0 spawn _adminserver;
	 
}catch {
	[format["Exception: %1",_exception]] call MPServer_fnc_admin_systemlog;
	life_var_admin_loaded = false;
};
 
true