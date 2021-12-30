/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false}; 
if(!isNil "life_var_rcon_serverLocked")exitwith{false};
 
life_var_rcon_RestartTimes = getArray (configFile >> "CfgRCON" >> "restartTimes");
life_var_rcon_KickTime = getNumber (configFile >> "CfgRCON" >> "kickTime");
life_var_rcon_LockTime = getNumber (configFile >> "CfgRCON" >> "restartAutoLock");
life_var_rcon_UseAutokick = getNumber (configFile >> "CfgRCON" >> "useAutoKick");
life_var_rcon_FriendlyMessages = getArray(configFile >> "CfgRCON" >> "friendlyMessages");
life_var_rcon_RestartMessages = false;
life_var_rcon_passwordOK = false;
life_var_rcon_serverLocked = false;
life_var_rcon_RestartTime = 0;
life_var_rcon_RestartMode = 0;
life_var_rcon_upTime = 0;
life_var_rcon_RealTime = "12:00";
life_var_rcon_messagequeue = [];
life_var_rcon_setupEvents_thread = scriptNull;
life_var_rcon_nextRestart = "12:00";

"Starting RCON" call life_fnc_rcon_systemlog;

private _dateTime = (call compile ("extDB3" callExtension "9:LOCAL_TIME")) select 1;	
private _time = ((_dateTime select [3,2]) apply {if(_x < 10)then{"0" + str _x}else{str _x}}) joinString ":";

{
	//if(parseNumber('Time' callExtension format["subtract-%1,%2",_x,_time]) > 0)exitWith{
	if(parseNumber(_x select [0,2]) > parseNumber(_time select [0,2]))exitWith{
		life_var_rcon_nextRestart = _x;
	};
} forEach life_var_rcon_RestartTimes;

{publicVariable _x} forEach [
	"life_var_rcon_passwordOK",
	"life_var_rcon_RestartTime",
	"life_var_rcon_upTime",
	"life_var_rcon_RealTime",
	"life_var_rcon_RestartMode"
];

if ("#init/" call life_fnc_rcon_sendCommand) then
{
	"Lock Event: server locked for init" call life_fnc_rcon_systemlog;
	[] call life_fnc_rcon_kickAll;
	life_var_rcon_setupEvents_thread = [] spawn life_fnc_rcon_setupEvents;
};

true