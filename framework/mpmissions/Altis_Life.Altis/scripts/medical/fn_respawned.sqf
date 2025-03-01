#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
params [
    ["_unit",objNull,[objNull]],
    ["_arrested",false,[false]]
];

//-- Disable waitUntil due to noticing script hanging at line 11 with diag_activeSQFScripts... output was: (["MPClient_fnc_deathScreen", "mpmissions\__CUR_MP.Altis\scripts\medical\fn_respawned.sqf", true, 11])
//waitUntil {sleep 0.1; _unit isNotEqualTo player};

//--- Reset our player vars
life_var_ATMEnabled = true;
life_var_isBusy = false;
life_var_hunger = 100;
life_var_thirst = 100;

//--- Play animation
player playMove "AmovPercMstpSnonWnonDnon";
 
//-- Set some vars on our new body.
{player setVariable _x} forEach [
    ['restrained',false,true],
    ['Escorting',false,true],
    ['transporting',false,true],
    ['playerSurrender',false,true],
    ['steam64id',getPlayerUID player,true],
    ['realname',profileName,true],
    ["lifeState","HEALTHY",true],
    ["arrested",_arrested,true]
];

//-- Fatigue
if (CFG_MASTER(getNumber,"enable_fatigue") isEqualTo 0) then {player enableFatigue false;};
 
//-- Handle side chat
[player,life_var_enableSidechannel,playerSide] remoteExecCall ["MPServer_fnc_managesc",2];

//--- Database sync
[] call MPClient_fnc_updatePlayerData;

//-- Died whilst jailed
if (player getVariable ["arrested",false]) exitWith {
    hint localize "STR_Jail_Suicide";
    player setVariable ["arrested",false,true];
    [player,true] spawn MPClient_fnc_jail;
    [] call MPClient_fnc_updatePlayerData;
};

//-- Johnny law got me but didn't let the EMS revive me, reward them half the bounty.
if (!isNil "life_copRecieve") then {
    [getPlayerUID player,player,life_copRecieve,true] remoteExecCall ["MPServer_fnc_wantedBounty",2];
    life_copRecieve = nil;
};

//-- So I guess a fellow gang member, cop or myself killed myself so get me off that Altis Most Wanted
if (life_var_removeWanted) then {
    [getPlayerUID player] remoteExecCall ["MPServer_fnc_wantedRemove",2];
};

//--
[player] call life_fnc_leaveCombat;
[player] call life_fnc_leaveNewLife;

//--- Give them a default loadout
[] call MPClient_fnc_startLoadout;

//--- Spawn Them
private _spawnPlayerThread = [false] spawn MPClient_fnc_spawnPlayer;
waitUntil {scriptDone _spawnPlayerThread};

//--- Play animation
player playMoveNow "AmovPpneMstpSrasWrflDnon";

//--- Add actions to new player
[] call MPClient_fnc_setupActions;

true