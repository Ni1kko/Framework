#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_handleMoneyRequest.sqf
*/

params [
	["_action","",[""]],
	["_type","",[""]],
	["_value",0,[0]],
	["_target",objNull,[objNull]],
	["_serverUpdateOnly",false,[false]]
];

private _targetOwnerID = owner _target;
private _senderOwnerID = remoteExecutedOwner;
private _sender = [_senderOwnerID] call MPServer_fnc_util_getPlayerObject;

//-- Nope very target
if(isNull _target)exitWith{
	false
};

//-- Nope no JIP
if(isRemoteExecutedJIP)exitWith{
	false
};

//-- Nope very bad sender
if(isNull _sender AND (isRemoteExecuted AND _senderOwnerID isNotEqualTo 2))exitWith{
	false
};

//-- Nope sending to self
if(_sender isEqualTo _target)exitWith{
	false
};

private _moneyVar = format ["%1_%2",toLower _action, getPlayerUID _target];
private _moneyBefore = (serverNamespace getVariable [_moneyVar,0]);
private _moneyAfter = _moneyBefore + _value;

//-- Get client values
private _moneyClient = switch (_type) do {
	case "CASH": 		{GET_MONEY_CASH(_target)};
	case "BANK": 		{GET_MONEY_BANK(_target)};
	case "GANG-BANK": 	{GET_MONEY_GANG(_target)};
	default {0}
};

//-- Server values don't match client values (Hacker?)
if(_moneyClient > _moneyBefore)then{
	_moneyAfter = _moneyClient;
	diag_log format["Money hack detected -> %1",getPlayerUID _target];
	["Hack Detected", "Money client does not match server money", "Antihack"] remoteExecCall ["MPClient_fnc_endMission",_senderOwnerID];
};

//-- Send money to another player
if (_action isEqualTo "GIVE" AND alive _target AND alive _sender AND not(_serverUpdateOnly)) then {
	private _senderMoney = switch (_type) do {
		case "CASH": 		{GET_MONEY_CASH(_sender)};
		case "BANK": 		{GET_MONEY_BANK(_sender)};
		case "GANG-BANK": 	{GET_MONEY_GANG(_sender)};
		default {0}
	};

	//-- do they have enough
	if(_senderMoney < _value)exitWith{
		(format["Sorry No Can Do!\nYou don't have %1 to send!",_value]) remoteExec ["hint",_senderOwnerID]
	};

	["SUB",_type,_value] remoteExecCall ["MPClient_fnc_handleMoney", _senderOwnerID];
	["ADD",_type,_value] remoteExecCall ["MPClient_fnc_handleMoney", _targetOwnerID];
};

//-- Update server values
serverNamespace setVariable [_moneyVar,_moneyAfter];

true