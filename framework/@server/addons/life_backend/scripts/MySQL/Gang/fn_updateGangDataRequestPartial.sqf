#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updateGangDataRequestPartial.sqf (Server)
*/

params [
    ["_mode",-1,[0]],
    ["_group",grpNull,[grpNull]]
];

//-- Null groupID
if (isNull _group) exitWith {
	false
};

private _groupID = _group getVariable ["gang_id",-1];
private _members = _group getVariable ["gang_members",[]];
private _maxMembers = _group getVariable ["gang_maxMembers",8];
private _ownerUID = _group getVariable ["gang_owner",""];
private _groupBank = _group getVariable [GET_GANG_MONEY_VAR,0];

if (_groupID isEqualTo -1 OR count(_ownerUID) isNotEqualTo 17) exitWith {
	false
};

private _whereClause = [
	["id",["DB","INT",_groupID] call MPServer_fnc_database_parse]
];

switch _mode do
{
	//-- Update gang data
	case 0: 
	{ 
		["UPDATE", "gangs", [
			[
				["owner",		["DB","STRING", _ownerUID] call MPServer_fnc_database_parse],
				["bank",		["DB","A2NET",  _groupBank] call MPServer_fnc_database_parse],
        		["members",		["DB","ARRAY",	_members] call MPServer_fnc_database_parse],
				["maxmembers",	["DB","INT",	_maxMembers] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;
	}; 

	//-- Update bank
	case 1: 
	{
        private _deposit = param [2,false,[false]];
        private _value = param [3,0,[0]];
		private _unit = param [4,objNull,[objNull]];
		private _cash = param [5,0,[0]];

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
            if (_value > _groupBank) exitWith {
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
        [_group, _whereClause, _sessionvar]spawn{
            params [
                ["_group",grpNull],
                ["_whereClause",[]],
                ["_sessionvar",""]
            ];
            waitUntil {not(missionNamespace getVariable [_sessionvar,false]) OR isNull _group};
            if (isNull _group) exitWith {false};

			["UPDATE", "gangs", [
				[
					["bank", ["DB","A2NET",_groupBank] call MPServer_fnc_database_parse]
				],
				_whereClause
			]]call MPServer_fnc_database_request;

            true
        };
	};

	//-- Update max members
	case 2: 
	{
		["UPDATE", "gangs", [
			[
				["maxmembers",	["DB","INT", _maxMembers] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;
	};

	//-- Update owner
	case 3: 
	{
		["UPDATE", "gangs", [
			[
				["owner",		["DB","STRING", _ownerUID] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;
	};

	//-- Update members
	case 4: 
	{ 
        private _membersTemp = [];
        if (count _members > _maxMembers) then {
            for "_i" from 0 to _maxMembers -1 do {
                _membersTemp pushBack (_members select _i);
            };
			_members = _membersTemp;
		};

		["UPDATE", "gangs", [
			[
        		["members",		["DB","ARRAY",_members] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;
	};

	//-- Delete gang
	case 5: 
	{
		["UPDATE", "gangs", [
			[
        		["active",		["DB","BOOL",false] call MPServer_fnc_database_parse]
			],
			_whereClause
		]]call MPServer_fnc_database_request;

		_group setVariable ["gang_owner",nil,true];
		[_group] remoteExecCall ["MPClient_fnc_gangDisbanded",(units _group)];
		waitUntil {(units _group) isEqualTo []};
		deleteGroup _group;
	};
};

true