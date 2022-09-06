#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

waitUntil {!(isNull (findDisplay 46))};
[] call MPClient_fnc_stripDownPlayer;

//--- Loadout
if(count life_var_loadout > 0)then{
    player setUnitLoadout life_var_loadout;
}else{
    [] call MPClient_fnc_startLoadout;
};

//--- Carry Weight
life_maxWeight = if (backpack player isEqualTo "") then {LIFE_SETTINGS(getNumber,"total_maxWeight")} else {LIFE_SETTINGS(getNumber,"total_maxWeight") + round(FETCH_CONFIG2(getNumber,"CfgVehicles",(backpack player),"maximumload") / 4)};

//--- VirtualItems
{
    [true,(_x select 0),(_x select 1)] call MPClient_fnc_handleInv;
} forEach life_var_vitems;


[] call MPClient_fnc_playerSkins;