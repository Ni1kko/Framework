#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!isServer)exitwith{false};
if(isFinal "extdb_var_database_key")exitwith{false};

private _config = (configFile >> "CfgExtDB");

extdb_var_database_error = false;
extdb_var_database_key = nil;
extdb_var_database_prepared = nil;
extdb_var_database_prepared_async = false;
extdb_var_database_prepared_asynclock = false; 
extdb_var_database_headless_client = 2;
extdb_var_database_headless_clients = [];
extdb_var_database_headless_clientconnected = -1;
extdb_var_database_headless_clientdisconnected = -1;

try {
	
	//--- Config
	if(!isClass _config) throw "Config not found";
	private _profile = getText(_config >> "profile");
	private _sqlcustom = getNumber(_config >> "sqlcustom") isEqualTo 1;
	private _sqlcustomfile = getText(_config >> "sqlcustomfile");
	private _procedures =  getArray(_config >> "startup_procedures");
	private _headless =  getNumber(_config >> "headlessclient") isEqualTo 1;
	private _resetplayer = getNumber(missionConfigFile >> "cfgMaster" >> "save_civilian_position_restart") isEqualTo 1;
	private _databasekey = round(random 99999);

	//--- Version
	private _versionRes = parseNumber("extDB3" callExtension "9:VERSION");
	if(_versionRes < 1.031) throw "Error with extDB3";
 	format ["ExtDB V%1 Loaded",_versionRes] call MPServer_fnc_database_systemlog;

	//--- Profile
	private _profileRes = "extDB3" callExtension format ["9:ADD_DATABASE:%1",_profile];
	if(_profileRes isNotEqualTo "[1]") throw "Error with Database Profile";
	format ["Profile (%1) Loaded",_profile] call MPServer_fnc_database_systemlog;

	//--- Protocol
	private _protocolRes = (if(_sqlcustom)then{
		"extDB3" callExtension format["9:ADD_DATABASE_PROTOCOL:%1:SQL_CUSTOM_V2:%2:%3",_profile,_databasekey,_sqlcustomfile];
	}else{
		"extDB3" callExtension format ["9:ADD_DATABASE_PROTOCOL:%1:SQL:%2:TEXT2",_profile,_databasekey];
	});
	if(_protocolRes isNotEqualTo "[1]") throw "Error with Database Protocol";
	format ["SQL%1 Protocol Loaded",["Raw","Custom"]select _sqlcustom] call MPServer_fnc_database_systemlog;

	//--- Lock profile
	private _lockRes = "extDB3" callExtension "9:LOCK";
	private _lockedRes = "extDB3" callExtension "9:LOCK_STATUS";
	if(_protocolRes isNotEqualTo "[1]" OR _protocolRes isNotEqualTo "[1]") throw "Error Locking Database Profile";
	format ["Profile (%1) Locked",_profile] call MPServer_fnc_database_systemlog;
	 
	//--- Connection OKAY
	extdb_var_database_prepared = compileFinal str(_sqlcustom);
	extdb_var_database_key = compileFinal str(_databasekey); 
	format["Database Connected Using Profile: (%1)", _profile] call MPServer_fnc_database_systemlog;

	//--- Setup server to support headless clients
	if (_headless) then {
		[] call MPServer_fnc_database_initializeHC;
	};

	//--- Reset players life after restart
	if (_resetplayer) then {
		_procedures pushBackUnique "resetPlayersLife";
	};

	//--- Run stored procedures for SQL side cleanup
	{
		["CALL", _x]call MPServer_fnc_database_request;
		format["Executing procedure (%1)", _x] call MPServer_fnc_database_systemlog;
	} forEach _procedures;
} catch { 
	_exception call MPServer_fnc_database_systemlog;
	extdb_var_database_error = true;
};

//--- Broadcast database variables to clients
publicVariable "extdb_var_database_error";
publicVariable "extdb_var_database_headless_clients";

true