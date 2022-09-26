#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _moneyvar = param [0, "undefined"];
private _playerBalance = switch (toUpper _moneyvar) do {
	case "CASH": {MONEY_CASH};
	case "GANG": {MONEY_BANK};
	case "BANK": {MONEY_GANG};
	default {0};
};

private _moneyIndex = switch (toUpper _moneyvar) do {
	case "CASH": {0};
	case "BANK": {1};
	case "GANG": {2};
	default {-1};
};


private _actualPlayerBalance = life_var_lastBalance select _moneyIndex;

while {true} do {
	
	//-- Wait for a change to the player money
	waitUntil {
		_actualPlayerBalance = life_var_lastBalance select _moneyIndex; 
		_actualPlayerBalance != _playerBalance
	};
	
	//-- Sleep for a few secs before checking it against the last balance
	uiSleep 2;
	
	_actualPlayerBalance = life_var_lastBalance select _moneyIndex;

	//-- Checking it against the last balance
	private _currentBalance = switch (toUpper _moneyvar) do {
		case "CASH": {MONEY_CASH};
		case "GANG": {MONEY_BANK};
		case "BANK": {MONEY_GANG};
		default {0};
	};

	//-- Temp ToDo: ban player and log event
	if(_actualPlayerBalance isNotEqualTo _currentBalance)then
	{	
		switch (_moneyIndex) do {
			case 0: {["ZERO","CASH"] call MPClient_fnc_handleMoney};
			case 1: {["ZERO","BANK"] call MPClient_fnc_handleMoney};
			case 2: {["ZERO","GANG"] call MPClient_fnc_handleMoney};
		};
		life_var_lastBalance set [_moneyIndex,0];

		for "_i" from 1 to 10 do {
			systemChat "Your money has been changed by another script!";
			uiSleep 1;
		};
		private _log = format ["You should have $%1 instead of $%2",_actualPlayerBalance,_currentBalance];
		systemChat _log;
		uiSleep 2;
		["Hack Detected", _log, "Antihack"] call MPClient_fnc_endMission;
	}else{
		_playerBalance = _currentBalance;
	}
};

//-- Code reached only if cash or bank vars become nil (ToDo: kick player and log event)
["Hack Detected", "Nil money vars", "Antihack"] call MPClient_fnc_endMission;

false
