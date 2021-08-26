/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_logmessage","",[""]],
	["_logparams",[]]
];
 
if(!isServer)exitwith{false};
if(count _logmessage < 2)exitwith{false};

_logmessage = format["[ANTIHACK SYSTEM]: %1",_logmessage];

//--- Console
if(getNumber(configFile >> "CfgAntiHack" >> "conlogs") isEqualTo 1)then{
	format ["#debug %1", _logmessage] call life_fnc_rcon_sendCommand;
}else{
	//--- RPT
	if(getNumber(configFile >> "CfgAntiHack" >> "rptlogs") isEqualTo 1)then{
	
	};
};

//--- Extension
if(getNumber(configFile >> "CfgAntiHack" >> "extlogs") isEqualTo 1)then{
    //"" callExtension format["",_logmessage]
};

//--- Database
if(getNumber(configFile >> "CfgAntiHack" >> "dblogs") isEqualTo 1)then{
	if(count _logparams isEqualTo 2)then{
		_logparams params [
			["_type","",[""]], 
			["_steamID","",[""]]
		];
		
		if(_type == "" || _steamID == "" || _msg == "")exitWith{};
		if !(toUpper _type in ["KICK","BAN","HACK"])exitWith{};
		
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