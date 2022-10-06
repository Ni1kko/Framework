#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_messageSelect.sqf
*/

disableSerialization;
private _display = findDisplay 8500;
if(isNull _display) exitWith {};
private _messageList = _display displayCtrl 1501;
private _messageViewer = _display displayCtrl 1004;
if(lbCurSel _messageList < 0) exitWith {};
private _messageIndex = _messageList lnbValue[(lbCurSel _messageList),0];
private _messageData = life_var_phoneMessages select _messageIndex;

private _postion = "Sender Position: Withheld";
if((_messageData#4) isNotEqualTo "Unknown") then {
	_postion = format["Sender Position: %1", _messageData#4];
};

_text = _messageData#3; 
_text = [_text, "&", "&amp;"] call KRON_Replace;
_text = [_text, "<", ""] call KRON_Replace;
_text = [_text, ">", ""] call KRON_Replace;

_textToFilter = _text;
_filter = "`{}<>";
_textToFilter = toArray _textToFilter;
_filter = toArray _filter;
_trigger = false;
{
	if(_x in _filter) exitWith {
		_trigger = true;
	};
} foreach _textToFilter;
if(_trigger) exitWith {};

_text = [_text, "\n", "<br/>"] call KRON_Replace;
_messageViewer ctrlSetStructuredText parseText format[
	"Sender: %1<br/>Date: %4/%5/%6<br/>%2<br/><br/>%3",
	_messageData#0,
	_postion,
	_text,
	(_messageData#6)#2,
	(_messageData#6)#1,
	(_messageData#6)#0
];

(life_var_phoneMessages select _messageIndex) set [5, true];
[] call MPClient_fnc_cellphone_messageShow;

true