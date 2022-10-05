#include "..\..\script_macros.hpp"
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

//--- Loadout
if(count _loadout > 0)then{
    _player setUnitLoadout _loadout;
}else{
    [] call MPClient_fnc_startLoadout;
};

//--- Carry Weight
life_maxWeight = if (backpack _player isEqualTo "") then {CFG_MASTER(getNumber,"total_maxWeight")} else {CFG_MASTER(getNumber,"total_maxWeight") + round(FETCH_CONFIG2(getNumber,"CfgVehicles",(backpack _player),"maximumload") / 4)};

//--- VirtualItems
if(count _vitems > 0)then{
    {[true,_x#0,_x#1] call MPClient_fnc_handleInv} forEach _vitems;
};

true