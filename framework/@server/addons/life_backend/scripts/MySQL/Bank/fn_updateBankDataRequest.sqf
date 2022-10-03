#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_updateBankDataRequest.sqf (Server)
*/

params [
    ["_player",objNull,[objNull]],
    ["_BEGuid","",[""]]
];

if (isNull _player) exitWith {false};

private _uid = getPlayerUID _player;

if (count _uid isNotEqualTo 17) exitWith {false};
if (count _BEGuid isEqualTo 0) then {
    _BEGuid = 'BEGuid' callExtension (["get", _uid] joinString ":");
};

if (count _BEGuid > 0) exitWith {
    ["UPDATE", "bankaccounts", [
        [
            ["funds",["DB","A2NET", GET_MONEY_BANK(_player)] call MPServer_fnc_database_parse],
            ["debt",["DB","A2NET", GET_MONEY_DEBT(_player)] call MPServer_fnc_database_parse]
        ],
        [
            ["BEGuid",str _BEGuid]
        ]
    ]]call MPServer_fnc_database_request;

    true
};

//--- 
false