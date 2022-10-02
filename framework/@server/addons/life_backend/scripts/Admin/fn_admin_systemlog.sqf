#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_logmessage",""],
	["_logparams",[]]
];
 
if(!isServer)exitwith{false};
if(count _logmessage < 2)exitwith{false};

private _config = configFile >> "CfgAdmin";
private _logmessage2 = format["[ADMIN SYSTEM]: %1",_logmessage];
 
//--- Console
if((getNumber(_config >> "conlogs") isEqualTo 1) AND life_var_rcon_passwordOK)then{
	format ["#debug %1", _logmessage2] call MPServer_fnc_rcon_sendCommand;
}else{
	//--- RPT
	if(getNumber(_config >> "rptlogs") isEqualTo 1)then{
		[_logmessage2] call MPServer_fnc_log;
	};
};

//--- Extension
if(getNumber(_config >> "extlogs") isEqualTo 1)then{
    //"" callExtension format["",_logmessage]
};

//--- Database
if(getNumber(_config >> "dblogs") isEqualTo 1)then{
	if(count _logparams isEqualTo 2)then{
		_logparams params [
			["_type","",[""]], 
			["_steamID","",[""]]
		];

		if(_type == "" || _steamID == "" || _logmessage == "")exitWith{};

		if(getNumber(_config >> "ingamelogs") isEqualTo 1)then{
			life_var_admin_logs pushback [_type,_logmessage,_steamID];
			publicVariable "life_var_admin_logs";
		};
		
		if !([toUpper _type,1] in getArray(_config >> "dblogtypes"))exitWith{};
		
		private _BEGuid = GET_BEGUID_S64(_x);
		["CREATE", "admin_logs",
			[
				["Type", 	["DB","STRING", toUpper _type] call MPServer_fnc_database_parse],
				["BEGuid", 	["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
				["steamID", ["DB","STRING", _steamID] call MPServer_fnc_database_parse],
				["log", 	"'"""+_logmessage+"""'"]
			]
		] call MPServer_fnc_database_request;
	};
};

true