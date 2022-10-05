#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_fetchBankDataRequest.sqf (Server)
*/

params [
    ["_player",objNull,[objNull]]
];

if (isNull _player) exitWith {false};

private _BEGuid = GET_BEGUID(_player);
private _queryBankResult = ["READ", "bankaccounts", [["funds","debt"],[["BEGuid",str _BEGuid]]],true]call MPServer_fnc_database_request;

if (_queryBankResult isEqualTo ["DB:Read:Task-failure",false]) exitWith {
	[format ["Error reading bank: %1",_BEGuid]] call MPServer_fnc_log;
	false;
};

if (count _queryBankResult isEqualTo 0) then {
	private _funds = getNumber(missionConfigFile >> "cfgMaster" >> "startingFunds");
    ["CREATE", "bankaccounts", 
        [
            ["BEGuid", 			["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
            ["funds", 			["DB","A2NET", _funds] call MPServer_fnc_database_parse]
        ]
    ] call MPServer_fnc_database_request;
	_queryBankResult = [_funds, 0];
};

//--- 
[[
	["GAME","A2NET", (_queryBankResult#0)] call MPServer_fnc_database_parse,
	["GAME","A2NET", (_queryBankResult#1)] call MPServer_fnc_database_parse
],{
    params ["_bank","_debt"];
    
    if(_debt > 0) then {_bank = 0};
	
    ["SET","BANK",_bank] call MPClient_fnc_handleMoney;
    ["SET","DEBT",_debt] call MPClient_fnc_handleMoney;
}]remoteExecCall ["CALL",owner _player];

true