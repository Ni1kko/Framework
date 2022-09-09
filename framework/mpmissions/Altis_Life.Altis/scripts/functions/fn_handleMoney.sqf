/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_action","",[""]],
	["_type","",[""]],
	["_value",0,[0]]
];

//-- Make it upper case
_action = toUpper _action;
_type = toUpper _type;

//-- 
if(not(_action in ["ADD","SUB","ZERO","BANKRUPT"]) OR not(_type in ["CASH","BANK","GANG-BANK"])) exitWith 
{
	private _steamID = getPlayerUID player;

	//-- ToDo: trigger anticheat here
	diag_log format ["[ERROR] Invalid action or type: %1 %2",_action,_type];

	//--Return
	[0,0,0]
};

//-- Allow remoteExec from server to client only
if(isRemoteExecutedJIP OR (isRemoteExecuted AND remoteExecutedOwner isNotEqualTo 2)) exitWith 
{
	private _ownerID = remoteExecutedOwner;

	//-- ToDo: trigger anticheat here
	diag_log "[ERROR] Invalid remoteExec target or JIP enabled";

	//--Return
	[0,0,0]
};

//-- Check `life_var_lastBalance` is vaild array
if(isNil "life_var_lastBalance") then {life_var_lastBalance = [0,0,0]};
if(typeName life_var_lastBalance isNotEqualTo "ARRAY") then {life_var_lastBalance = [0,0,0]};

//-- Check `life_var_debtOwed` is vaild number
if(isNil "life_var_debtOwed") then {life_var_debtOwed = 0};
if(typeName life_var_debtOwed isNotEqualTo "SCALAR") then {life_var_debtOwed = 0};

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
		if(isNil "life_var_cash") then {life_var_cash = 0;};
		if(typeName life_var_cash isNotEqualTo "SCALAR") then {life_var_cash = 0};

		switch _action do 
		{
			case "ADD": 
			{
				if (life_var_debtOwed > 0)then{
					[_action,"BANK",_value] call MPClient_fnc_handleMoney;
				}else{
					life_var_cash = life_var_cash + _value;
				};
			};
			case "SUB": 
			{
				life_var_cash = life_var_cash - _value;
				if (life_var_cash < 0) then {life_var_cash = 0};
				if (life_var_cash < _value)then{
					private _newDebt = _value - life_var_cash;
					[_action,"BANK",_newDebt] call MPClient_fnc_handleMoney;
				};
			};
			case "ZERO": {life_var_cash = 0};
		};

		if(life_var_cash < 0) then {life_var_cash = 0};
		life_var_lastBalance set [0,life_var_cash];
	};
	case "BANK": 
	{ 
		if(isNil "life_var_bank") then {life_var_bank = 0};
		if(typeName life_var_bank isNotEqualTo "SCALAR") then {life_var_bank = 0};
		
		switch _action do 
		{
			case "ADD": 
			{
				if (life_var_debtOwed > 0)then{
					life_var_debtOwed = life_var_debtOwed - _value; 
					if(life_var_debtOwed < 0) then {life_var_debtOwed = 0};
					if(life_var_debtOwed > 0) then {
						life_var_bank = life_var_bank - life_var_debtOwed;
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
					life_var_debtOwed  = life_var_debtOwed + _newDebt;
				};
			};
			case "ZERO": {life_var_bank = 0};
			case "BANKRUPT": 
			{
				["ZERO","CASH"] call MPClient_fnc_handleMoney;
				["ZERO","BANK"] call MPClient_fnc_handleMoney;
				life_var_debtOwed = 0;
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
if(life_var_debtOwed < 0) then {life_var_debtOwed = 0};

//-- Update database
[6] call MPClient_fnc_updatePartial;

//-- Return
life_var_lastBalance
