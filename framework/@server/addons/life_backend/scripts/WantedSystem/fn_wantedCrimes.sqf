#include "\life_backend\script_macros.hpp"
/*
    File: fn_wantedCrimes.sqf
    Author: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    Description:
    Grabs a list of crimes committed by a person.
*/
disableSerialization;

params [
    ["_ret",objNull,[objNull]],
    ["_criminal",[],[]]
];

private _query = format ["SELECT wantedCrimes, wantedBounty FROM wanted WHERE active='1' AND wantedID='%1'",_criminal select 0];
private _queryResult = [_query,2] call MPServer_fnc_database_rawasync_request;

_ret = owner _ret;

private _type = ["GAME","ARRAY", _queryResult#0] call MPServer_fnc_database_parse;
if (_type isEqualType "") then {_type = call compile format ["%1", _type];};

private _crimesArr = [];
{
    private _str = format ["STR_Crime_%1", _x];
    _crimesArr pushBack _str;
    false
} count _type;

_queryResult set[0,_crimesArr];

[_queryResult] remoteExec ["MPClient_fnc_wantedInfo",_ret];
