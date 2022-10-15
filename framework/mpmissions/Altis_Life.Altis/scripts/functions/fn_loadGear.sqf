#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
    ["_player",player,[objNull]],
    ["_gear",[],[[]]], 
    ["_isDead",false,[false]]
];

_gear params [
    ["_loadout",[],[[]]],
    ["_vItems",[],[[]]]
];

//--- Remove all gear
[_player,_isDead] call MPClient_fnc_stripDownPlayer;

//--- Carry Weight
life_maxWeight = CFG_MASTER(getNumber,"total_maxWeight");

//--- Get New Loadout
if(count _loadout isEqualTo 0)exitWith{
    systemChat "Geting Deafult Gear...";
    [] call MPClient_fnc_startLoadout;
    true
};

systemChat "Loading Gear...";

//--- Set last Loadout
_player setUnitLoadout _loadout;

//--- Adjust Carry Weight
if (count(backpack _player) > 0) then {
    life_maxWeight =  CFG_MASTER(getNumber,"total_maxWeight") + round(FETCH_CONFIG2(getNumber,"CfgVehicles",(backpack _player),"maximumload") / 4)
};

//--- Set last virtualItems
if(count _vitems > 0)then{
    systemChat "Loading Virtual Items...";
    systemChat format["_vitems => %1",str _vitems];
    {["ADD",_x#0,_x#1] call MPClient_fnc_handleVitrualItem} forEach _vitems;
};

true