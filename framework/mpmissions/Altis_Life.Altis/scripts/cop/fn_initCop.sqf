/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_initCop.sqf
*/
params [
	["_player",objNull,[objNull]]
];

if (life_blacklisted) exitWith {
    ["Sorry No Can Do!", "You are blacklisted from joining whitelisted factions", "Blacklisted"] call MPClient_fnc_endMission;
};

if ((call life_coplevel) isEqualTo 0) then {
    ["Sorry No Can Do!", "You are not whitelisted to join this faction", "Notwhitelisted"] call MPClient_fnc_endMission;
};

_player setVariable ["rank",call life_coplevel,true];

true