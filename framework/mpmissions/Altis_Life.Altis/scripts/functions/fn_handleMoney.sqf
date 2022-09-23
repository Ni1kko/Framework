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

//-- Make it upper case
_action = toUpper _action;
_type = toUpper _type;

//-- 
if(not(_action in ["ADD","SUB","SET","GIVE","DROP","ZERO","BANKRUPT"]) OR not(_type in ["CASH","BANK","GANG-BANK"])) exitWith 
{
	private _steamID = getPlayerUID player;

	//-- ToDo: trigger anticheat here 
	[format ["Error Invalid action or type: %1 %2",_action,_type],true,true] call MPClient_fnc_log;

	//--Return
	[0,0,0]
};

//-- Allow remoteExec from server to client only
if(isRemoteExecutedJIP OR (isRemoteExecuted AND remoteExecutedOwner isNotEqualTo 2)) exitWith 
{
	private _ownerID = remoteExecutedOwner;

	//-- ToDo: trigger anticheat here
	["Error Invalid remoteExec target or JIP enabled",true,true] call MPClient_fnc_log;

	//--Return
	[0,0,0]
};

//-- Check `life_var_lastBalance` is vaild array
if(isNil "life_var_lastBalance") then {life_var_lastBalance = [0,0,0]};
if(typeName life_var_lastBalance isNotEqualTo "ARRAY") then {life_var_lastBalance = [0,0,0]};

//-- Check `life_var_bankrupt` is vaild bool
if(isNil "life_var_bankrupt") then {life_var_bankrupt = false};
if(typeName life_var_bankrupt isNotEqualTo "BOOL") then {life_var_bankrupt = false};

//-- 
if(_type isEqualTo "BANK" AND life_var_bankrupt) exitWith {
	systemChat "Unable to handle money because are bankrupt!";
	[0,0,0]
};

if(_action isNotEqualTo "GIVE")then{
	[_type,_action,_value,player,true] remoteExecCall ["MPClient_fnc_handleMoneyRequest",2];
};

//-- Handle money
switch _type do 
{
	case "CASH": 
	{  
		switch _action do 
		{
			case "ADD": 
			{
				if (MONEY_DEBT > 0)then{
					[_action,"BANK",_value] call MPClient_fnc_handleMoney;
				}else{
					player setVariable ["money_cash",MONEY_CASH + _value,true];
				};
			};
			case "SUB": 
			{
				player setVariable ["money_cash",MONEY_CASH - _value,true];
				if (MONEY_CASH < 0) then {player setVariable ["money_cash",0,true]};
				if (MONEY_CASH < _value)then{
					private _newDebt = _value - MONEY_CASH;
					[_action,"BANK",_newDebt] call MPClient_fnc_handleMoney;
				};
			};
			case "GIVE": {[_type,_action,_value,_target] remoteExecCall ["MPClient_fnc_handleMoneyRequest",2]};
			case "DROP": {[player,VITEM_MISC_MONEY,_value] call MPClient_fnc_dropItem};
			case "SET": {player setVariable ["money_cash",_value,true]};
			case "ZERO": {player setVariable ["money_cash",0,true]};
		};

		if(MONEY_CASH < 0) then {player setVariable ["money_cash",0,true]};
		life_var_lastBalance set [0,MONEY_CASH];
	};
	case "BANK": 
	{ 
		if(isNil "life_var_bank") then {life_var_bank = 0};
		if(typeName life_var_bank isNotEqualTo "SCALAR") then {life_var_bank = 0};
		
		switch _action do 
		{
			case "ADD": 
			{
				if (MONEY_DEBT > 0)then{
					player setVariable ["money_debt",MONEY_DEBT - _value,true];
					if(MONEY_DEBT < 0) then {player setVariable ["money_debt",0,true]};
					if(MONEY_DEBT > 0) then {
						life_var_bank = life_var_bank - MONEY_DEBT;
					}else{
						life_var_bank = life_var_bank + _value;
					};
				}else{
					life_var_bank = life_var_bank + _value;
				};
			};
			case "SUB": 
			{
				life_var_bank = life_var_bank - _value;
				if (life_var_bank < 0) then {life_var_bank = 0};
				if (life_var_bank < _value)then{
					private _newDebt = _value - life_var_bank;
					player setVariable ["money_debt",MONEY_DEBT + _newDebt,true];
				};
			};
			case "SET": {life_var_bank = _value};
			case "ZERO": {life_var_bank = 0};
			case "BANKRUPT": 
			{
				["ZERO","CASH"] call MPClient_fnc_handleMoney;
				["ZERO","BANK"] call MPClient_fnc_handleMoney;
				player setVariable ["money_debt",0,true];
				life_var_bankrupt = true;
			};
		}; 
		if(life_var_bank < 0) then {life_var_bank = 0};
		life_var_lastBalance set [1,life_var_bank];
	};
	case "GANG-BANK": 
	{ 
		switch _action do 
		{
			case "ADD": {};
			case "SUB": {};
			case "ZERO": {};
		};
		//if( ) then { };
		life_var_lastBalance set [2,0];
	};
};

//-- No negative values
if(MONEY_DEBT < 0) then {player setVariable ["money_debt",0,true]};

//-- Update database
[6] call MPClient_fnc_updatePartial;

//-- Return
life_var_lastBalance
