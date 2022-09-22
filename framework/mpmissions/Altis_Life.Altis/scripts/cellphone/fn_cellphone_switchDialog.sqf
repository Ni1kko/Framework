#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_switchDialog.sqf
*/

disableSerialization;
private _isMsg = [_this,0,false,[false]] call BIS_fnc_param;

private _display = findDisplay 8500;
if(isNull _display) exitWith {};

private _myMessages = [1002, 1501, 1003, 1004];
private _sendMessage = [4000,4001,4002,4003,4004,4005,4006,4007,4008];

private _replyMsg = _display displayCtrl 2401;
private _cancelMsg = _display displayCtrl 4008;

if(_isMsg) then {
	_replyMsg ctrlSetText "Send Message";
	_replyMsg buttonSetAction "[] call MPClient_fnc_cellphone_sendMessage;";
	_cancelMsg buttonSetAction "[] call MPClient_fnc_cellphone_sendMessageCancel;";
} else {
	_replyMsg ctrlSetText "Reply";
	_replyMsg buttonSetAction "[] call MPClient_fnc_cellphone_reply;";
};

_replyMsg ctrlShow true;

{
	_ctrl = _display displayCtrl _x;
	_ctrl ctrlShow (!_isMsg);
} forEach _myMessages;

{
	_ctrl = _display displayCtrl _x;
	_ctrl ctrlShow (_isMsg);
} forEach _sendMessage;

true