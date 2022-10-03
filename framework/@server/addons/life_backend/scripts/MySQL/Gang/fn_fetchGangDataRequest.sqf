#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_fetchGangDataRequest.sqf (Server)
*/
params [
    ["_steamID","",[""]]
];

private _queryResult = [format ["SELECT id, owner, name, maxmembers, bank, members FROM gangs WHERE active='1' AND members LIKE '%2%1%2'",_steamID,"%"],2] call MPServer_fnc_database_rawasync_request;

if (count _queryResult >= 5) then { 
    while{count(_queryResult#5) >= 1 AND typeName(_queryResult#5) isEqualTo "STRING"}do
    {
        _queryResult set[5, ["GAME","ARRAY", _queryResult#5] call MPServer_fnc_database_parse];
    };
};

missionNamespace setVariable [format ["gang_%1",_steamID],_queryResult];

_queryResult