/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isRemoteExecuted)exitwith{false};

private _restartTime = getArray (configFile >> "CfgRCON" >> "restartTimer");
life_var_rcon_RestartTime = ((_restartTime select 0) * 60) + (_restartTime select 1);
life_var_rcon_KickTime = getNumber (configFile >> "CfgRCON" >> "kickTime");
life_var_rcon_LockTime = getNumber (configFile >> "CfgRCON" >> "restartAutoLock");
life_var_rcon_UseAutokick = getNumber (configFile >> "CfgRCON" >> "useAutoKick");
life_var_rcon_FriendlyMessages = getArray(configFile >> "CfgRCON" >> "friendlyMessages");
life_var_rcon_RestartMessages = false;
life_var_rcon_passwordOK = false;
life_var_rcon_serverLocked = false;
life_var_rcon_RestartMode = 0;
life_var_rcon_messagequeue = [];
life_var_rcon_setupEvents_thread = scriptNull;

"Starting RCON" call life_fnc_rcon_systemlog;

if ("#init/" call life_fnc_rcon_sendCommand) then
{
	"Lock Event: server locked for init" call life_fnc_rcon_systemlog;
	life_var_rcon_serverLocked = true;
	life_var_rcon_passwordOK = true;
	[] call life_fnc_rcon_kickAll;
	life_var_rcon_setupEvents_thread = [] spawn life_fnc_rcon_setupEvents;
} else {
	"ServerPassword MISMATCH!!! RCON features DISABLED!" call life_fnc_rcon_systemlog; 
};

true