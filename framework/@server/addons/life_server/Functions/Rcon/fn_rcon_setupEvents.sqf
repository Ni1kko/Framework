/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

"Initializing events!" call life_fnc_rcon_systemlog;

if(getNumber (configFile >> "CfgRCON" >> "useRestartMessages") isEqualTo 1)then{
	life_var_rcon_RestartMessages = getArray(configFile >> "CfgRCON" >> "restartWarningTime");
};

waitUntil {(missionNamespace getVariable ["life_server_isReady",false])};

if (life_var_rcon_passwordOK AND life_var_rcon_serverLocked) then
{
	"#unlock" call life_fnc_rcon_sendCommand;
	life_var_rcon_serverLocked = false;
	"Lock Event: server unlocked and accepting players!" call life_fnc_rcon_systemlog; 
};

private _starttime = diag_tickTime;
"Events thread initialized!" call life_fnc_rcon_systemlog;


while {true} do {
	private _uptime = call compile("extDB3" callExtension "9:UPTIME:MINUTES");
	private _timeTilRestart = life_var_rcon_RestartTime - _uptime;

	if (typeName life_var_rcon_RestartMessages isEqualTo "ARRAY") then 
	{
		//--- Warning messages
		if !(life_var_rcon_RestartMessages isEqualTo []) then {
			{ 
				if (_timeTilRestart < _x) then {
					format["Server is going to restart in %1 min! Log out before the restart to prevent gear loss.", _x] remoteExec ["hint",-2]; 
					life_var_rcon_RestartMessages deleteAt _forEachIndex;
					format ["Restart Event: Warnings for %1min sent",_x] call life_fnc_rcon_systemlog;
				};
			} forEach life_var_rcon_RestartMessages;
		};
	};

	if (_timeTilRestart < life_var_rcon_LockTime) then 
	{
		//--- Auto Lock
		if !(life_var_rcon_serverLocked) then {
			"#lock" call life_fnc_rcon_sendCommand;
			"Lock Event: Server locked for restart" call life_fnc_rcon_systemlog;
			"You will be kicked off the server due to a restart." remoteExec ["hint",-2]; 
			life_var_rcon_serverLocked = true;
		};

		//--- Auto kick
		if (_timeTilRestart < life_var_rcon_KickTime) then {
			if !(life_var_rcon_RestartMode) then {
				call life_fnc_rcon_kickAll;
				"Kick Event: Everyone kicked for restart" call life_fnc_rcon_systemlog;
				life_var_rcon_RestartMode = true;
				if(getNumber(configFile >> "CfgRCON" >> "useShutdown") isEqualTo 1)then{
					'#shutdown' call life_fnc_rcon_sendCommand;
				}else{
					'#restart' call life_fnc_rcon_sendCommand;
				};
			};
		};
	};

	format["Events heartbeat, Thread Still Active - RCON UPTIME: (%1)mins",round((diag_tickTime - _starttime) / 60)] call life_fnc_rcon_systemlog;
	
	uiSleep 30;
};