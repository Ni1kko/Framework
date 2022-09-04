/*
	## Maihym & Ni1kko
	## https://github.com/Ni1kko/Framework
*/

 
private _runtime = 0;

while{true} do
{  
	_runtime = _runtime + 1;

	switch (true) do 
	{
		//--- Every 2 seconds
		case ((_runtime mod 2) isEqualTo 0): {};
		//--- Every 5 seconds
		case ((_runtime mod 5) isEqualTo 0): {};
		//--- Every 10 seconds
		case ((_runtime mod 10) isEqualTo 0): {[] call TON_fnc_updateHuntingZone};
		//--- Every 30 seconds
		case ((_runtime mod 30) isEqualTo 0): { };
		//--- Every 1 minute
		case ((_runtime mod 60) isEqualTo 0): { };
		//--- Every 2 minutes
		case ((_runtime mod 120) isEqualTo 0): { };
		//--- Every 3 minutes
		case ((_runtime mod 180) isEqualTo 0): {["items"] call TON_fnc_cleanup};
		//--- Every 5 minutes
		case ((_runtime mod 300) isEqualTo 0): {["weapons"] call TON_fnc_cleanup};
		//--- Every 10 minutes
		case ((_runtime mod 600) isEqualTo 0): {[] call TON_fnc_federalUpdate};
		//--- Every 15 minutes
		case ((_runtime mod 900) isEqualTo 0): { };
		//--- Every 20 minutes
		case ((_runtime mod 1200) isEqualTo 0): { };
		//--- Every 25 minutes
		case ((_runtime mod 1500) isEqualTo 0): { };
		//--- Every 30 minutes
		case ((_runtime mod 1800) isEqualTo 0): {[] call TON_fnc_updateDealers};
		//--- Every 45 minutes
		case ((_runtime mod 2700) isEqualTo 0): {};
		//--- Every 60 minutes
		case ((_runtime mod 3600) isEqualTo 0): {["vehicles"] call TON_fnc_cleanup};
		//--- Every 2 hours
		case ((_runtime mod 7200) isEqualTo 0): {};
	};

	uiSleep 1;
};