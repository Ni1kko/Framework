#include "..\..\script_macros.hpp"
/*
    File: fn_buyLicense.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Called when purchasing a license. May need to be revised.
*/
private ["_type","_varName","_displayName","_sideFlag","_price"];
_type = _this select 3;

if (!isClass (missionConfigFile >> "cfgLicenses" >> _type)) exitWith {}; //Bad entry?
private _displayName = M_CONFIG(getText,"cfgLicenses",_type,"displayName");
private _price = M_CONFIG(getNumber,"cfgLicenses",_type,"price");

if (life_var_cash < _price) exitWith {hint format [localize "STR_NOTF_NE_1",[_price] call MPClient_fnc_numberText,localize _displayName];};
["SUB","CASH",_price] call MPClient_fnc_handleMoney;

titleText[format [localize "STR_NOTF_B_1", localize _displayName,[_price] call MPClient_fnc_numberText],"PLAIN"];
GIVE_LICENSE(_type);

[2] call MPClient_fnc_updatePartial;
