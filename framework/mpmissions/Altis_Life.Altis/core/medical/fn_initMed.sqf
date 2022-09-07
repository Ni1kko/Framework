/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/
params [
	["_player",objNull,[objNull]],
	["_exitCode",{[_this#2,false,true] call BIS_fnc_endMission}]
];

if (life_blacklisted) exitWith {
    ["Sorry No Can Do!", "You are blacklisted from joining this faction", "Blacklisted"] call _exitCode;
};

if ((call life_medLevel) isEqualTo 0 AND (call life_adminlevel) isEqualTo 0) exitWith {
    ["Sorry No Can Do!", "You are not whitelisted to join this faction", "Notwhitelisted"] call _exitCode;
};

player setVariable ["rank",call life_medLevel,true];

true