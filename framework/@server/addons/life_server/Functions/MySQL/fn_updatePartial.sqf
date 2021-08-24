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
 
private _uid = param [0,"",[""]];
private _side = param [1,sideUnknown,[sideUnknown]];

if (_uid isEqualTo "" || _side isEqualTo sideUnknown) exitWith {}; //Bad.

switch (param [3,-1]) do {
    case 0: {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", param [2,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 1: { 
        ["UPDATE", "players", [
            [//What
                ["bankacc",["DB","A2NET", param [2,0]] call life_fnc_database_parse]	
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 2: {
        ["UPDATE", "players", [
            [//What
                [(switch (_side) do {
                    case west: {"cop_licenses"};
                    case independent: {"med_licenses"]};
                    default {"civ_licenses"};
                }),["DB","BOOL-HASHMAP", param [2,[]]] call life_fnc_database_parse]	
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 3: {
        ["UPDATE", "players", [
            [//What
                [(switch (_side) do {
                    case west: {"cop_gear"};
                    case independent: {"med_gear"]};
                    default {"civ_gear"};
                }),["DB","ARRAY", param [2,[]]] call life_fnc_database_parse]	
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 4: {
        ["UPDATE", "players", [
            [//What
                ["civ_alive",   ["DB","BOOL", param [2,false]] call life_fnc_database_parse],	
                ["civ_position",["DB","POSITION", param [4,[]]] call life_fnc_database_parse]	
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 5: {
        ["UPDATE", "players", [
            [//What
                ["arrested",["DB","BOOL", param [2,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 6: {
        ["UPDATE", "players", [
            [//What
                ["cash",["DB","A2NET", param [2,0]] call life_fnc_database_parse],
                ["bankacc",["DB","A2NET", param [4,0]] call life_fnc_database_parse]
            ],
            [//Where
                ["pid",_uid]
            ]
        ]]call life_fnc_database_request;
    };

    case 7: {
        [_uid,_side,param [2,0],0] call TON_fnc_keyManagement;
    };
};
