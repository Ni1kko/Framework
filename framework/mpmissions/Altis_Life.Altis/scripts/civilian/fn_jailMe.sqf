#include "..\..\clientDefines.hpp"
/*
    File: fn_jailMe.sqf
    Author Bryan "Tonic" Boardwine

    Description:
    Once word is received by the server the rest of the jail execution is completed.
*/

params [
    ["_ret",[],[[]]],
    ["_bad",false,[false]]
];

private _esc = false;
private _bail = false;
private _time = time + (CFG_MASTER(getNumber,"jail_timeMultiplier") * 60);

if (_bad) then {
    _time = _time + 900;
};

if !(_ret isEqualTo []) then {
    life_bail_amount = _ret select 2;
} else {
    life_bail_amount = 1500;
    _time = time + (10 * 60);
};

[_bad] spawn {
    scriptName 'MPClient_fnc_canAffordBail';
    life_var_canAffordBail = false;
    if (_this select 0) then {
        sleep (10 * 60);
    } else {
        sleep (5 * 60);
    };
    life_var_canAffordBail = true;
};

for "_i" from 0 to 1 step 0 do {
    if (round(_time - time) > 0) then {
        _countDown = [(_time - time), "MM:SS.MS"] call BIS_fnc_secondsToString;
        hintSilent parseText format [(localize "STR_Jail_Time") + "<br/> <t size='2'><t color='#FF0000'>%1</t></t><br/><br/>" + (localize "STR_Jail_Pay") + " %3<br/>" + (localize "STR_Jail_Price") + " $%2", _countDown, [life_bail_amount] call MPClient_fnc_numberText, if (life_var_canAffordBail) then {"Yes"} else {"No"}];
    };

    if (CFG_MASTER(getNumber,"jail_forceWalk") isEqualTo 1) then {
        player forceWalk true;
    };

    private _escDist = [[["Altis", 60], ["Tanoa", 145]]] call MPServer_fnc_terrainSort;
    
    if (player distance (getMarkerPos "jail_marker") > _escDist) exitWith {
        _esc = true;
    };

    if (life_var_bailPaid) exitWith {
        _bail = true;
    };

    if (round(_time - time) < 1) exitWith {hint ""};
    if (!alive player && {(round(_time - time)) > 0}) exitWith {};
    sleep 0.1;
};


switch (true) do {
    case (_bail): {
        player setVariable ["arrested",false,true];
        life_var_bailPaid = false;

        hint localize "STR_Jail_Paid";
        player setVariable ["teleported",true,true];
        player setPos (getMarkerPos "jail_release");

        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", extdb_var_database_headless_client];
        } else {
            [getPlayerUID player] remoteExecCall ["MPServer_fnc_wantedRemove", RE_SERVER];
        };

        [5] call MPClient_fnc_updatePlayerDataPartial;
    };

    case (_esc): {
        player setVariable ["arrested",false,true];
        hint localize "STR_Jail_EscapeSelf";
        [0, "STR_Jail_EscapeNOTF", true, [profileName]] remoteExecCall ["MPClient_fnc_broadcast", RE_CLIENT];

        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID player, profileName, "901"] remoteExecCall ["HC_fnc_wantedAdd", extdb_var_database_headless_client];
        } else {
            [getPlayerUID player, profileName, "901"] remoteExecCall ["MPServer_fnc_wantedAdd", RE_SERVER];
        };

        [5] call MPClient_fnc_updatePlayerDataPartial;
    };

    case (alive player && {!_esc} && {!_bail}): {
        player setVariable ["arrested",false,true];
        hint localize "STR_Jail_Released";

        if (count extdb_var_database_headless_clients > 0) then {
            [getPlayerUID player] remoteExecCall ["HC_fnc_wantedRemove", extdb_var_database_headless_client];
        } else {
            [getPlayerUID player] remoteExecCall ["MPServer_fnc_wantedRemove", RE_SERVER];
        };
        player setVariable ["teleported",true,true];
        player setPos (getMarkerPos "jail_release");
        [5] call MPClient_fnc_updatePlayerDataPartial;
    };
};

player forceWalk false; // Enable running & jumping
[]spawn{
    uiSleep 5;
    player setVariable ["teleported",false,true];
};