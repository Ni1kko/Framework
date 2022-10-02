#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updatePlayerDataPartial.sqf (Client)
*/
 
private _packetData = createHashMapFromArray [
    ["Mode",param [0,-1]],
    ["NetID",netID player],
    ["Alive",life_var_alive]
];

switch (_packetData get "Mode") do 
{
    //-- Licenses    
    case 2: {_packetData set ["Licenses",[player] call MPClient_fnc_getLicenses]};
    //-- Gear
    case 3: {_packetData set ["Gear",[player] call MPClient_fnc_getGear]};
    //-- Arrested
    case 5: {_packetData set["Arrested",life_var_arrested]};
    //-- Keychain
    case 7: {_packetData set ["LocalKeys",(life_Var_vehicles apply {netID _x})]};
};

[_packetData] remoteExecCall ["MPServer_fnc_updatePlayerDataRequestPartial",RE_SERVER];

true