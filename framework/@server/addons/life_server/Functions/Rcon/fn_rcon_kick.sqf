/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_id",0,[0]],
	["_msg",""]
];

format ["#kick %1", _id] call life_fnc_rcon_sendCommand;

if(_msg isNotEqualTo "")then{
	_msg call life_fnc_rcon_systemlog;
	if(getNumber(configFile >> "CfgRCON" >> "dblogs") isEqualTo 1)then{
		 
	};
};

true