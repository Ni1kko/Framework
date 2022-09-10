/*
    File: fn_database_rawasync_request.sqf
    Author: Torndeco, Tonic & Ni1kko
    Description: Commits an asynchronous call to ExtDB
    Parameters:
        0: STRING (Query to be ran).
        1: INTEGER (1 = ASYNC + not return for update/insert, 2 = ASYNC + return for query's).
        3: BOOL (True to return a single array, false to return multiple entries mainly for garage).
*/

if (call extdb_var_database_prepared)exitWith{ 
    ["Protocol Error, cant use `MPServer_fnc_database_rawasync_request` with SQL Custom"] call MPServer_fnc_database_systemlog;
};

if(life_var_rcon_RestartMode > 0)exitWith{false};

private _queryStmt = [_this,0,"",[""]] call BIS_fnc_param;
private _mode = [_this,1,1,[0]] call BIS_fnc_param;
private _multiarr = [_this,2,false,[false]] call BIS_fnc_param;
private _key = "extDB3" callExtension format ["%1:%2:%3",_mode,call extdb_var_database_key,_queryStmt];

if (_mode isEqualTo 1) exitWith {true};
_key = call compile format ["%1",_key];
_key = (_key select 1);

private _queryResult = "extDB3" callExtension format ["4:%1", _key];

//Make sure the data is received
if (_queryResult isEqualTo "[3]") then {
    for "_i" from 0 to 1 step 0 do {
        if (!(_queryResult isEqualTo "[3]")) exitWith {};
        _queryResult = "extDB3" callExtension format ["4:%1", _key];
    };
};

if (_queryResult isEqualTo "[5]") then {
    private _loop = true;
    for "_i" from 0 to 1 step 0 do { // extDB3 returned that result is Multi-Part Message
        _queryResult = "";
        for "_i" from 0 to 1 step 0 do {
            _pipe = "extDB3" callExtension format ["5:%1", _key];
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
private _return = (_queryResult select 1);
if (!_multiarr && count _return > 0) then {
    _return = (_return select 0);
};

_return;