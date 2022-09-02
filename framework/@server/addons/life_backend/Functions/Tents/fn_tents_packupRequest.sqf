/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_player",objNull,[objNull]],
	["_tent",objNull,[objNull]],
	["_marker","",[""]]
];

if(isNull _tent)exitWith {false};

private _tentID = _tent getVariable ["tentID",""];
if(_tentID isEqualTo "")exitWith {false};

//-- Delete from database
["UPDATE", "tents", [[["alive",["DB","BOOL", false] call life_fnc_database_parse]],[["tentID",str _tentID]]]]call life_fnc_database_request;

//-- Delete from world
[_tent] call life_fnc_tents_packup;

//-- Delete local marker
if(_marker isEqualTo "" OR isNull _player)exitWith {true};

private _oneTimeUse = getNumber(configFile >> "CfgTents" >> "oneTimeUse") isEqualTo 1;

private _vitem = ["tentKit", ""] select _oneTimeUse;

[[_marker,_vitem],{
	params ["_marker","_vitem"];
	deleteMarkerLocal _marker;
	systemChat "Tent deleted";

	//-- Add tentkit vack into player vinventory
	if(_vitem isNotEqualTo "")then {

	};
}] remoteExec ["spawn",owner _player];  

true