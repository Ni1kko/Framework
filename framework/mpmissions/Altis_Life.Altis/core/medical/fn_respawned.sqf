#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

//--- Reset our player vars
life_var_isBusy = false;
life_var_ATMEnabled = true;
life_var_hunger = 100;
life_var_thirst = 100;
life_var_carryWeight = 0;
life_var_cash = 0; //Make sure we don't get our cash back.
life_is_alive = false;

//--- Play animation
player playMove "AmovPercMstpSnonWnonDnon";

//-- Died whilst jailed
if (life_is_arrested) exitWith {
    hint localize "STR_Jail_Suicide";
    life_is_arrested = false;
    [player,true] spawn MPClient_fnc_jail;
    [] call MPClient_fnc_updateRequest;
};

//-- Johnny law got me but didn't let the EMS revive me, reward them half the bounty.
if (!isNil "life_copRecieve") then {
    [getPlayerUID player,player,life_copRecieve,true] remoteExecCall ["MPServer_fnc_wantedBounty",RSERV];
    life_copRecieve = nil;
};

//-- So I guess a fellow gang member, cop or myself killed myself so get me off that Altis Most Wanted
if (life_removeWanted) then {
    [getPlayerUID player] remoteExecCall ["MPServer_fnc_wantedRemove",RSERV];
};

//-- Set some vars on our new body.
{player setVariable _x} forEach [
    ['restrained',false,true],
    ['Escorting',false,true],
    ['transporting',false,true],
    ['playerSurrender',false,true],
    ['steam64id',getPlayerUID player,true],
    ['realname',profileName,true]
];

[] call MPClient_fnc_startLoadout;
[] call MPClient_fnc_setupActions;

//-- Fatigue
if (LIFE_SETTINGS(getNumber,"enable_fatigue") isEqualTo 0) then {player enableFatigue false;};

//--- Spawn Them
private _spawnPlayerThread = [false] spawn MPClient_fnc_spawnPlayer;
waitUntil {scriptDone _spawnPlayerThread};

//--- Play animation
player playMoveNow "AmovPpneMstpSrasWrflDnon";
 
//-- Handle side chat
[player,life_settings_enableSidechannel,playerSide] remoteExecCall ["MPServer_fnc_managesc",RSERV];

//--- Database sync
[] call MPClient_fnc_updateRequest;

true