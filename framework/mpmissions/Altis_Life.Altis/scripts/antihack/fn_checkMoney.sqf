/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _moneyvar = format ["life_var_%1",param [0, "undefined"]];
private _lastVal = missionNamespace getVariable [_moneyvar,0];
private _moneyIndex = _moneyvar isEqualTo "life_var_bank";
private _lastActualBalance = _lastVal;

while {!isNil "life_var_cash" OR !isNil "life_var_bank"} do {
	
	//-- Wait for a change to the player money
	waitUntil {
		_lastActualBalance = life_var_lastBalance select _moneyIndex; 
		_lastActualBalance != _lastVal
	};
	
	//-- Sleep for a few secs before checking it against the last balance
	uiSleep 2;

	//-- Checking it against the last balance
	private _currentBalance = missionNamespace getVariable [_moneyvar,0];
	_lastActualBalance = life_var_lastBalance select _moneyIndex; 
	
	//-- Temp ToDo: ban player and log event
	if(_lastActualBalance isNotEqualTo _currentBalance)then{
		for "_i" from 1 to 10 do {
			systemChat "Your money has been changed by another script!";
			uiSleep 1;
		};
		private _log = format ["You should have $%1 instead of $%2",_lastActualBalance,_currentBalance];
		systemChat _log;
		uiSleep 2;
		["Hack Detected", _log, "Antihack"] call MPClient_fnc_endMission;
	};
};

//-- Code reached only if cash or bank vars become nil (ToDo: kick player and log event)
["Hack Detected", "Nil money vars", "Antihack"] call MPClient_fnc_endMission;

false
