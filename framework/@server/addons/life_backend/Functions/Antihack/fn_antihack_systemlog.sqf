/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_logmessage",""],
	["_logparams",[]]
];
 
if(!isServer)exitwith{false};
if(count _logmessage < 2)exitwith{false};

private _config = configFile >> "CfgAntiHack";

_logmessage = format["[ANTIHACK SYSTEM]: %1",_logmessage];

//--- Console
if((getNumber(_config >> "conlogs") isEqualTo 1) AND life_var_rcon_passwordOK)then{
	format ["#debug %1", _logmessage] call life_fnc_rcon_sendCommand;
}else{
	//--- RPT
	if(getNumber(_config >> "rptlogs") isEqualTo 1)then{
		diag_log _logmessage;
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

		if(_type == "" || _steamID == "" || _msg == "")exitWith{};
		if !([toUpper _type,1] in getArray(_config >> "dblogtypes"))exitWith{};
		
		private _BEGuid = ('BEGuid' callExtension ("get:"+_SteamID));

		["CREATE", "antihack_logs",
			[
				["Type", 	["DB","STRING", toUpper _type] call life_fnc_database_parse],
				["BEGuid", 	["DB","STRING", _BEGuid] call life_fnc_database_parse],
				["steamID", ["DB","STRING", _steamID] call life_fnc_database_parse],
				["log", 	["DB","STRING", _logmessage] call life_fnc_database_parse]
			]
		] call life_fnc_database_request;
	};
};

true