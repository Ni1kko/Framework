#include "\life_backend\script_macros.hpp"
/*
    File : fn_updateHouseTrunk.sqf
    Author: NiiRoZz

    Description:
    Update inventory "y" in container
*/
private ["_house"];
_container = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _container) exitWith {};

_trunkData = _container getVariable ["Trunk",[[],0]];
_containerID = _container getVariable ["container_id",-1];

if (_containerID isEqualTo -1) exitWith {}; //Dafuq?

_trunkData = ["DB","ARRAY", _trunkData] call MPServer_fnc_database_parse;
_query = format ["UPDATE containers SET inventory='%1' WHERE id='%2'",_trunkData,_containerID];

[_query,1] call MPServer_fnc_database_rawasync_request;
