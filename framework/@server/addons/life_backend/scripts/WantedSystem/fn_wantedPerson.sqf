#include "\life_backend\serverDefines.hpp"
/*
    File: fn_wantedPerson.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    Description:
    Fetches a specific person from the wanted array.
*/
private _unit = param [0,objNull,[objNull]];

if (isNull _unit) exitWith {[]};

private _uid = getPlayerUID _unit;
private _query = format ["SELECT wantedID, wantedName, wantedBounty FROM wanted WHERE active='1' AND wantedID='%1'",_uid];
private _queryResult = [_query,2] call MPServer_fnc_database_rawasync_request;

if (count _queryResult isEqualTo 0) exitWith {[]};
_queryResult;
