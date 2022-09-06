/*
    File: fn_updatePartial.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Takes partial data of a player and updates it, this is meant to be
    less network intensive towards data flowing through it for updates.
    
    Edits by:
    ## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _player = param [0,objNull];
private _uid = getPlayerUID _player;
private _BEGuid = call (_player getVariable ["BEGUID",{""}]);
private _side = side _player;

if (isNull _player  OR _uid isEqualTo "") exitWith {}; //Bad.
if (_BEGuid isEqualTo "")then{
    _BEGuid = ('BEGuid' callExtension ("get:"+_uid));
    _player setVariable ["BEGUID",compileFinal str _BEGuid,true];
};

switch (param [1,-1]) do {
    case 0: {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", param [2,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 1: { 
        ["UPDATE", "bankaccounts", [
            [//What
                ["funds",["DB","A2NET", param [2,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 2: {
        ["UPDATE", "players", [
            [//What
                [(switch (_side) do {
                    case west: {"cop_licenses"};
                    case independent: {"med_licenses"};
                    default {"civ_licenses"};
                }),["DB","ARRAY", ((param [2,0]) apply{[_x#0,["DB","BOOL", _x#1] call life_fnc_database_parse]})] call life_fnc_database_parse]	
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 3: {
        ["UPDATE", "players", [
            [//What
                [(switch (_side) do {
                    case west: {"cop_gear"};
                    case independent: {"med_gear"};
                    default {"civ_gear"};
                }),["DB","ARRAY", param [2,[]]] call life_fnc_database_parse]	
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 4: {
        ["UPDATE", "players", [
            [//What
                ["alive",   ["DB","BOOL", param [2,false]] call life_fnc_database_parse],	
                ["position",["DB","POSITION", param [3,[]]] call life_fnc_database_parse]	
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 5: {
        ["UPDATE", "players", [
            [//What
                ["arrested",["DB","BOOL", param [2,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 6: {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", param [2,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
        ["UPDATE", "bankaccounts", [
            [//What
                ["funds",["DB","A2NET", param [3,0]] call life_fnc_database_parse]
            ],
            [//Where
            ["BEGuid",str _BEGuid]
            ]
        ]]call life_fnc_database_request;
    };

    case 7: {
        [_uid,_side,param [2,0],0] call life_fnc_keyManagement;
    };
};