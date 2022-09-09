/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/
params [
	["_player",objNull,[objNull]],
	["_exitCode",{[_this#2,false,true] call BIS_fnc_endMission}]
];

if (life_blacklisted) exitWith {
    ["Sorry No Can Do!", "You are blacklisted from joining this faction", "Blacklisted"] call _exitCode;
};

if ((call life_coplevel) isEqualTo 0 AND (call life_adminlevel) isEqualTo 0) then {
    ["Sorry No Can Do!", "You are not whitelisted to join this faction", "Notwhitelisted"] call _exitCode;
};

_player setVariable ["rank",call life_coplevel,true];

true