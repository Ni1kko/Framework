#include "\life_server\script_macros.hpp"
/*
    File: fn_asyncCall.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Commits an asynchronous call to ExtDB

    Parameters:
        0: STRING (Query to be ran).
        1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
        3: BOOL (True to return a single array, false to return multiple entries mainly for garage).
*/

private _query = param [0,""];
private _mode = param [1,1];
private _multiarr = param [1,false];

if(count _query isEqualTo 0)exitWith{false};

private _protocol = call life_sql_id;
private _uniqueID = (parseSimpleArray(_protocol databaseAsyncQuery _query)) param [1,""];

if (_mode isEqualTo 1) exitWith {true};

private _queryResult = getDatabaseSinglePartMessage _uniqueID;

//Make sure the data is received
if (_queryResult isEqualTo "[3]") then {
    for "_i" from 0 to 1 step 0 do {
        if (_queryResult isNotEqualTo "[3]") exitWith {};
        _queryResult = getDatabaseSinglePartMessage _uniqueID;
    };
};

if (_queryResult isEqualTo "[5]") then {
    private _loop = true;
    for "_i" from 0 to 1 step 0 do { // extDB4 returned that result is Multi-Part Message
        _queryResult = "";
        for "_i" from 0 to 1 step 0 do {
            private _pipe = getDatabaseMultiPartMessage _uniqueID;
            if (_pipe isEqualTo "") exitWith {_loop = false};
            _queryResult = _queryResult + _pipe;
        };
        if (!_loop) exitWith {};
    };
};

_queryResult = call compile _queryResult;
if ((_queryResult select 0) isEqualTo 0) exitWith {
    [format ["Protocol Error: %1", _queryResult]] call MPServer_fnc_database_systemlog;
    []
};

_queryResult = (_queryResult select 1);


if (!_multiarr && count _queryResult > 0) then {
    _queryResult = (_queryResult select 0);
};

_queryResult;
