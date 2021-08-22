/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_uid","",[""]],
	["_msg","No Reason Given"],
	["_mins",0]
];

private _BEGuid = ('BEGuid' callExtension ("get:"+_uid));
private _ownerID = -100;
{
	if(getplayeruid _x == _uid) exitWith {
		_ownerID = owner _x;
	};
} forEach (allPlayers - entities 'HeadlessClient_F'); 

if(format["#beserver addban %1 %2 %3",_bEGuid, _mins, _msg] call life_fnc_rcon_sendCommand)then{
	"#beserver writeBans" call life_fnc_rcon_sendCommand;
}else{
	if(_ownerID > 2)then{
		('#exec ban ' + str _ownerID) call life_fnc_rcon_sendCommand;
	};
};

//[_ownerID,_msg] call life_fnc_rcon_kick;
('#exec kick ' + str _ownerID) call life_fnc_rcon_sendCommand;

format["'%1' Banned Due To: %2",_bEGuid,_msg] call life_fnc_rcon_systemlog;

if(getNumber(configFile >> "CfgRCON" >> "dblogs") isEqualTo 1)then{
		
};
 

true