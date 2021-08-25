/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_logmessage","",[""]]
];
 
if(!isServer)exitwith{false};
if(count _logmessage < 2)exitwith{false};

_logmessage = format["[RCON SYSTEM]: %1",_logmessage];

if(getNumber(configFile >> "CfgRCON" >> "conlogs") isEqualTo 1)then{
	format ["#debug %1", _logmessage] call life_fnc_rcon_sendCommand;
}else{
	if(getNumber(configFile >> "CfgRCON" >> "rptlogs") isEqualTo 1)then{
		diag_log _logmessage;
	};
};

if(getNumber(configFile >> "CfgRCON" >> "extlogs") isEqualTo 1)then{
    //"" callExtension format["",_logmessage]
};

true