#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_cellphone_messageKeyUp.sqf
*/

disableSerialization;
private _display = findDisplay 8500;
if(isNull _display) exitWith {};
private _ctrl = _display displayCtrl 4001;
private _charText = _display displayCtrl 4003;

if(count (ctrlText _ctrl) > 1500) exitWith {
	private _charArr = toArray(ctrlText _ctrl);
	_charArr resize 1500;
	_ctrl ctrlSetText (toString _charArr);
}; 

_charText ctrlSetText format["%1/1500",count (ctrlText _ctrl)];

false