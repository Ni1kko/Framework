#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_messageShow.sqf
*/
disableSerialization;
_display = findDisplay 8500;
_messageList = _display displayCtrl 1501;
lnbClear _messageList;
for "_i" from count life_var_phoneMessages -1 to 0 step -1 do {
	_item = life_var_phoneMessages select _i;
	_excerpt = [_item select 3,23] call {
		private["_in","_len","_arr","_out"];
		_in=_this select 0;
		_len=(_this select 1)-1;
		_arr=[_in] call KRON_StrToArray;
		_out="";
		if (_len>=(count _arr)) then {
			_out=_in;
		} else {
			for "_i" from 0 to _len do {
				_out=_out + (_arr select _i);
			};
		};
		_out
	};
	if(_excerpt != _item select 3) then {_excerpt = _excerpt + "...";};
	_excerpt = [_excerpt, "\n", ""] call KRON_Replace;
	_msgType = switch (_item select 2) do
	{
		case "XXX-REQ-PLAYER": {"Text Message"};
		case "999-REQ-POLICE": {"Police Dispatch"};
		case "999-REQ-MEDIC":  {"NHS Dispatch"}; 
		case "XXX-REQ-ADMIN":  {"Admin Message"}; 
	};
	_messageList lnbAddRow [_item select 0, _msgType, _excerpt, if(_item select 5) then {"Viewed"} else {"New"}];
	_messageList lnbSetValue[[((lnbSize _messageList) select 0)-1,0],_i];
};

true