/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework

	[] call life_fnc_buyLotteryTicket
*/

(call life_var_lotto_config) params [
	["_ticketPrice",-1],
	["_ticketLength",-1],
	["_ticketDrawCount",-1],
	["_ticketsReclaim",false],
	["_ticketBonusballPrice",-1]
];

if (_ticketPrice == -1) exitWith {hint "Error: No ticket price set in config!"; false};
if (_ticketLength == -1) exitWith {hint "Error: No ticket length set in config!"; false};
if (_ticketDrawCount == -1) exitWith {hint "Error: No ticket draw count set in config!"; false};
if (life_var_cash < _ticketPrice) exitWith {hint "You don't have enough money to buy a ticket!"; false};

private _return = true;
private _bonusBall = true;
private _ticketNumbers = [] call life_fnc_lottery_generateTicket;

if(count _ticketNumbers isNotEqualTo _ticketLength)exitWith{hint "Error: Not enough numbers to submit lottery Ticket!"; false}; 

if(_bonusBall) then { 
	if (_ticketBonusballPrice == -1) exitWith {hint "Error: No bonusball ticket price set in config!"; _return = false};
	if (life_var_cash < (_ticketPrice + _ticketBonusballPrice)) exitWith {hint "You don't have enough money to buy a ticket!"; _return =  false};
	
	//-- 0 = no bonus ball | 1-99 = bonus ball
	private _bonusBallNumber = [] call life_fnc_lottery_generateBonusBall; 

	[player, _ticketNumbers, _bonusBallNumber] remoteExec ["life_fnc_lottery_buyTicket",2];
}else{
	[player, _ticketNumbers, 0] remoteExec ["life_fnc_lottery_buyTicket",2];
};

_return
