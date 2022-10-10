#include "..\..\clientDefines.hpp"
/*
    File: fn_onPlayerKilled.sqf
    Author: Bryan "Tonic" Boardwine
    Description:
    When the player dies collect various information about that player
    and pull up the death dialog / camera functionality.
*/
params [
    ["_unit",objNull,[objNull]],
    ["_killer",objNull,[objNull]]
];

disableSerialization;

//-- Log death
//[format ["%1(%2) killed %1(%2)",_killer getVariable["realname",""],getPlayerUID _killer,_unit getVariable["realname",""],getPlayerUID _unit],true,true] call MPClient_fnc_log;

if  !((vehicle _unit) isEqualTo _unit) then {
    UnAssignVehicle _unit;
    _unit action ["getOut", vehicle _unit];
    _unit setPosATL [(getPosATL _unit select 0) + 3, (getPosATL _unit select 1) + 1, 0];
};

private _arrested = (_unit getVariable ["arrested",false]);

//Set some vars
{_unit setVariable _x} forEach [
    ["Revive",true,true],
    ['restrained',false,true],
    ['Escorting',false,true],
    ['transporting',false,true],
    ['playerSurrender',false,true],
    ['steam64id',getPlayerUID _unit,true],
    ['realname',profileName,true]
];

//--
[_unit] call life_fnc_leaveCombat;
[_unit] call life_fnc_leaveNewLife;

player setVariable ["lifeState","DEAD",true];
life_var_isBusy = false;
life_var_hunger = 0;
life_var_thirst = 0;

//close the esc dialog
if (dialog) then {
    closeDialog 0;
};

//-- Handle killer
if (!isNull _killer) then 
{  
    private _isKillerCop = side _killer isEqualTo west;
    private _isPlayerCop = side _unit isEqualTo west;
    
    //-- Handle Killed by police
    if (_isKillerCop AND not(_isPlayerCop)) then 
    {
        life_copRecieve = _killer;

        //-- Handle if they robbed the federal reserve?
        if (!life_var_ATMEnabled AND MONEY_CASH > 0) then
        {
            [format [localize "STR_Cop_RobberDead",[MONEY_CASH] call MPClient_fnc_numberText]] remoteExecCall ["MPClient_fnc_broadcast",RE_CLIENT];
            ["ZERO","CASH"] call MPClient_fnc_handleMoney;
        };
    };

    //-- Handle wanted
    if (_killer isNotEqualTo _unit) then
    {
        //-- Make the killer wanted
        if (alive _killer AND not(local _killer)) then 
        {
            if (vehicle _killer isKindOf "LandVehicle") then {  
                [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187V"] remoteExecCall ["MPServer_fnc_wantedAdd",2];
                //[_killer, ["pilot","driver","trucking","boat"], "STR_Civ_LicenseRemove_1"] remoteExecCall ["MPClient_fnc_removeLicenses",owner _killer];
            } else {
                [getPlayerUID _killer,_killer getVariable ["realname",name _killer],"187"] remoteExecCall ["MPServer_fnc_wantedAdd",2];
                //[_killer, ["gun"], "STR_Civ_LicenseRemove_2"] remoteExecCall ["MPClient_fnc_removeLicenses",owner _killer];
            };
        }else{ 
            life_var_removeWanted = true;
        };
    };
};

//-- Drop items and strip player
[_unit,true] call MPClient_fnc_stripDownPlayer;

//-- Stop bleeding
["all"] call MPClient_fnc_removeBuff;

//-- Reset any damage
player setDamage 0;

//-- remove death screen
["RscTitleDeathScreen"] call MPClient_fnc_destroyRscLayer;
closeDialog 0;		
titleCut ["", "BLACK IN", 1];

//-- Leave side chat 
[_unit,false,side _unit] remoteExecCall ["MPServer_fnc_managesc",2];

//--
[_unit, _arrested] spawn MPClient_fnc_respawned;

true