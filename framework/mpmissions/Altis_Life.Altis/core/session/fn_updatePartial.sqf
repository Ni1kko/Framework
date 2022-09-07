#include "..\..\script_macros.hpp"
/*
    File: fn_updatePartial.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Sends specific information to the server to update on the player,
    meant to keep the network traffic down with large sums of data flowing
    through remoteExec
*/

private _mode = param [0,-1];
private _flag = [playerSide,true] call MPServer_fnc_util_getSideString;
private _packet = [player,_mode];

switch (_mode) do {
    case 0: {
        _packet set[2,life_var_cash];
    };

    case 1: {
        _packet set[2,life_var_bank];
    };

    case 2: {
        private _array = [];

        {
            _varName = LICENSE_VARNAME(configName _x,_flag);
            _array pushBack [_varName,LICENSE_VALUE(configName _x,_flag)];
        } forEach (format ["getText(_x >> 'side') isEqualTo '%1'",_flag] configClasses (missionConfigFile >> "Licenses"));

        _packet set[2,_array];
    };

    case 3: {
        [] call MPClient_fnc_saveGear;
        _packet set[2,life_var_loadout];
    };

    case 4: {
        _packet set[2,life_is_alive];
        _packet set[3,getPosATL player];
    };

    case 5: {
        _packet set[2,life_is_arrested];
    };

    case 6: {
        _packet set[2,life_var_cash];
        _packet set[3,life_var_bank];
    };

    case 7: {
        // Tonic is using for keychain..?
    };
};

_packet remoteExecCall ["MPServer_fnc_updatePartial",RSERV];