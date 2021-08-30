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
	["_sysVar","",[""]],
	["_hcvar","",[""]]
];

if(_antihack isEqualTo "" || _netVar isEqualTo "")exitwith{false};

private _selectedHC = [];
private _headlessclient =objNull;
private _compiletime = diag_tickTime;

//--- Compile Antihack
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
		case "log": { 
			[_value#1,[_value#0,_SteamID]] call life_fnc_antihack_systemlog;
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

	_data params['_rnd_playersvar','_netID','_thread_codeone'];
	
	private _player = objectFromNetId _netID;
	private _playerName = name _player;
	private _steamID = getPlayerUID _player;
	private _ownerID = owner _player;
	private _BEGuid = ('BEGuid' callExtension ("get:"+_steamID));
	private _players = missionNamespace getvariable [_rnd_playersvar,[]];
	_players pushBackUnique [_playerName,_BEGuid];
	missionNamespace setvariable [_rnd_playersvar,_players];

	[_thread_codeone,{
			params['_threadtwo_two','_codeone'];
			
			systemChat 'Antihack loaded!';
			uiSleep(random 4);
			
			while {true} do {
				if(isNull (missionNamespace getVariable [_threadtwo_two,scriptNull]))then{
					private _thread = [] spawn _codeone;
					missionNamespace setVariable [_threadtwo_two,_thread];
				};
				uiSleep 2;
			};
		}
	]remoteExec["spawn",_ownerID]; 

	missionNamespace setvariable [_var,nil];
    publicVariable _var;
};

//--- Is ready to transfer main code
life_var_antihack_networkReady = true;

//--- Sends given code to all clients
private _sendAntiHack = {
	params ['_code'];
	{  
		["",_code] remoteExec ["spawn", owner _x];
	} forEach allPlayers - entities "HeadlessClient_F";
};

//--- Starts new thread on given ownerID that loops and sends given code to all clients
private _transferAntiHack = {
	life_var_antihack_networkReady = false; 
	missionNamespace setVariable [_this#2, _this#3];
	[[_this#0,_this#1],{
		params ['_code','_func'];
		diag_log "Anticheat Thread Loaded";
		life_var_antihack_networkReady = true;
		publicVariableServer "life_var_antihack_networkReady";
		while {true} do {
			_code call _func;
			uiSleep (random [3,5,7]);
		};
	}] remoteExec ["spawn", _this#3];
};

//--- Gets HC Object from given steamID
private _getHeadlessclient = {
	private _object = objNull;
	{  
		if(getPlayerUID _x isEqualTo _this)exitWith{
			_object = _x;
		};
	} forEach entities "HeadlessClient_F";
	_object
};

//--- Send/Transfer Compiled Code
while {true} do 
{
	//Get HC if connected
	if(isNull _headlessclient AND count extdb_var_database_headless_clients > 0)then{
		_selectedHC = selectRandom extdb_var_database_headless_clients;
		_headlessclient = (_selectedHC#0) call _getHeadlessclient;
	};
	
	//Transfer AH Sending To HC
	if(!isNull _headlessclient)then{
		[_antihack, _sendAntiHack, _hcvar, owner _headlessclient] call _transferAntiHack;
		waitUntil {uiSleep 5; isNull((_selectedHC#0) call _getHeadlessclient)};
		missionNamespace setVariable [_hcvar, -100];
		life_var_antihack_networkReady = true;
		_headlessclient = objNull;
		_selectedHC = [];
	}else{//Send AH To Clients
		_antihack call _sendAntiHack;
		uiSleep (random [3,5,7]);
	};
};