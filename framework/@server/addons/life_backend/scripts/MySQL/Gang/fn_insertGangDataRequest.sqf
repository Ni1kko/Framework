#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_insertGangDataRequest.sqf (Server)
*/

params [
    ["_player",objNull,[objNull]],
    ["_gangName","",[""]]
];

if (isNull _player) exitWith {false};

private _group = group _player;
private _steamID = getPlayerUID _player;

if (isNull _group || _steamID isEqualTo "" || _gangName isEqualTo "") exitWith {}; //Fail
 
_gangName = ["DB","STRING", _gangName] call MPServer_fnc_database_parse;
_queryResult = [format ["SELECT id FROM gangs WHERE name='%1' AND active='1'",_gangName],2] call MPServer_fnc_database_rawasync_request;

//Check to see if the gang name already exists.
if (!(count _queryResult isEqualTo 0)) exitWith {
    [1,"There is already a gang created with that name please pick another name."] remoteExecCall ["MPClient_fnc_broadcast",remoteExecutedOwner];
    life_action_gangInUse = nil;
    remoteExecutedOwner publicVariableClient "life_action_gangInUse";
};

_queryResult = [format ["SELECT id FROM gangs WHERE members LIKE '%2%1%2' AND active='1'",_steamID,"%"],2] call MPServer_fnc_database_rawasync_request;

//Check to see if this person already owns or belongs to a gang.
if (!(count _queryResult isEqualTo 0)) exitWith {
    [1,"You are currently already active in a gang, please leave the gang first."] remoteExecCall ["MPClient_fnc_broadcast",remoteExecutedOwner];
    life_action_gangInUse = nil;
    remoteExecutedOwner publicVariableClient "life_action_gangInUse";
};

//Check to see if a gang with that name already exists but is inactive.
_queryResult = [format ["SELECT id, active FROM gangs WHERE name='%1' AND active='0'",_gangName],2] call MPServer_fnc_database_rawasync_request;
_gangMembers = ["DB","ARRAY", [_steamID]] call MPServer_fnc_database_parse;

if (!(count _queryResult isEqualTo 0)) then {
    [format ["UPDATE gangs SET active='1', owner='%1',members='%2' WHERE id='%3'",_steamID,_gangMembers,(_queryResult select 0)],1] call MPServer_fnc_database_rawasync_request;
} else {
    [format ["INSERT INTO gangs (owner, name, members) VALUES('%1','%2','%3')",_steamID,_gangName,_gangMembers],1] call MPServer_fnc_database_rawasync_request;
};

_group setVariable ["gang_name",_gangName,true];
_group setVariable ["gang_owner",_steamID,true];
_group setVariable [GET_GANG_MONEY_VAR,0,true];
_group setVariable ["gang_maxMembers",8,true];
_group setVariable ["gang_members",[_steamID],true];
[_group] remoteExecCall ["MPClient_fnc_gangCreated",remoteExecutedOwner];

uiSleep 0.35;

_queryResult = [format ["SELECT id FROM gangs WHERE owner='%1' AND active='1'",_steamID],2] call MPServer_fnc_database_rawasync_request;

_group setVariable ["gang_id",(_queryResult select 0),true];

true