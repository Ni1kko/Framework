#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryKeysGive.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;

//-- Close display of the control that was clicked
if(not(isNull _ctrlParent))then{
	//_ctrlParent closeDisplay 1;
};

_ctrlParent = findDisplay 2700;
private _list = _ctrlParent displayCtrl 4;
private _plist = _ctrlParent displayCtrl 5;
private _sel = lbCurSel _list;

if ((_list lbData _sel) isEqualTo "") exitWith {hint localize "STR_NOTF_didNotSelectVehicle";};
private _vehicle = _list lbData _sel;
_vehicle = life_var_vehicles select parseNumber(_vehicle);

if ((lbCurSel 5) isEqualTo -1) exitWith {hint localize "STR_NOTF_didNotSelectPlayer";};
_sel = lbCurSel _plist;
private _unit = _plist lbData _sel;
_unit = call compile format ["%1", _unit];
if (isNull _unit || isNil "_unit") exitWith {};
if (_unit == player) exitWith {};

private _uid = getPlayerUID _unit;
private _owners = _vehicle getVariable "vehicle_info_owners";
private _index = [_uid,_owners] call MPServer_fnc_index;
if (_index isEqualTo -1) then  {
    _owners pushBack [_uid,_unit getVariable ["realname",name _unit]];
    _vehicle setVariable ["vehicle_info_owners",_owners,true];
};

hint format [localize "STR_NOTF_givenKeysTo",_unit getVariable ["realname",name _unit],typeOf _vehicle];
[_vehicle,_unit,profileName] remoteExecCAll ["MPServer_fnc_clientGetKey",_unit];

true