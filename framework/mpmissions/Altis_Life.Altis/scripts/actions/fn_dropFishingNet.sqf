/*
    File: fn_dropFishingNet.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Drops a virtual fishing net from the boat.
*/
private ["_fish","_type","_typeName"];
if (!(vehicle player isKindOf "Ship")) exitWith {};
_fish = (nearestObjects[getPos vehicle player,["Fish_Base_F"],20]);
life_var_fishingNetOut = true;
titleText[localize "STR_NOTF_NetDrop","PLAIN"];
sleep 5;
if (_fish isEqualTo []) exitWith {titleText[localize "STR_NOTF_NetDropFail","PLAIN"]; life_var_fishingNetOut = false;};
{
    private _typeStr = [_x] call  MPServer_fnc_util_getTypeString;
    if (_typeStr isEqualTo "Fish") then {
        switch (true) do {
            case ((typeOf _x) isEqualTo "Salema_F"): {_typeName = localize "STR_ANIM_Salema"; _type = "salema_raw";};
            case ((typeOf _x) isEqualTo "Ornate_random_F") : {_typeName = localize "STR_ANIM_Ornate"; _type = "ornate_raw";};
            case ((typeOf _x) isEqualTo "Mackerel_F") : {_typeName = localize "STR_ANIM_Mackerel"; _type = "mackerel_raw";};
            case ((typeOf _x) isEqualTo "Tuna_F") : {_typeName = localize "STR_ANIM_Tuna"; _type = "tuna_raw";};
            case ((typeOf _x) isEqualTo "Mullet_F") : {_typeName = localize "STR_ANIM_Mullet"; _type = "mullet_raw";};
            case ((typeOf _x) isEqualTo "CatShark_F") : {_typeName = localize "STR_ANIM_Catshark"; _type = "catshark_raw";};
            default {_type = "";};
        };
 
        sleep 3;

        if (["ADD",_type,1] call MPClient_fnc_handleVitrualItem) then {
            deleteVehicle _x;
            titleText[format [(localize "STR_NOTF_Fishing"),_typeName],"PLAIN"];
        };
    };
} forEach (_fish);

sleep 1.5;
titleText[localize "STR_NOTF_NetUp","PLAIN"];
life_var_fishingNetOut = false;
