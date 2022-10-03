/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_vehicleGarageOpen.sqf
*/

(_this#3)params [
	["_type", "", [""]],
	["_spawnpoint", [], ["",[]]]
];

life_garage_type = _type;
life_garage_sp = _spawnpoint;

private _displayName = "RscDisplayVehicleGarage";
private _display = createDialog [_displayName,true];
private _controlTitle = (_display displayCtrl 2802);

_controlTitle ctrlSetText (localize "STR_ANOTF_QueryGarage");

[player,_type] remoteExec ["MPServer_fnc_getVehicles",RE_SERVER];

_display