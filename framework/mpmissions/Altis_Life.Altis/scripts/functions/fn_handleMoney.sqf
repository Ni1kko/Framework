#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/ 

params [
	["_action","",[""]],
	["_type","",[""]],
	["_value",0,[0]],
	["_target",objNull,[objNull]]
];


private _bankruptTimer = 20; //Mins till bankrupt expires

//-- Make it upper case
_action = toUpper _action;
_type = toUpper _type;

//-- Allow remoteExec from server to client only
if(isRemoteExecutedJIP OR (isRemoteExecuted AND remoteExecutedOwner isNotEqualTo 2)) exitWith 
{
	private _ownerID = remoteExecutedOwner;
	private _caller = [_ownerID] call MPServer_fnc_util_getPlayerObject;
	private _steamID = getPlayerUID _caller;

	//-- ToDo: trigger anticheat here
	[format["Error Invalid remoteExec target or JIP enabled, Triggred By UID: %1",_steamID],true,true] call MPClient_fnc_log;

	//--Return
	[0,0,0]
};

//-- 
if(not(_action in ["ADD","SUB","SET","GIVE","DROP","ZERO","BANKRUPT"]) OR not(_type in ["CASH","BANK","GANG"])) exitWith 
{
	private _steamID = getPlayerUID player;
	
	//-- ToDo: trigger anticheat here 
	[format ["Error Invalid action or type: %1 %2 Triggred By UID: %3",_action,_type,_steamID],true,true] call MPClient_fnc_log;

	//--Return
	[0,0,0]
};

//-- Check `life_var_lastBalance` is vaild array
if(isNil "life_var_lastBalance") then {life_var_lastBalance = [0,0,0,0]};
if(typeName life_var_lastBalance isNotEqualTo "ARRAY") then {life_var_lastBalance = [0,0,0,0]};

//-- Check `life_var_bankrupt` is vaild bool
if(isNil "life_var_bankrupt") then {life_var_bankrupt = false};
if(typeName life_var_bankrupt isNotEqualTo "BOOL") then {life_var_bankrupt = false};

//-- 
if(_type isEqualTo "BANK" AND life_var_bankrupt) exitWith {
	systemChat "Unable to handle money because are bankrupt!";
	[0,0,0]
};

//-- Handle money
switch _type do 
{
	case "CASH": 
	{  
		if(isNil {MONEY_CASH}) then {SET_MONEY_CASH(player, 0)};
		if(typeName MONEY_CASH isNotEqualTo "SCALAR") then {SET_MONEY_CASH(player, 0)};
		
		switch _action do 
		{
			case "ADD": 
			{
				if (MONEY_DEBT > 0)then{
					[_action,"BANK",_value] call MPClient_fnc_handleMoney;
				}else{
					ADD_MONEY_CASH(player, _value);
				};
			};
			case "SUB": 
			{
				SUB_MONEY_CASH(player, _value);
				if (MONEY_CASH < 0) then {SET_MONEY_CASH(player, 0)};
				if (MONEY_CASH < _value)then{
					private _newDebt = _value - MONEY_CASH;
					[_action,"BANK",_newDebt] call MPClient_fnc_handleMoney;
				};
			};
			case "GIVE": {[_type,_action,_value,_target,false] remoteExecCall ["MPClient_fnc_handleMoneyRequest",2]};
			case "DROP": {[player,VITEM_MISC_MONEY,_value] call MPClient_fnc_dropItem};
			case "SET": {SET_MONEY_CASH(player, _value)};
			case "ZERO": {SET_MONEY_CASH(player, 0)};
		};

		if(MONEY_CASH < 0) then {SET_MONEY_CASH(player, 0)};
		life_var_lastBalance set [0,MONEY_CASH];
	};
	case "BANK": 
	{ 
		if(isNil {MONEY_BANK}) then {SET_MONEY_BANK(player, 0)};
		if(typeName MONEY_BANK isNotEqualTo "SCALAR") then {SET_MONEY_BANK(player, 0)};
		
		switch _action do 
		{
			case "ADD": 
			{
				if (MONEY_DEBT > 0)then{
					player setVariable ["money_debt",MONEY_DEBT - _value,true];
					if(MONEY_DEBT < 0) then {player setVariable ["money_debt",0,true]};
					if(MONEY_DEBT > 0) then {
						SUB_MONEY_BANK(player, MONEY_DEBT);
					}else{
						ADD_MONEY_BANK(player, _value);
					};
				}else{
					ADD_MONEY_BANK(player, _value);
				};
			};
			case "SUB": 
			{
				SUB_MONEY_BANK(player, _value);
				if (MONEY_BANK < 0) then {SET_MONEY_BANK(player, 0)};
				if (MONEY_BANK < _value)then{
					private _newDebt = _value - MONEY_BANK;
					ADD_MONEY_DEBT(player, _newDebt);
				};
			};
			case "SET": {SET_MONEY_BANK(player, _value)};
			case "GIVE": {[_type,_action,_value,_target,false] remoteExecCall ["MPClient_fnc_handleMoneyRequest",2]};
			case "ZERO": {SET_MONEY_BANK(player, 0)};
			case "BANKRUPT": 
			{
				life_var_bankruptTime = diag_tickTime;
				life_var_bankrupt = true;
				_bankruptTimer spawn {
					if(!isNil "life_var_bankruptTime")exitWith{true};
					waitUntil {
						uiSleep 2;
						if (MONEY_CASH > 0)then{SET_MONEY_CASH(player, 0)};
						if (MONEY_BANK > 0)then{SET_MONEY_BANK(player, 0)};
						if (MONEY_DEBT > 0)then{SET_MONEY_DEBT(player, 0)};
						not(life_var_bankrupt) OR (diag_tickTime - life_var_bankruptTime) > (_this * 60)
					};
					systemChat "You are no longer bankrupt!";
					life_var_bankrupt = false;
					life_var_bankruptTime = nil;
				};
			};
		}; 
		if(MONEY_BANK < 0) then {SET_MONEY_BANK(player, 0)};
		life_var_lastBalance set [1,MONEY_BANK];
		life_var_lastBalance set [3,MONEY_DEBT];
	};
	case "GANG": 
	{ 
		if(isNil {MONEY_GANG}) then {SET_MONEY_GANG(player, 0)};
		if(typeName MONEY_GANG isNotEqualTo "SCALAR") then {SET_MONEY_GANG(player, 0)};
		
		switch _action do 
		{
			case "ADD": {ADD_MONEY_GANG(player, _value)};
			case "SUB": {SUB_MONEY_GANG(player, _value)};
			case "ZERO": {SET_MONEY_GANG(player, 0)};
			case "GIVE": {[_type,_action,_value,_target,false] remoteExecCall ["MPClient_fnc_handleMoneyRequest",2]};
		};
		if(MONEY_GANG < 0) then {SET_MONEY_GANG(player, 0)};
		life_var_lastBalance set [2,MONEY_GANG];
	};
};

//-- Handle server values
if(_action isNotEqualTo "GIVE")then{
	[_type,_action,_value,player,true] remoteExecCall ["MPClient_fnc_handleMoneyRequest",2];
};

//-- Update database
[6] call MPClient_fnc_updatePlayerDataPartial;

//-- Return
life_var_lastBalance
