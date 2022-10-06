#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!isServer)exitwith{false};
//[owner cursorObject] call MPServer_fnc_rcon_kick;

params [
	["_id","",["",0]],
	["_msg",""]
];

if(typeName _id isEqualTo "STRING")then{
	private _player = [_id] call MPServer_fnc_util_getPlayerObject;
	private _uid = getPlayerUID _player; 
	_id = owner _player;

	//opps error
	if(isNull _player || _uid isEqualTo "" || _ownerID < 3 || _msg isEqualTo "")exitwith{};

	//get targets beguid
	private _BEGuid = GET_BEGUID(_player);

	//log reason, time and beguid
	if(getNumber(configFile >> "CfgRCON" >> "dblogs") isEqualTo 1)then{
		["CREATE", "rcon_logs", 
			[
				["Type", 			["DB","STRING", "KICK"] call MPServer_fnc_database_parse],
				["BEGuid", 			["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
				["pid", 			["DB","STRING", _uid] call MPServer_fnc_database_parse],
				["reason", 			["DB","STRING", _msg] call MPServer_fnc_database_parse]
			]
		] call MPServer_fnc_database_request;
	}else{
		format["'%1' Kicked Due To: %2",_BEGuid,_msg] call MPServer_fnc_rcon_systemlog;
	};
};

format ["#kick %1", _id] call MPServer_fnc_rcon_sendCommand;

true