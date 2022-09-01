/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/
 
params [
	["_playerObject",objNull,[objNull]], 
	["_newside",sideUnknown,[sideUnknown]], 
	["_deleteOLD",false]
];

private _SteamID = getPlayerUID _playerObject;
private _oldside = side _playerObject;
private _BEGuid = ('BEGuid' callExtension ("get:"+_SteamID));
private _position = getPosATL _playerObject;
private _loadout = getUnitLoadout _playerObject;
private _newgroup = createGroup [_newside,true];

//--- Get correct class for side requested to join
private _unitclassname = selectRandom (switch (_newside) do {
	case west: {["B_Survivor_F"]};
	case east: {["O_Survivor_F"]};
	case independent: {["I_Survivor_F"]};
	case civilian: {["C_Man_casual_4_v2_F","C_Man_casual_5_v2_F","C_Man_casual_7_F","C_man_p_beggar_F"]};
	default {[typeOf _playerObject]};
});

//--- Create character
private _newplayerObject = _newgroup createUnit [_unitclassname, _position, [], 0, "CAN_COLLIDE"]; 

//--- Already on side requested to join
if(isNull _newplayerObject)exitWith{
	_playerObject setVariable ["sideswitch_error","Error occured during switching sides, Failed to create new object.",true]; 
	deleteVehicle _newplayerObject; 
	false
};

//--get data for new side
private _queryResult = ["READ", "players", [
	(switch _newside do { 
		case west:        {["cop_licenses", "cop_gear",  "playtime", "coplevel"]};
		case independent: {["med_licenses", "med_gear",  "playtime", "mediclevel"]};
		case east: 		  {["reb_licenses", "reb_gear",  "playtime", "reblevel"]};
		default           {["civ_licenses", "civ_gear",  "playtime"]};
	}),
	[
		["BEGuid",str _BEGuid],
		["pid",_SteamID]
	]
],true]call life_fnc_database_request;


if (_queryResult isEqualTo ["DB:Read:Task-failure",false]) exitWith {
	_playerObject setVariable ["sideswitch_error","Error occured during switching sides, Failed to read database.",true];
	deleteVehicle _newplayerObject;
	false
};

private _licenses = 	["GAME","ARRAY",_queryResult param [0,[]]] call life_fnc_database_parse;
private _gear =    		["GAME","ARRAY",_queryResult param [1,[]]] call life_fnc_database_parse; 
private _playtime = 	["GAME","ARRAY",_queryResult param [2,[]]] call life_fnc_database_parse;
private _rank = 		["GAME","INT",(switch _newside do { 
	case west:        	{_queryResult param [3,0]};
	case independent: 	{_queryResult param [3,0]};
	case east:        	{_queryResult param [3,0]};
	default           	{0};
})] call life_fnc_database_parse;

//-- Whitelist check
if (_newside in [east,west,independent] AND _rank <= 0)exitWith {
	_playerObject setVariable ["sideswitch_error","Error occured during switching sides, Not whitelisted.",true];
	deleteVehicle _newplayerObject;
	false
};

_licenses = _licenses apply{[_x#0,["GAME","BOOL", _x#1] call life_fnc_database_parse]}

//--- Switch character
[
	[_playerObject,_newplayerObject,_gear,_licenses],
	{
		params [
			["_playerObject",objNull,[objNull]], 
			["_newplayerObject",objNull,[objNull]], 
			["_loadout",[],[[]]], 
			["_licenses",[],[[]]]
		];
		
		//-- no input
		disableUserInput true;
		
		//-- Hide both old and new objects
		_playerObject hideObjectGlobal true;
		_newplayerObject hideObjectGlobal true;

		//--switch unit
		_playerObject reveal _newplayerObject;
		selectPlayer _newplayerObject;

		//-- wait for switch to complete
		waitUntil {player isEqualTo _newplayerObject};

		//-- add gear
		_newplayerObject setUnitLoadout _loadout;

		//-- setup event handlers 
		[] call life_fnc_setupEVH;

		//-- show new player object
		_newplayerObject hideObjectGlobal false;

		//--
		if (count _licenses > 0) then {
			{missionNamespace setVariable [_x#0,_x#1]} forEach _licenses;
		};

		//-- enable input
		disableUserInput false; 

		//-- notify player
		hint format ["Your are now on %1 side",playerside];

		//-- serverside cleanup var
		_playerObject setVariable ["ready4cleanup",true,true];
	}
]remoteExec["spawn",owner _playerObject];
 
//--- Playtime 
private _playtimeindex = life_var_playtimeValuesRequest find [_uid, _playtime];
private _sideindex = (switch (_side) do {case west: {0};case independent: {1};case east: {2};default {3};});
if (_playtimeindex != -1) then {
	life_var_playtimeValuesRequest deleteAt _playtimeindex;
};
_playtimeindex = life_var_playtimeValuesRequest pushBackUnique [_uid, _playtime];
_playtime = _playtime#_sideindex;
[_uid,_playtime] call TON_fnc_setPlayTime;
publicVariable "life_var_playtimeValuesRequest";
 
//--- Delete old character
if _deleteOLD then{
	[_playerObject] spawn {
		params [
			["_playerObject",objNull,[objNull]]
		];

		//-- wait for client side to finish
		waitUntil {_playerObject getVariable ["ready4cleanup",false]};

		//-- loop too delete object incase it don't delete on first request
		while {!isNull _playerObject} do {
			deleteVehicle _playerObject;
			uiSleep 3;
		};
	};
};

true
