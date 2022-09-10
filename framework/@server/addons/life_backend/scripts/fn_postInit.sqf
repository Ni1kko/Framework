/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

if (hasInterface)exitWith{false};
if (isFinal "life_var_postInitTime")exitWith{false};

life_var_postInitTime = compileFinal str(diag_tickTime);

["Loading server postInit"] call MPServer_fnc_log;

//--- Variable Event handlers
"money_log" addPublicVariableEventHandler {[_this#1] call MPServer_fnc_log};
"advanced_log" addPublicVariableEventHandler {[_this#1] call MPServer_fnc_log};

[format["Server postInit completed! Took %1 seconds",diag_tickTime - (call life_var_postInitTime)]] call MPServer_fnc_log;

true