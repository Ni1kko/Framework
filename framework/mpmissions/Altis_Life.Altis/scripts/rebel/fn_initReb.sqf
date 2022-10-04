/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_initReb.sqf
*/
params [
	["_player",objNull,[objNull]]
];

if (life_blacklisted) exitWith {
    ["Sorry No Can Do!", "You are blacklisted from joining whitelisted factions", "Blacklisted"] call MPClient_fnc_endMission;
};

if ((call life_reblevel) isEqualTo 0) exitWith {
    ["Sorry No Can Do!", "You are not whitelisted to join this faction", "Notwhitelisted"] call MPClient_fnc_endMission;
};

player setVariable ["rank",call life_reblevel,true];

true