/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _message = ctrlText 9922;
if ((call life_adminlevel) < 4) exitWith {closeDialog 0; hint localize "STR_ANOTF_ErrorLevel";};

private _player = (missionNamespace getVariable ["life_var_admintarget",objNull]);
if(isNull _player)exitwith{hint localize "STR_NOTF_ActionCancel";closeDialog 0;};

private _steamID = getPlayerUID _player;
if(_steamID isEqualTo "")exitwith{hint localize "STR_NOTF_ActionCancel";closeDialog 0;};

private _confirmBan = [format ["Reason: %1", _message],format["Ban %1 [%2] ",name _player,_steamID],"Confirm","Abort"] call BIS_fnc_guiMessage;
if !(_confirmBan) exitwith {hint localize "STR_NOTF_ActionCancel";closeDialog 0;};

[_steamID,_message] remoteExec ["life_fnc_rcon_ban",2];
life_var_admintarget = objNull;

hint format["User %1 Banned",name _player];
closeDialog 0;