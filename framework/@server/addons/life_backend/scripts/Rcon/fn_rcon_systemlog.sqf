#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_logmessage","",[""]]
];
 
if(!isServer)exitwith{false};
if(count _logmessage < 2)exitwith{false};

private _config = configFile >> "CfgRCON";

_logmessage = format["[RCON SYSTEM]: %1",_logmessage];

if((getNumber(_config >> "conlogs") isEqualTo 1) AND life_var_rcon_passwordOK)then{
	format ["#debug %1", _logmessage] call MPServer_fnc_rcon_sendCommand;
}else{
	if(getNumber(_config >> "rptlogs") isEqualTo 1)then{
		[_logmessage] call MPServer_fnc_log;
	};
};

if(getNumber(_config >> "extlogs") isEqualTo 1)then{
    //"" callExtension format["",_logmessage]
};

true