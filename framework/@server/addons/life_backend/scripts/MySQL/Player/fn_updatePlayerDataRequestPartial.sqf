#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updatePlayerDataRequestPartial.sqf (Server)
*/

params [
    ["_packetData",createHashMap, [createHashMap]]
];

private _player = objectFromNetId (_packetData getOrDefault ["NetID", ""]);

//-- Bad player object
if(isNull _player) exitWith {false};

private _uid = getPlayerUID _player;
private _BEGuid = call (_player getVariable ["BEGUID",{""}]);
private _side = side _player;
private _sideVar = [_side,true] call MPServer_fnc_util_getSideString;

if (isNull _player  OR _uid isEqualTo "") exitWith {false}; //Bad.
if (_BEGuid isEqualTo "")then{
    _BEGuid = GET_BEGUID(_player);
    _player setVariable ["BEGUID",compileFinal str _BEGuid,true];
};

private _whereClause = [
    ["BEGuid",str _BEGuid]
];

switch (_packetData getOrDefault ["Mode", 6]) do 
{
    case 0:
    {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", GET_MONEY_CASH(_player)] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 1: 
    { 
        ["UPDATE", "bankaccounts", [
            [//What
                ["funds",["DB","A2NET", GET_MONEY_BANK(_player)] call MPServer_fnc_database_parse],
                ["debt",["DB","A2NET", GET_MONEY_DEBT(_player)] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 2: 
    {
        ["UPDATE", "players", [
            [//What
                [format["%1_licenses",_sideVar], ["DB","LICENSES", _packetData getOrDefault ["Licenses", []]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 3: 
    {
        (_packetData getOrDefault ["Gear", []]) params [
            ["_loadout",[],[[]]],
            ["_vItems",[],[[]]]
        ];
        
        ["UPDATE", "players", [
            [//What
                [format["%1_gear",_sideVar],    ["DB","ARRAY", _loadout] call MPServer_fnc_database_parse],
                ["virtualitems",                ["DB","ARRAY", _vItems] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 4: 
    {
        ["UPDATE", "players", [
            [//What
                ["alive",   ["DB","BOOL", _packetData getOrDefault ["Alive", false]] call MPServer_fnc_database_parse],	
                ["position",["DB","POSITION", getPosATL _player] call MPServer_fnc_database_parse]	
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 5: 
    {
        ["UPDATE", "players", [
            [//What
                ["arrested",["DB","BOOL", _packetData getOrDefault ["Arrested", false]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 6: 
    {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", GET_MONEY_CASH(_player)] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;

        ["UPDATE", "bankaccounts", [
            [//What
                ["funds",["DB","A2NET", GET_MONEY_BANK(_player)] call MPServer_fnc_database_parse],
                ["debt",["DB","A2NET", GET_MONEY_DEBT(_player)] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 7:
    {
        [_uid,_side,(_packetData getOrDefault ["LocalKeys", []]) apply {objectFromNetId _x}] call MPServer_fnc_keyManagement;
    };
};

true