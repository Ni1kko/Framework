#include "\life_backend\serverDefines.hpp"
/*
    File: fn_initHouses.sqf
    Description: Initalizes house setup when server starts
*/

private _allHouses = nearestobjects [[worldSize/2, worldSize/2],["house"],worldsize];
private _blacklistedHouses = ("count (getArray (_x >> 'garageBlacklists')) > 0" configClasses (missionconfigFile >> "cfgHouses" >> worldName)) apply {configName _x};
private _blacklistedGarages = ("count (getArray (_x >> 'garageBlacklists')) > 0" configClasses (missionconfigFile >> "cfgGarages" >> worldName)) apply {configName _x};

//---  Lock All Houses That Can Be Owned
{
    if (isClass (missionConfigFile >> "cfgHouses" >> worldname >> (typeOf _x))) then {
        _x setVariable ["locked",true,true];

        for "_i" from 1 to (getNumber(configFile >> "CfgVehicles" >> (typeOf _x) >> "numberOfDoors")) do {
            _x setVariable [format ["bis_disabled_Door_%1",_i],1,true];
        };
    };
} forEach _allHouses;

//--- Owned Houses
for [{_x=0},{_x<=((["SELECT COUNT(*) FROM houses WHERE owned='1'",2] call MPServer_fnc_database_rawasync_request)#0)},{_x=_x+10}] do {
    private _query = format ["SELECT houses.id, houses.pid, houses.pos, players.name, houses.garage FROM houses INNER JOIN players WHERE houses.owned='1' AND houses.pid = players.pid LIMIT %1,10",_x];
    private _queryResult = [_query,2,true] call MPServer_fnc_database_rawasync_request;
    if (count _queryResult isEqualTo 0) exitWith {};
    {
        _pos = call compile format ["%1",_x select 2];
        _house = nearestObject [_pos, "House"];
        _house setVariable ["house_owner",[_x select 1,_x select 3],true];
        _house setVariable ["house_id",_x select 0,true];
        _house setVariable ["locked",true,true]; //Lock up all the stuff.
        if (_x select 4 isEqualTo 1) then {
            _house setVariable ["garageBought",true,true];
        };
        _numOfDoors = getNumber(configFile >> "CfgVehicles" >> (typeOf _house) >> "numberOfDoors");
        for "_i" from 1 to _numOfDoors do {
            _house setVariable [format ["bis_disabled_Door_%1",_i],1,true];
        };
    } forEach _queryResult;
};

//--- Blacklisted Houses
for "_i" from 0 to count(_blacklistedHouses)-1 do {
    _className = _blacklistedHouses select _i;
    _positions = getArray(missionConfigFile >> "cfgHouses" >> worldName >> _className >> "garageBlacklists");
    {
        _obj = nearestObject [_x,_className];
        if (isNull _obj) then {
            _obj setVariable ["blacklistedGarage",true,true];
        };
    } forEach _positions;
};

//--- Blacklisted Garages
for "_i" from 0 to count(_blacklistedGarages)-1 do {
    _className = _blacklistedGarages select _i;
    _positions = getArray(missionConfigFile >> "cfgGarages" >> worldName >> _className >> "garageBlacklists");
    {
        _obj = nearestObject [_x,_className];
        if (isNull _obj) then {
            _obj setVariable ["blacklistedGarage",true,true];
        };
    } forEach _positions;
};

true