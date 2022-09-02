/*
    File: fn_federalUpdate.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Uhhh, adds to it?
*/

private _vaultObject = missionNamespace getVariable ["fed_bank",objNull];
private _whereClause = [["serverID",["DB","INT",call life_var_serverID] call life_fnc_database_parse]];
private _lifeConfig = missionConfigFile >> "Life_Settings";

[
    getNumber(_lifeConfig >> "federalReserve_resetAfterRestart") isEqualTo 1,
    getNumber(_lifeConfig >> "federalReserve_startGold"),
    getNumber(_lifeConfig >> "federalReserve_MaxGold"),
    getNumber(_lifeConfig >> "federalReserve_AddMoreEvery"),
    getNumber(_lifeConfig >> "federalReserve_AddMin"),
    getNumber(_lifeConfig >> "federalReserve_AddMid"),
    getNumber(_lifeConfig >> "federalReserve_AddMax")
] params [
    ["_resetAfterRestart",false],
    ["_startGold",0],
    ["_maxGold",0],
    ["_addMoreEvery",0],
    ["_addMin",0],
    ["_addMid",0],
    ["_addMax",0]
];

if _resetAfterRestart then{
    ["CALL", "resetFedVault"]call life_fnc_database_request;
}else{
    private _queryRes = ["READ", "servers",[["vault"],_whereClause],true] call life_fnc_database_request;
 
    private _vault = ["GAME","INT",_queryRes param [0, 0]] call life_fnc_database_parse;

    if(_vault > 0)then{
        _startGold = _vault;
    }; 
};

_vaultObject setVariable ["safe",_startGold,true];
 
for "_i" from 0 to 1 step 0 do 
{
    uiSleep (_addMoreEvery * 60);

    //-- Get current gold
    private _currentfunds = _vaultObject getVariable ["safe",0];

    //-- Add more gold
    private _newfunds = _currentfunds + round(random ["_addMin","_addMid","_addMax"]);

    //-- Limit reached.... hmmm just half the amount of gold we have?
    if(_newfunds > _maxGold)then{
        _newfunds = _newfunds / 2;
    };

    //-- Update the vault
    fed_bank setVariable ["safe",_newfunds,true];

    //-- Update the database 
    ["UPDATE", "servers", [[["vault",["DB","INT", _newfunds] call life_fnc_database_parse]],_whereClause]]call life_fnc_database_request;
};

false
