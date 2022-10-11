#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_processAction.sqf
*/

private _vendor = [_this,0,objNull,[objNull]] call BIS_fnc_param;
private _type = [_this,3,"",[""]] call BIS_fnc_param;
private _cfgProcessors = missionConfigFile >> "CfgProcessors";
private _cfgProcessor = _cfgProcessors >> _type;

//-- Bad class
if(not(isClass _cfgProcessor) OR count _type isEqualTo 0) exitWith {
    if(count _type isEqualTo 0) then {
        _type = "<STRING-NULL>";
    };
    [format ["[fn_processAction] Invalid processor type: %1",_type],true,true] call MPClient_fnc_log;
    false
};

//-- Bad parmas or user not dormant
if (isNull _vendor OR not(call MPClient_fnc_isDormant)) exitWith {false};

//-- Too far away
if (player distance _vendor > 10) exitWith {
    hint "You are too far away from the vendor"; 
    false
};

life_var_isBusy = true;//Lock out other actions during processing.
 
private _materialsRequired = getArray(_cfgProcessors >> "MaterialsReq");
private _materialsGiven = getArray(_cfgProcessors >> "MaterialsGive");
private _noLicenseCost = getNumber(_cfgProcessors >> "NoLicenseCost");
private _text = (getText(_cfgProcessors >> "Text")) call BIS_fnc_localize;
private _itemInfo = [_materialsRequired,_materialsGiven,_noLicenseCost,_text];
private _hasLicense = LICENSE_VALUE(_type,"civ");

if (not(_hasLicense) AND (_vendor in [mari_processor,coke_processor,heroin_processor])) then {
    _hasLicense = true;
};

//Setup vars.
_itemInfo params [
    "_oldItem",
    "_newItem",
    "_cost",
    "_upp"
];

if (count _oldItem isEqualTo 0) exitWith {life_var_isBusy = false;};

private _exit = false;
private _totalConversions = [];
private _cost = _cost * (count _oldItem);
private _minimumConversions = _totalConversions call BIS_fnc_lowestNum;
private _oldItemWeight = 0;
private _newItemWeight = 0;

{
    private _weight = ([_x select 0] call MPClient_fnc_itemWeight) * (_x select 1);
    _newItemWeight = _newItemWeight + _weight;
} count _newItem;

{
    private _var = ITEM_VALUE(_x select 0); 
    private _weight = ([_x select 0] call MPClient_fnc_itemWeight) * (_x select 1);

    _oldItemWeight = _oldItemWeight + _weight;

    if (_var isEqualTo 0) exitWith {_exit = true;};
    if (_var < (_x select 1)) exitWith {_exit = true;};
    _totalConversions pushBack (floor (_var/(_x select 1)));
} forEach _oldItem;

if _exit exitWith {
    hint localize "STR_NOTF_NotEnoughItemProcess";
    life_var_processingResource = false;
    life_var_isBusy = false;
};
 
if (_newItemWeight > _oldItemWeight) then {
    private _netChange = _newItemWeight - _oldItemWeight;
    private _freeSpace = life_maxWeight - life_var_carryWeight;
    if (_freeSpace < _netChange) exitWith {_exit = true;};
    private _estConversions = floor(_freeSpace / _netChange);
    if (_estConversions < _minimumConversions) then {
        _minimumConversions = _estConversions;
    };
};

if _exit exitWith {
    hint localize "STR_Process_Weight"; 
    life_var_processingResource = false; 
    life_var_isBusy = false;
};

//Setup our progress bar.
disableSerialization;
"progressBar" cutRsc ["RscTitleProgressBar","PLAIN"];
_ui = uiNamespace getVariable "RscTitleProgressBar";
_progress = _ui displayCtrl 38201;
_pgText = _ui displayCtrl 38202;
_pgText ctrlSetText format ["%2 (1%1)...","%",_upp];
_progress progressSetPosition 0.01;
_cP = 0.01;

life_var_processingResource = true;

if _hasLicense then 
{
    for "_i" from 0 to 1 step 0 do {
        uiSleep  0.28;
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
        if (_cP >= 1) exitWith {};
        if (player distance _vendor > 10) exitWith {};
    };
    if (player distance _vendor > 10) exitWith {hint localize "STR_Process_Stay"; "progressBar" cutText ["","PLAIN"]; life_var_processingResource = false; life_var_isBusy = false;};

    {[false,_x#0,((_x#1)*(_minimumConversions))] call MPClient_fnc_handleInv} count _oldItem;
    {[true, _x#0,((_x#1)*(_minimumConversions))] call MPClient_fnc_handleInv} count _newItem;

    "progressBar" cutText ["","PLAIN"];
    if (_minimumConversions isEqualTo (_totalConversions call BIS_fnc_lowestNum)) then {
        hint localize "STR_NOTF_ItemProcess";} else {hint localize "STR_Process_Partial";};
    life_var_processingResource = false; life_var_isBusy = false;
} else {
    if (MONEY_CASH < _cost) exitWith {
        hint format [localize "STR_Process_License",[_cost] call MPClient_fnc_numberText]; 
    };

    for "_i" from 0 to 1 step 0 do 
    {
        uiSleep  0.9;
        _cP = _cP + 0.01;
        _progress progressSetPosition _cP;
        _pgText ctrlSetText format ["%3 (%1%2)...",round(_cP * 100),"%",_upp];
        if (_cP >= 1) exitWith {};
        if (player distance _vendor > 10) exitWith {};
        if (MONEY_CASH < _cost) exitWith {};
    };

    if (player distance _vendor > 10) exitWith {
        hint localize "STR_Process_Stay";
    };

    if (MONEY_CASH < _cost) exitWith {
        hint format [localize "STR_Process_License",[_cost] call MPClient_fnc_numberText]; 
    };

    {[false,_x#0,((_x#1)*(_minimumConversions))] call MPClient_fnc_handleInv} count _oldItem;
    {[true,_x#0,((_x#1)*(_minimumConversions))] call MPClient_fnc_handleInv} count _newItem;

    private _notification = "STR_NOTF_ItemProcess";
    private _currentConversions = _totalConversions call BIS_fnc_lowestNum;
    if (_minimumConversions isNotEqualTo _currentConversions) then {
        _notification = "STR_Process_Partial";
    };

    hint localize _notification;
    ["SUB","CASH",_cost] call MPClient_fnc_handleMoney;
};

"progressBar" cutText ["","PLAIN"];
life_var_processingResource = false;
life_var_isBusy = false;

true