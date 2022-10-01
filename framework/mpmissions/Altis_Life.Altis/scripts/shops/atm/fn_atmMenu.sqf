#include "..\..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_atmMenu.sqf
*/

private ["_units","_type"];

if (!life_var_ATMEnabled) exitWith {
    hint format [localize "STR_Shop_ATMRobbed",(LIFE_SETTINGS(getNumber,"federalReserve_atmRestrictionTimer"))];
};

private _display = createDialog ["Life_atm_management",true];

disableSerialization;
_units = CONTROL(2700,2703);

lbClear _units;
CONTROL(2700,2701) ctrlSetStructuredText parseText format ["<img size='1.7' image='textures\icons\ico_bank.paa'/> $%1<br/><img size='1.6' image='textures\icons\ico_money.paa'/> $%2",[MONEY_BANK] call MPClient_fnc_numberText,[MONEY_CASH] call MPClient_fnc_numberText];

{
    _name = _x getVariable ["realname",name _x];
    if (alive _x && (!(_name isEqualTo profileName))) then {
        switch (side _x) do {
            case west: {_type = "Cop"};
            case civilian: {_type = "Civ"};
            case independent: {_type = "EMS"};
        };
        _units lbAdd format ["%1 (%2)",_x getVariable ["realname",name _x],_type];
        _units lbSetData [(lbSize _units)-1,str(_x)];
    };
} forEach playableUnits;

lbSetCurSel [2703,0];

if (isNil {(group player getVariable "gang_id")}) then {
    (CONTROL(2700,2705)) ctrlEnable false;
    (CONTROL(2700,2706)) ctrlEnable false;
};
