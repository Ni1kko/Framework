/*
    File: fn_filterGarage.sqf
    Author: ToMA3
*/
params ["_ctrl", "_list", "_text"];
disableSerialization;
private _listBox = (ctrlParent _ctrl) displayCtrl _list;
private _text = (ctrlParent _ctrl) displayCtrl _text;
_text ctrlSetStructuredText parseText "";
private _array = uiNamespace getVariable ["VehicleList", []];
lbClear _listBox;

{
     _vehicleInfo = [(_x select 2)] call MPClient_fnc_fetchVehInfo;
    if (toLower(ctrlText _ctrl) in toLower(_vehicleInfo select 3)) then {
         _listBox lbAdd (_vehicleInfo select 3);
        _tmp = [(_x select 2),(_x select 8)];
        _tmp = str(_tmp);
        _listBox lbSetData [(lbSize _listBox)-1,_tmp];
        _listBox lbSetPicture [(lbSize _listBox)-1,(_vehicleInfo select 2)];
        _listBox lbSetValue [(lbSize _listBox)-1,(_x select 0)];
    };
} forEach _array;