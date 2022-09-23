#include "\life_backend\script_macros.hpp"
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
private _moneyClient = 0;
private _moneyBefore = (serverNamespace getVariable [_moneyVar,0]);
private _moneyAfter = _moneyBefore + _value;

switch (_type) do {
	case "CASH": {_moneyClient = MONEY_CASH};
	case "BANK": {_moneyClient = MONEY_BANK(getPlayerUID _target)};
	case "GANG-BANK": {_moneyClient = MONEY_GANG};
};

if(_moneyClient > _moneyBefore)then{
	_moneyAfter = _moneyClient;
	diag_log format["Money hack detected -> %1",getPlayerUID _target];
	["Hack Detected", "Money client does not match server money", "Antihack"] remoteExecCall ["MPClient_fnc_endMission",_senderOwnerID];
};

if !_serverUpdateOnly then {
	[_action,_type,_value] remoteExecCall ["MPClient_fnc_handleMoney", _targetOwnerID];
};

serverNamespace setVariable [_moneyVar,_moneyAfter];

true