/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
//[owner cursorObject] call life_fnc_rcon_kick;

params [
	["_id",0,[0]],
	["_msg",""]
];

if(_msg isNotEqualTo "")then
{
	private _uid = "";

	//steamID from ownerID
	{
		if(owner _x == _id) exitWith { 
			_uid = getPlayerUID _x;
		};
	} forEach (allPlayers - entities 'HeadlessClient_F'); 
	
	//opps error
	if(_uid isEqualTo "" || _id < 3)exitwith{};

	//get targets beguid
	private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));

	//log reason, time and beguid
	if(getNumber(configFile >> "CfgRCON" >> "dblogs") isEqualTo 1)then{
		[format ["INSERT INTO rcon_logs (Type, BEGuid, pid, reason) VALUES('KICK', '%1', '%2', '%3')",_BEGuid,_uid,_msg],1] call DB_fnc_asyncCall;	
	}else{
		format["'%1' Kicked Due To: %2",_BEGuid,_msg] call life_fnc_rcon_systemlog;
	};
};

format ["#kick %1", _id] call life_fnc_rcon_sendCommand;

true