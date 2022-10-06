#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_player",objNull,[objNull]],
	["_ticketNumbers",""],
	["_bonusball","NOT PURCHASED"]
];

if(Life_var_lottoDrawLock)exitWith {
	"Lottery is currently closed to be drawed!" remoteExec ["Hint",remoteExecutedOwner];
};

(call life_var_lotto_config) params [
	"_ticketPrice",
	"_ticketLength",
	"_ticketDrawCount",
	"_ticketsReclaim",
	"_ticketBonusballPrice"
];

private _BEGuid = GET_BEGUID(_player);

//--- Error check / failsafe
if(typeName _ticketNumbers isNotEqualTo "STRING") then {_ticketNumbers = ""};
if(typeName _bonusball isNotEqualTo "STRING") then {_bonusball = ""}; 

//-- Generate ticket
if((count _ticketNumbers) isNotEqualTo _ticketLength) then {_ticketNumbers = [] call MPServer_fnc_lottery_generateTicket};

//-- Generate bonusball
if(_bonusball in [""," ","NOT PURCHASED"])then{
	_bonusball = str 0;
}else{
	if !((count _bonusball) in [1,2]) then {_bonusball = [] call MPServer_fnc_lottery_generateBonusBall};
};

//--- Add ticket to database
["CREATE", "lotteryTickets", 
	[
		["BEGuid", 			["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
		["serverID",		["DB","INT",call life_var_serverID] call MPServer_fnc_database_parse],
		["numbers", 		["DB","STRING", _ticketNumbers] call MPServer_fnc_database_parse],
		["bonusball", 		["DB","STRING", _bonusball] call MPServer_fnc_database_parse]
	]
] call MPServer_fnc_database_request;

//--- Complete sale
[
	[
		_ticketPrice,
		[0, _ticketBonusballPrice] select (parseNumber _bonusball > 0)
	],
	{
		params [ 
			"_ticketPrice",
			"_ticketBonusballPrice"
		];

		private _total = (_ticketPrice + _ticketBonusballPrice);

		systemChat format["You have bought a lottery ticket for $%1!",[_total] call MPClient_fnc_numberText];
        ["SUB","CASH",_total] call MPClient_fnc_handleMoney;
	}
] remoteExec ["Hint",remoteExecutedOwner];

true
