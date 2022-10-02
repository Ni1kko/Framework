#include "\life_backend\script_macros.hpp"
/*
    File: fn_clientDisconnect.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    When a client disconnects this will remove their corpse and
    clean up their storage boxes in their house. Also, saves player infos & position.
*/
params [
    ["_unit",objNull,[objNull]],
    "",
    ["_uid","",[""]]
];
if (isNull _unit) exitWith {};

//Save civilian position
 
if (isNil "HC_UID" || {!(_uid isEqualTo HC_UID)}) then {
    private _position = getPosATL _unit;
    if ((getMarkerPos "respawn_civilian" distance _position) > 300) then {
        [_uid,civilian,alive _unit,4,_position] spawn MPServer_fnc_updatePlayerDataRequestPartial;
    };
};


if !(alive _unit) then {
    [format["%1 disconnected while dead.",_uid]] call MPServer_fnc_log;
} else {
    {
        _x params [
            ["_corpseUID","",[""]],
            ["_corpse",objNull,[objNull]]
        ];
        if (_corpseUID isEqualTo _uid) exitWith {
            if (isNull _corpse) exitWith {life_var_corpses deleteAt _forEachIndex};
            [_corpse] remoteExecCall ["MPClient_fnc_corpse",0];
            [format["%1 disconnected while dead.",_corpseUID]] call MPServer_fnc_log;
            life_var_corpses deleteAt _forEachIndex;
        };
    } forEach life_var_corpses;
};

private _containers = nearestObjects[_unit,["WeaponHolderSimulated"],5];
{deleteVehicle _x} forEach _containers;
deleteVehicle _unit;

[_uid] spawn MPServer_fnc_houseCleanup;
