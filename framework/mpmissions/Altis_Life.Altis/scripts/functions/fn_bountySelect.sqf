/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private["_display","_list","_uid"];
disableSerialization;

private _display = findDisplay 2400;
private _list = _display displayCtrl 2402;
private _data = call compile format["%1", lbData[2401,(lbCurSel 2401)]];

if(2500 > MONEY_BANK) exitWith {hint "You do not have enough money in your bank to pay the civilian."; false};
if(isNil "_data" OR {typeName _data isNotEqualTo "ARRAY" OR {count _data < 2}}) exitWith {hint "An error occured, please try again."; false};

//--- Find player
private _player = [_data#1] call MPServer_fnc_util_getPlayerObject; 
if(isNull _player) exitWith {hint "An error occured, Null <player object>."; false};

//--- 
private _nearestTown = (nearestLocations [_player,["NameCityCapital","NameCity","NameVillage"],10000]) select 0;
private _townName = text _nearestTown;
private _townPos = position _nearestTown;
hint format["A civilian has saw %1 near %2. %2 is %3M away from you. You pay the civilain £2500 for the tip.",_player getVariable["realname",name _player], _townName, round(player distance _townPos)];
["SUB","BANK",2500] call MPClient_fnc_handleMoney;

true