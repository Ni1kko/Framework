/*
    File: fn_setupActions.sqf
    Author:

    Description:
    Master addAction file handler for all client-based actions.
*/

private _lifeConfig = missionConfigFile >> "Life_Settings";
private _spitConfig = _lifeConfig >> "spitting";
private _side = player call life_fnc_getPlayerSide;

life_actions = [];

switch (call compile _side) do 
{
    //--- CIVILIAN
    case civilian: { };

    //--- POLICE
    case west: { };

    //--- UNDEFINED
    case east: { };
    
    //--- MEDIC
    case independent: { };
};

private _spitEnabled = false;//([_spitConfig >> "side", _side, false] call BIS_fnc_returnConfigEntry) isEqualTo 1;

if(_spitEnabled) then{
    
    private _action = (player addAction[
        "Spit at player",
        life_fnc_spit,
        nil,		// arguments
        1.5,		// priority
        true,		// showWindow
        true,		// hideOnUse
        "",			// shortcut
        "[_target, _this, _originalTarget, cursorTarget] call life_fnc_canspit", 	// condition
        3.5,			// radius
        false,		// unconscious
        "",			// selection
	    ""			// memoryPoint
    ]);

    life_actions pushBack _action;
};
