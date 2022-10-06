#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if(!isServer)exitwith{false};
//["76561199109931625","Trolling, So Dan Got A Ban"] call MPServer_fnc_rcon_ban;

params [
	["_uid","",["",0]],
	["_msg","No Reason Given"],
	["_mins",0]
];

private _player = [_uid] call MPServer_fnc_util_getPlayerObject;
private _ownerID = owner _player;
private _uid = getPlayerUID _player;
 
//opps error
if(isNull _player || _uid isEqualTo "" || _ownerID < 3)exitwith{false};

//get targets beguid
private _BEGuid = GET_BEGUID(_player);

//ban target
if(format["#beserver addban %1 %2 %3",_BEGuid, _mins, _msg] call MPServer_fnc_rcon_sendCommand)then{
	"#beserver writeBans" call MPServer_fnc_rcon_sendCommand;
}else{
	('#exec ban ' + str _ownerID) call MPServer_fnc_rcon_sendCommand;
};

//kick target
[_ownerID] call MPServer_fnc_rcon_kick;

//log reason, time and beguid
if(getNumber(configFile >> "CfgRCON" >> "dblogs") isEqualTo 1)then{
	["CREATE", "rcon_logs", 
        [
			["Type", 			["DB","STRING", "BAN"] call MPServer_fnc_database_parse],
            ["BEGuid", 			["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
            ["pid", 			["DB","STRING", _uid] call MPServer_fnc_database_parse],
			["reason", 			["DB","STRING", _msg] call MPServer_fnc_database_parse]
        ]
    ] call MPServer_fnc_database_request; 
}else{
	format["'%1' Banned Due To: %2",_BEGuid,_msg] call MPServer_fnc_rcon_systemlog;
};

true