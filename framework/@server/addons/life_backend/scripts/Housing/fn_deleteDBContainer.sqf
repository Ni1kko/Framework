#include "\life_backend\serverDefines.hpp"
/*
    File : fn_deleteDBContainer.sqf
    Author: NiiRoZz

    Description:
    Delete Container and remove Container in Database
*/
private ["_house","_houseID","_ownerID","_housePos","_query","_radius","_containers"];
_container = [_this,0,objNull,[objNull]] call BIS_fnc_param;
if (isNull _container) exitWith  {
    ["container null unable to delete!"] call MPServer_fnc_log;
};

_containerID = _container getVariable ["container_id",-1];
if (_containerID isEqualTo -1) then {
    _containerPos = getPosATL _container;
    _ownerID = (_container getVariable "container_owner") select 0;
    _query = format ["UPDATE containers SET owned='0', pos='[]' WHERE pid='%1' AND pos='%2' AND owned='1'",_ownerID,_containerPos];
    //systemChat format [":SERVER:sellHouse: container_id does not exist"];
} else {
    //systemChat format [":SERVER:sellHouse: house_id is %1",_houseID];
    _query = format ["UPDATE containers SET owned='0', pos='[]' WHERE id='%1'",_containerID];
};
_container setVariable ["container_id",nil,true];
_container setVariable ["container_owner",nil,true];

[_query,1] call MPServer_fnc_database_rawasync_request;

["CALL deleteOldContainers",1] call MPServer_fnc_database_rawasync_request;
deleteVehicle _container;
