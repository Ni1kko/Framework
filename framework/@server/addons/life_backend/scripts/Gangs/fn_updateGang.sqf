#include "\life_backend\script_macros.hpp"
/*
    File: fn_updateGang.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Updates the gang information?
*/
private ["_groupID","_bank","_maxMembers","_members","_membersFinal","_query","_owner"];
params [
    ["_mode",0,[0]],
    ["_group",grpNull,[grpNull]]
];

if (isNull _group) exitWith {}; //FAIL

_groupID = _group getVariable ["gang_id",-1];
if (_groupID isEqualTo -1) exitWith {};

switch (_mode) do {
    case 0: {
        _bank = ["DB","A2NET", _group getVariable [GET_GANG_MONEY_VAR,0]] call MPServer_fnc_database_parse;
        _maxMembers = _group getVariable ["gang_maxMembers",8];
        _members = ["DB","ARRAY", _group getVariable ["gang_members",[]]] call MPServer_fnc_database_parse;
        _owner = _group getVariable ["gang_owner",""];
        if (_owner isEqualTo "") exitWith {};

        _query = format ["UPDATE gangs SET bank='%1', maxmembers='%2', owner='%3' WHERE id='%4'",_bank,_maxMembers,_owner,_groupID];
    };

    case 1: {
        params [
            "",
            "",
            ["_deposit",false,[false]],
            ["_value",0,[0]],
            ["_unit",objNull,[objNull]],
            ["_cash",0,[0]]
        ];
        
        private _sessionvar = format ["MPServer_var_gangBankResponse_%1",_groupID];
        private _sessionlocked = missionNamespace getVariable [_sessionvar,false];

        if _sessionlocked exitWith {
            [1,"You or a fellow gang member are already performing a bank transaction. Please wait a moment.",true] remoteExecCall ["MPClient_fnc_broadcast",remoteExecutedOwner];
        };

        missionNamespace setVariable [_sessionvar,true];

        if (_deposit) then {
            if (_value > (GET_MONEY_CASH(_unit))) exitWith {
                [1,"STR_ATM_NotEnoughFundsG",true] remoteExecCall ["MPClient_fnc_broadcast",remoteExecutedOwner];
                breakOut "";
            };
            [_sessionvar, _value,{
                params [
                    ["_sessionvar",""],
                    ["_value",0,[0]]
                ];
                ["ADD","GANG",_value] call MPClient_fnc_handleMoney;
                ["SUB","CASH",_value] call MPClient_fnc_handleMoney;
                [1,"STR_ATM_DepositSuccessG",true,[_value]] call MPClient_fnc_broadcast;
                missionNamespace setVariable [_sessionvar,false];
                publicVariableServer _sessionvar;
            }] remoteExecCall ["call",remoteExecutedOwner];
        } else {
            if (_value > (_group getVariable [GET_GANG_MONEY_VAR,0])) exitWith {
                [1,"STR_ATM_NotEnoughFundsG",true] remoteExecCall ["MPClient_fnc_broadcast",remoteExecutedOwner];
                breakOut "";
            };
            [_sessionvar, _value,{
                params [
                    ["_sessionvar",""],
                    ["_value",0,[0]]
                ];
                ["SUB","GANG",_value] call MPClient_fnc_handleMoney;
                ["ADD","CASH",_value] call MPClient_fnc_handleMoney;
                [_value] call MPClient_fnc_gangBankResponse;
                missionNamespace setVariable [_sessionvar,false];
                publicVariableServer _sessionvar;
            }] remoteExecCall ["call",remoteExecutedOwner];
        };

        //-- Wait for transaction to complete on client
        [_group, _groupID, _sessionvar]spawn{
            params [
                ["_group",grpNull],
                ["_groupID",-1],
                ["_sessionvar",""]
            ];
            waitUntil {not(missionNamespace getVariable [_sessionvar,false]) OR isNull _group};
            if (isNull _group) exitWith {false};
            
            [format ["UPDATE gangs SET bank='%1' WHERE id='%2'",(["DB","A2NET", _group getVariable [GET_GANG_MONEY_VAR,0]] call MPServer_fnc_database_parse),_groupID]] call MPServer_fnc_fetchPlayerDataRequest;
            true
        };
    };

    case 2: {
        _query = format ["UPDATE gangs SET maxmembers='%1' WHERE id='%2'",(_group getVariable ["gang_maxMembers",8]),_groupID];
    };

    case 3: {
        _owner = _group getVariable ["gang_owner",""];
        if (_owner isEqualTo "") exitWith {};
        _query = format ["UPDATE gangs SET owner='%1' WHERE id='%2'",_owner,_groupID];
    };

    case 4: {
        _members = _group getVariable "gang_members";
        if (count _members > (_group getVariable ["gang_maxMembers",8])) then {
            _membersFinal = [];
            for "_i" from 0 to _maxMembers -1 do {
                _membersFinal pushBack (_members select _i);
            };
        } else {
            _membersFinal = _group getVariable "gang_members";
        };
        _membersFinal = ["DB","ARRAY", _membersFinal] call MPServer_fnc_database_parse;
        _query = format ["UPDATE gangs SET members='%1' WHERE id='%2'",_membersFinal,_groupID];
    };
};

if (!isNil "_query") then {
    [_query,1] call MPServer_fnc_database_rawasync_request;
};
