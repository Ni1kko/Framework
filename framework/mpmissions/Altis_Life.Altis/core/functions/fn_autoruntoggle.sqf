/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/
params [
	["_mode",""]
];

private _state = "OFF";

switch (_mode) do {
	case "toggle":{ 
		private _lastuse = uiNamespace getVariable ["autorun_lastactivated",diag_tickTime];
		if(_lastuse > diag_tickTime)exitWith{
			if(life_var_autorun)then{
				_state = "ON";
				hint "AutoRun Activate...";
				uiNamespace setVariable ["autorun_lastactivated",diag_tickTime + 1];//reset give them another 1 secs
			};
			_state
		};
		uiNamespace setVariable ["autorun_lastactivated",diag_tickTime + 2];
		
		//-- Toggle
		if(life_var_autorun)then{
			life_var_autorun = false; 
		}else{
			if(call MPClient_fnc_util_canautorun)then{
				life_var_autorun = true;
				_state = "ON";
			}else{
				hint "AutoRun Unavailable...";
			};
		};
	};
	case "interrupt": 
	{ 
		if(!life_var_autorun)exitWith{_state}; 
		_state = "INTERRUPTED";
		life_var_autorun_interrupt = true;
	 
	}; 
	case "continue": 
	{
		if(!life_var_autorun_interrupt)exitWith{_state};
		_state = "ON";
		life_var_autorun_interrupt = false;
		life_var_autorun = true;
	};
	case "abort": 
	{ 
		if(!life_var_autorun)exitWith{_state};
		hint "AutoRun Aborted...";
		life_var_autorun = false;
	};
};

_state