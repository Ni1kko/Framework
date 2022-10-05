#include "..\..\script_macros.hpp"
/*
    File: fn_wantedMenu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Opens the Wanted menu and connects to the APD.
*/
disableSerialization;

//-- Make sure is bounty hunter or cop
if (playerSide isNotEqualTo west AND not(license_civ_bountyHunter)) exitWith {false};
 
private _display = (if license_civ_bountyHunter then{createDialog ["life_bounty_menu",true]}else{createDialog ["RscDisplayPoliceWanted",true]});
private _list = _display displayCtrl 2401;
private _players = _display displayCtrl 2406;
private _units = [];

lbClear _list;
lbClear _players;

{
    private _side = [playerSide,true] call MPServer_fnc_util_getSideString;
    _players lbAdd format ["%1 - %2", name _x,_side];
    _players lbSetdata [(lbSize _players)-1,str(_x)];
} forEach playableUnits;

private _list2 = CONTROL(2400,2407);
lbClear _list2; //Purge the list

private _crimes = CFG_MASTER(getArray,"crimes");
{
  if (isLocalized (_x select 0)) then {
    _list2 lbAdd format ["%1 - $%2 (%3)",localize (_x select 0),(_x select 1),(_x select 2)];
  } else {
    _list2 lbAdd format ["%1 - $%2 (%3)",(_x select 0),(_x select 1),(_x select 2)];
  };
    _list2 lbSetData [(lbSize _list2)-1,(_x select 2)];
} forEach _crimes;

ctrlSetText[2404,"Establishing connection..."];

if ((call life_coplevel) < 3 && {(call life_adminlevel) isEqualTo 0}) then {
    ctrlShow[2405,false];
};

if (count extdb_var_database_headless_clients > 0) then {
    [player] remoteExec ["HC_fnc_wantedFetch",extdb_var_database_headless_client];
} else {
    [player] remoteExec ["MPServer_fnc_wantedFetch",RE_SERVER];
};