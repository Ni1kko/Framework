#include "..\..\clientDefines.hpp"
/*
    ## Nikko Renolds
    ## https://github.com/Ni1kko/FrameworkV2
    ## fn_cellphone_playerFilter.sqf
*/
disableSerialization;
private _display = findDisplay 8500;
if(isNull _display) exitWith {};
if(count life_var_phoneContacts < 1) exitWith {};

private _playerList = _display displayCtrl 1500;
private _filter = ctrlText (_display displayCtrl 1400);
waitUntil {sleep(random(0.2)); !life_var_phoneFilter};

if(_filter != ctrlText (_display displayCtrl 1400)) exitWith {life_var_phoneFilter = false;};

life_var_phoneFilter = true;
private _queue = [];
{
    if(_filter != ctrlText (_display displayCtrl 1400)) exitWith {life_var_phoneFilter = false;};
    if(_filter == "" || {_filter == "Enter Filter..."} || { ( ( toLower ( _x select 0 ) ) find ( toLower _filter ) ) > -1 }) then {
        _queue pushBack _x;
    };
} forEach life_var_phoneContacts;

lbClear _playerList;
{
    _playerList lbAdd (_x#0);
    _playerList lbSetData [(lbSize _playerList -1), (str _x)];
    _playerList lbSetPicture [(lbSize _playerList -1),(_x#3)];
} forEach _queue;
lbSort _playerList;

life_var_phoneFilter = false;