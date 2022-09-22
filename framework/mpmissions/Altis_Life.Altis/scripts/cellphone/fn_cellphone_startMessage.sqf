#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_startMessage.sqf
*/
disableSerialization;
_display = findDisplay 8500;
if(isNull _display) exitWith {};
_playerList = _display displayCtrl 1500;
_id = lbCurSel _playerList;
if(_id < 0) exitWith {hint "Please select a player/service."};
_receiver = _playerList lbData (lbCurSel _playerList);
_receiver = call compile _receiver;
_writingTo = _display displayCtrl 4000;
[true] call MPClient_fnc_cellphone_switchDialog;  
_receiverName = switch (_receiver select 1) do
{
	case "XXX-REQ-PLAYER": {_receiver select 0};
	case "999-REQ-POLICE": {"Police Dispatch Centre"};
	case "999-REQ-MEDIC":  {"NHS Dispatch Centre"}; 
	case "XXX-REQ-ADMIN":  {"Admin Message - Emergencies Only!"};
};

life_cellphone_receiver = _receiver;
_writingTo ctrlSetText format["Writing to %1", _receiverName];

true