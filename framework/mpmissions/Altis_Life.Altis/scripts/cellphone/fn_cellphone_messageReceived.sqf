#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_messageReceived.sqf
*/
disableSerialization;
params['_senderName','_senderBEGuid','_cellphoneMode','_receiverBEGuid','_message','_pos'];

if(_senderName == "" || _message == "") exitWith {};
private _hasPos = true;
if(_pos isEqualTo "Unknown") then {_hasPos = false;};

private _exit = true;
switch (true) do
{
	case (_cellphoneMode == "999-REQ-POLICE" && playerSide == west): {_exit = false;};
	case (_cellphoneMode == "999-REQ-MEDIC" && playerSide == independent): {_exit = false;};
	case (_cellphoneMode == "XXX-REQ-ADMIN" && ((call life_adminlevel) > 0)): {_exit = false;}; 
	case (_cellphoneMode == "XXX-REQ-PLAYER"): {_exit = false;};
};

if(_exit) exitWith {};

private _msgData = switch (_cellphoneMode) do {
	case "XXX-REQ-PLAYER": {["Text Message", "textures\icons\mobile\textmsg.paa", format["Text From: %1", _senderName]]};
	case "999-REQ-POLICE": {["Police Dispatch","\A3\ui_f\data\gui\Rsc\RscDisplayMultiplayerSetup\disabledai_ca.paa","Police Dispatch Received"]};
	case "999-REQ-MEDIC":  {["NHS Dispatch","textures\icons\mobile\nhs.paa","NHS Dispatch Received"]}; 
	case "XXX-REQ-ADMIN":  {["Admin Request","textures\icons\mobile\admin.paa","Admin Request Received"]};  
};

["Message",_msgData] call bis_fnc_showNotification;

life_var_phoneMessages pushBack [_senderName, _senderBEGuid, _cellphoneMode, _message, _pos, false, date];
//life_var_phoneMessages pushBack [_cellphoneMode, _message, _pos, _senderName, _senderBEGuid, _receiverBEGuid];

true