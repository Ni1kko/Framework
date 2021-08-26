/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(life_var_antihack_networkReady)exitwith{false};
if(isRemoteExecuted)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_antihack_setupNetwork.sqf`"] call life_fnc_rcon_ban;};

params[
	["_antihack","",[""]],
	["_netVar","",[""]],
	["_sysVar","",[""]]
];

if(_antihack isEqualTo "" || _netVar isEqualTo "")exitwith{false};

//--- Compile Antihack
private _compiletime = diag_tickTime;
["Compiling Antihack Thread"] call life_fnc_antihack_systemlog;
_antihack = compile _antihack;
[format["Antihack Thread Compiled... compile took %1 seconds",(diag_tickTime - _compiletime)]] call life_fnc_antihack_systemlog;

//--- Setup network handler
_netVar addPublicVariableEventHandler {
	params [
		["_var",""],
		["_data", []]
	];
	
	if(count _data isEqualTo 0)exitWith{};

	_data params['_key','_SteamID','_value'];

	switch (_key) do {
		case "kick": {
			[_value,["KICK",_SteamID]] call life_fnc_antihack_systemlog;
			[_SteamID,_value] call life_fnc_rcon_kick;
		};
		case "ban": { 
			[_value,["BAN",_SteamID]] call life_fnc_antihack_systemlog;
			[_SteamID,_value] call life_fnc_rcon_ban;
		};
		case "run-server": { 
			_value params['_params','_code'];  
			if(_code isEqualType '') then {
				_code = missionNamespace getVariable [_funcName,{}];
			};
			_params spawn _code; 
		};
		case "run-target": { 
			_value params['_target','_params','_code']; 
			if(_code isEqualType '') then {
				_params remoteExec [_code,_target];
			} else {
				[_params,_code] remoteExec ['call',_target];
			};
		};
		case "run-global": { 
			_value params['_params','_code'];
			if(_code isEqualType '') then {
				_params remoteExec [_code,0];
			} else {
				[_params,_code] remoteExec ['call',0];
			}; 
		};
	};

	missionNamespace setvariable [_var,nil];
    publicVariable _var;
};

//--- Setup network handler
_sysVar addPublicVariableEventHandler {
	params [
		["_var",""],
		["_data", []]
	];
	
	if(count _data isNotEqualTo 3)exitWith{};

	_data params['_rnd_var','_time','_SteamID'];

	private _BEGuid = ('BEGuid' callExtension ("get:"+_SteamID));
	private _arr = missionNamespace getvariable [_rnd_var,[]];

	_arr pushBackUnique [_time,_BEGuid];
	missionNamespace setvariable [_rnd_var,_arr];

	missionNamespace setvariable [_var,nil];
    publicVariable _var;
};

//---
life_var_antihack_networkReady = true;

//--- Send Compiled Code
while {true} do {
	["",_antihack] remoteExec ["spawn", -2];
	uiSleep (random [3,5,7]);
};