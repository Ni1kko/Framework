#include "\life_backend\serverDefines.hpp"
/*
	File: fn_database_prepared_request.sqf
	Author: Torndeco, Tonic & Ni1kko
	Description: Commits an asynchronous call to extDB Gets result via extDB 4:x + uses 5:x if message is Multi-Part
	Parameters:
		0: STRING (Query to be ran).
		1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
		3: BOOL (False to return a single array, True to return multiple entries mainly for garage).
*/

if !(call extdb_var_database_prepared)exitWith{ 
    ["Protocol Error, cant use `MPServer_fnc_database_prepared_request` with SQL Raw"] call MPServer_fnc_database_systemlog;
};

if(life_var_rcon_RestartMode > 0)exitWith{false};

waitUntil {uiSleep (random .25); !extdb_var_database_preparedAsync};

extdb_var_database_preparedAsync = true;

private _queryStmt = [_this,0,"",[""]] call BIS_fnc_param;
private _mode = [_this,1,1,[0]] call BIS_fnc_param;
private _multiarr = [_this,2,false,[false]] call BIS_fnc_param;
private _tickTime = diag_tickTime;
private _key = "extDB3" callExtension format["%1:%2:%3",_mode, call extdb_var_database_key, _queryStmt];

if(_mode isEqualTo 1) exitWith {extdb_var_database_preparedAsync = false; true};

_key = call compile format["%1",_key];
_key = _key select 1;

waitUntil{uisleep (random .25); !extdb_var_database_prepared_asynclock};
extdb_var_database_prepared_asynclock = true;

// Get Result via 4:x (single message return)  v19 and later
_fetchTime = diag_tickTime;

private _queryResult = "";
private _loop = true;
while{_loop} do
{
	_queryResult = "extDB3" callExtension format["4:%1", _key];
	if (_queryResult isEqualTo "[5]") then {
		// extDB3 returned that result is Multi-Part Message
		_queryResult = "";
		while{true} do {
			_pipe = "extDB3" callExtension format["5:%1", _key];
			if(_pipe isEqualTo "") exitWith {_loop = false};
			_queryResult = _queryResult + _pipe;
		};
	}
	else
	{
		if (_queryResult isEqualTo "[3]") then
		{
    		[format ["uisleep [4]: %1", diag_tickTime]] call MPServer_fnc_database_systemlog;
			uisleep 0.25;
		} else {
			_loop = false;
		};
	};
};

[format ["QUERY: %1 ALLTIME: %3 GETTIME: %4 RESULT: %2", _queryStmt,_queryResult,diag_tickTime - _tickTime,diag_tickTime - _fetchTime]] call MPServer_fnc_database_systemlog;

extdb_var_database_prepared_asynclock = false;
extdb_var_database_preparedAsync = false;

_queryResult = call compile _queryResult;

// Not needed, its SQF Code incase extDB ever returns error message i.e Database Died
if ((_queryResult select 0) isEqualTo 0) exitWith {
	[format ["Protocol Error: %1", _queryResult]] call MPServer_fnc_database_systemlog;
	[]
};

//Multiarray request, but the array was empty... Instead of returning [[]] (Causes an error in scripts that loop)
//Return [], therefore the forEaches in all the scripts such as the garage will not run. Backwards Compatible.
/*if(
	_multiarr &&
	{typeName ((_queryResult select 1) select 0) == "ARRAY"} &&
	{count ((_queryResult select 1) select 0) == 0}
) exitWith {[]};*/

_return = (_queryResult select 1);

if(!_multiarr && count _return > 0) then {
	_return = _return select 0;
};

_return;