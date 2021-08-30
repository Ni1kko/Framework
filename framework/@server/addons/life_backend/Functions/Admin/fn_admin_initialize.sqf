/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false}; 
if(missionNamespace getVariable ["life_var_admin_loaded",false])exitwith{false};
if(isRemoteExecuted AND life_var_rcon_passwordOK)exitwith{[remoteExecutedOwner,"RemoteExecuted `fn_admin_initialize.sqf`"] call life_fnc_rcon_ban;};
params ['_admins','_rconReady'];

waitUntil {!isNil "life_var_rcon_passwordOK"};
["Starting Serveside Code!"] call life_fnc_admin_systemlog;
 
 
waitUntil {isFinal "extdb_var_database_key"};

try {
	private _config = (configFile >> "CfgAdmin"); 
	 
	//--- Get Config
	if(!isClass _config) throw "Config not found";
	 
}catch {
	[format["Exception: %1",_exception]] call life_fnc_admin_systemlog;
	 
};
 
true