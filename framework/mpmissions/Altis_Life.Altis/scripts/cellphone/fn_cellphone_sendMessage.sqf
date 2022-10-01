#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_sendMessage.sqf
*/

disableSerialization;
if(count life_var_phoneTarget < 1) exitWith {false};
private _display = findDisplay 8500;
if(isNull _display) exitWith {false};
private _sendLoc = cbChecked (_display displayCtrl 4005);
private _text = ctrlText (_display displayCtrl 4001);
if(count _text < 1) exitWith {false}; 

private _trigger = false;
{
	if(_x in toArray "`{}<>") exitWith {
		_trigger = true;
	};
} foreach toArray _text; 
if(_trigger) exitWith {hint "Please remove any restricted characters inside your text. Restricted Characters: `{}<>"};

private _BEGuid = call(player getVariable ["BEGUID",{""}]);
[life_var_phoneTarget#1,_text,_sendLoc,_BEGuid,life_var_phoneTarget#2] remoteExecCall ["MPServer_fnc_clientMessageRequest",2];

closeDialog 0;
[] spawn MPClient_fnc_cellphone_show;
hint "Message Sent!";

true