#include "\life_backend\serverDefines.hpp"
/*
    File: fn_wantedAdd.sqf
    Author: Bryan "Tonic" Boardwine"
    Database Persistence By: ColinM
    Assistance by: Paronity
    Stress Tests by: Midgetgrimm

    Description:
    Adds or appends a unit to the wanted list.
*/
params [
    ["_uid","",[""]],
    ["_name","",[""]],
    ["_type","",[""]],
    ["_customBounty",-1,[0]]
];

if (_uid isEqualTo "" || {_type isEqualTo ""} || {_name isEqualTo ""}) exitWith {}; //Bad data passed.

//What is the crime?
private _crimesConfig = getArray(missionConfigFile >> "cfgMaster" >> "crimes");
private _index = [_type,_crimesConfig] call MPServer_fnc_index;

if (_index isEqualTo -1) exitWith {};

_type = [_type, parseNumber ((_crimesConfig select _index) select 1)];

if (count _type isEqualTo 0) exitWith {}; //Not our information being passed...
//Is there a custom bounty being sent? Set that as the pricing.
if !(_customBounty isEqualTo -1) then {_type set[1,_customBounty];};
//Search the wanted list to make sure they are not on it.

private _query = format ["SELECT wantedID FROM wanted WHERE wantedID='%1'",_uid];
private _queryResult = [_query,2,true] call MPServer_fnc_database_rawasync_request;
private _val = ["DB","A2NET", _type#1] call MPServer_fnc_database_parse;
private _number = _type select 0;

if !(count _queryResult isEqualTo 0) then {
    _query = format ["SELECT wantedCrimes, wantedBounty FROM wanted WHERE wantedID='%1'",_uid];
    _queryResult = [_query,2] call MPServer_fnc_database_rawasync_request;
    _pastCrimes = ["GAME","ARRAY", _queryResult#0] call MPServer_fnc_database_parse;

    if (_pastCrimes isEqualType "") then {_pastCrimes = call compile format ["%1", _pastCrimes];};
    _pastCrimes pushBack _number;
    _pastCrimes = ["DB","ARRAY", _pastCrimes] call MPServer_fnc_database_parse;
    _query = format ["UPDATE wanted SET wantedCrimes = '%1', wantedBounty = wantedBounty + '%2', active = '1' WHERE wantedID='%3'",_pastCrimes,_val,_uid];
    [_query,1] call MPServer_fnc_database_rawasync_request;
} else {
    _crime = [_type select 0];
    _crime = ["DB","ARRAY", _crime] call MPServer_fnc_database_parse;
    _query = format ["INSERT INTO wanted (wantedID, wantedName, wantedCrimes, wantedBounty, active) VALUES('%1', '%2', '%3', '%4', '1')",_uid,_name,_crime,_val];
    [_query,1] call MPServer_fnc_database_rawasync_request;
};
