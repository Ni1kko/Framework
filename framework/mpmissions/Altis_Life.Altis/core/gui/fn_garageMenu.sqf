/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/ 

disableSerialization;

private _vehicles = param [0,[],[[]]]; 
private _display = findDisplay 2800;
private _listBox = _display displayCtrl 2802;

//--- Clear listbox
lbClear _listBox;

//--- Disable some controls
ctrlShow[2803,false];
ctrlShow[2830,false];
ctrlShow[2810,false];
ctrlShow[2811,false];

//--- No vehicles, Exit script!
if (count _vehicles isEqualTo 0) exitWith {
    ctrlSetText[2811,localize "STR_Garage_NoVehicles"];
};

//--- Add vehicles to listbox
{
    private _vehicleInfo = [_x#2] call MPClient_fnc_fetchVehInfo;
    _listBox lbAdd (_vehicleInfo#3);
    _listBox lbSetData [(lbSize _listBox)-1,str([_x#2,_x#8])];
    _listBox lbSetPicture [(lbSize _listBox)-1,_vehicleInfo#2];
    _listBox lbSetValue [(lbSize _listBox)-1,_x#0];
} forEach _vehicles;

//--- Variable For VehicleList In Garage
uiNamespace setVariable ["VehicleList", _vehicles];

true