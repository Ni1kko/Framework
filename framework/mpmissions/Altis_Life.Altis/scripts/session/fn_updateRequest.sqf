#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
 
private _var = format["Sync_%1_Completed_%2",round(random[1000,5000,9999]),round diag_tickTime];

[
    _var,
    player,
    MONEY_CASH,
    MONEY_BANK,
    ([player] call MPClient_fnc_getLicenses),
    ([player] call MPClient_fnc_getGear),
    [life_var_hunger,life_var_thirst],
    life_is_arrested,
    alive player,
    getPosATL player
] remoteExecCall ["MPServer_fnc_updateRequest",2];

//Prevent spamming server
life_var_lastSynced = time;

_var