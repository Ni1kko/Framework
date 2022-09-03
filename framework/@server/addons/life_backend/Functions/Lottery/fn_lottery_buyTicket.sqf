/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework

	[player] remoteExec ["life_fnc_lottery_buyTicket",2];
*/

params [
	["_player",objNull,[objNull]]
];

if(Life_var_lottoDrawLock)exitWith {
	"Lottery is currently closed to be drawed!" remoteExec ["Hint",remoteExecutedOwner];
};

(call life_var_lotto_config) params [
	"_ticketPrice"
];

private _steamID = (getPlayerUID _player);
private _BEGuid = ('BEGuid' callExtension ("get:"+_steamID));
private _Numbers = selectRandom [floor(random(1000)),round(random(1000)),floor(random(1000)),round(random(1000)),floor(random(1000)),round(random(1000))];

["CREATE", "lotteryTickets", 
	[
		["BEGuid", 			["DB","STRING", _BEGuid] call life_fnc_database_parse],
		["numbers", 		["DB","INT", _Numbers] call life_fnc_database_parse]
	]
] call life_fnc_database_request;


[_ticketPrice,{
	systemChat "You have bought a lottery ticket!";
	life_var_cash = life_var_cash - _this;
}] remoteExec ["Hint",remoteExecutedOwner];

true