#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_show.sqf
*/

private _displayName = "RscDisplayCellPhone";
private _display = uiNamespace getVariable [_displayName, displayNull];

//--- If the display is already open, close it (Allows user to toggle cellphone)
if (!isNull _display) exitWith {
    _display closeDisplay 0;
    displayNull
};

//-- Error loading display
if !(isClass (missionConfigFile >> _displayName)) exitWith {
    systemChat format["Error: Display %1 <NOT FOUND>",_displayName];
    displayNull
};

//--- Open the display
_display = createDialog [_displayName,true];

//-- Error loading display
if(isNull _display) exitWith {
    systemChat format["Error: Display is %1 <NULL>",_displayName];
    _display
};

{ctrlShow [_x,false]} forEach [1002, 1501, 1003, 2401, 1004, 2401,4000,4001,4002,4003,4004,4005,4006,4007,4008];

private _playerList = _display displayCtrl 1500;
private _messageList = _display displayCtrl 1501;

life_var_phoneTarget = []; 
life_var_phoneContacts = [
	[" Police Request", "999-REQ-POLICE", "", "\A3\ui_f\data\gui\Rsc\RscDisplayMultiplayerSetup\disabledai_ca.paa"],
	[" NHS Request", "999-REQ-MEDIC", "", "textures\icons\cellphone\nhs.paa"],
	[" Admin Request", "XXX-REQ-ADMIN", "", "textures\icons\cellphone\admin.paa"]
];

{
	private _name = _x getVariable["realname",name _x];
	private _icon = format["textures\icons\cellphone\%1_icon.paa",switch (side group _x) do {case west: {"police"};case independent: {"medic"}; default {"civilian"};}];
	private _BEGuid = call(player getVariable ["BEGUID",{""}]);
	
	if(!alive _x) then {_name = _x getVariable["realname", name _x];};
	if(_BEGuid isNotEqualTo "") then {
		life_var_phoneContacts pushBack [_name, 0, _BEGuid, _icon];
	};
} forEach playableUnits;

[false] spawn MPClient_fnc_cellphone_switchDialog;
[] spawn MPClient_fnc_cellphone_playerFilter;
[] spawn MPClient_fnc_cellphone_messageShow;

true