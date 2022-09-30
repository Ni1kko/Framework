/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updatePartial.sqf (Server)
*/

private _player = param [0,objNull];
private _uid = getPlayerUID _player;
private _BEGuid = call (_player getVariable ["BEGUID",{""}]);
private _side = side _player;
private _sideVar = [_side,true] call MPServer_fnc_util_getSideString;

if (isNull _player  OR _uid isEqualTo "") exitWith {false}; //Bad.
if (_BEGuid isEqualTo "")then{
    _BEGuid = ('BEGuid' callExtension (["get", _uid] joinString ":"));
    _player setVariable ["BEGUID",compileFinal str _BEGuid,true];
};

private _whereClause = [
    ["BEGuid",str _BEGuid]
];

switch (param [1,-1]) do {
    case 0: {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", param [2,0]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 1: { 
        ["UPDATE", "bankaccounts", [
            [//What
                ["funds",["DB","A2NET", param [2,0]] call MPServer_fnc_database_parse],
                ["debt",["DB","A2NET", param [3,0]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 2: {
        ["UPDATE", "players", [
            [//What
                [format["%1_licenses",_sideVar], ["DB","LICENSES", param [2,0]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 3: {
        (param [2,[]]) params [
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

    case 4: {
        ["UPDATE", "players", [
            [//What
                ["alive",   ["DB","BOOL", param [2,false]] call MPServer_fnc_database_parse],	
                ["position",["DB","POSITION", param [3,[]]] call MPServer_fnc_database_parse]	
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 5: {
        ["UPDATE", "players", [
            [//What
                ["arrested",["DB","BOOL", param [2,0]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 6: {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", param [2,0]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;

        ["UPDATE", "bankaccounts", [
            [//What
                ["funds",["DB","A2NET", param [3,0]] call MPServer_fnc_database_parse],
                ["debt",["DB","A2NET", param [4,0]] call MPServer_fnc_database_parse]
            ],
            _whereClause
        ]]call MPServer_fnc_database_request;
    };

    case 7: {
        [_uid,_side,param [2,0]] call MPServer_fnc_keyManagement;
    };
};

true