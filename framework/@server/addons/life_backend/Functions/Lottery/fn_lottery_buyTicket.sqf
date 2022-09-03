/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework

	
	[player, "3354",99] remoteExec ["life_fnc_lottery_buyTicket",2];
*/

params [
	["_player",objNull,[objNull]],
	["_ticketNumbers",""],
	["_bonusball",0]
];

if(Life_var_lottoDrawLock)exitWith {
	"Lottery is currently closed to be drawed!" remoteExec ["Hint",remoteExecutedOwner];
};

(call life_var_lotto_config) params [
	"_ticketPrice",
	"_ticketLength"
];

private _steamID = (getPlayerUID _player);
private _BEGuid = ('BEGuid' callExtension ("get:"+_steamID));

//---
if(typeName _ticketNumbers isNotEqualTo "STRING") then {_ticketNumbers = ""};
if(typeName _bonusball isNotEqualTo "SCALAR") then {_bonusball = 0};

//-- Generate ticket
if((count _ticketNumbers) isNotEqualTo _ticketLength) then {_ticketNumbers = [] call life_fnc_lottery_generateTicket};

//-- Generate bonusball
if(_bonusball < 0 OR _bonusball > 99) then {_bonusball = floor random 99};

//--- 
["CREATE", "lotteryTickets", 
	[
		["BEGuid", 			["DB","STRING", _BEGuid] call life_fnc_database_parse],
		["numbers", 		["DB","STRING", _ticketNumbers] call life_fnc_database_parse],
		["bonusball", 		["DB","STRING", _bonusball] call life_fnc_database_parse]
	]
] call life_fnc_database_request;

//--- 
[_ticketPrice,{
	systemChat "You have bought a lottery ticket!";
	life_var_cash = life_var_cash - _this;
}] remoteExec ["Hint",remoteExecutedOwner];

true