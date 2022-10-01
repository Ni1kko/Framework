#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_reply.sqf
*/

disableSerialization;
private _display = findDisplay 8500;
if(isNull _display) exitWith {false};
private _messageList = _display displayCtrl 1501;
private _id = lbCurSel _messageList;
if(_id < 0) exitWith {hint "Please select a message that you want to reply to."; false};
private _messageIndex = _messageList lnbValue[(lbCurSel _messageList),0];
private _receiver = life_var_phoneMessages select _messageIndex;
private _writingTo = _display displayCtrl 4000;
[true] call MPClient_fnc_cellphone_switchDialog; //Change our dialog over.

//MSG TYPES  0: MSG 1: POLREQ 2: NHSREQ 3: ARAC 4: TAXI
life_var_phoneTarget = [_receiver#0, "XXX-REQ-PLAYER", _receiver#1, ""];
_writingTo ctrlSetText format["Writing to %1", _receiver#0];

true