/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

"Starting RCON" call life_fnc_rcon_systemlog;

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

if (getNumber(configFile >> "CfgRCON" >> "useAutoLock") isEqualTo 1) then 
{
	private _passwordCorrect = "#lock" call life_fnc_rcon_sendCommand;
	if (_passwordCorrect) then
	{
		"Server locked for init" call life_fnc_rcon_systemlog;
		life_var_rcon_serverLocked = true;
		life_var_rcon_passwordOK = true; 
		call life_fnc_rcon_kickAll;
	} else {
		"ServerPassword MISMATCH!!! RCON features DISABLED!" call life_fnc_rcon_systemlog; 
	};
} else {
	"Server Auto Lock DISABLED!" call life_fnc_rcon_systemlog; 
};

life_var_rcon_setupEvents_thread = [] spawn life_fnc_rcon_setupEvents;