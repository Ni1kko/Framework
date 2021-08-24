private _ret = _this select 0;

if (isNil "_ret") exitWith {};
if (isNull _ret) exitWith {};

[life_var_bank,life_cash,owner player,player,profileNameSteam,getPlayerUID player,playerSide] remoteExecCall ["life_fnc_adminInfo",_ret];
