/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _lifeConfig = missionConfigFile >> "Life_Settings";
private _spitConfig = _lifeConfig >> "spitting";
private _side = [player] call MPServer_fnc_util_getSideString;

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
        MPClient_fnc_spit,
        nil,		// arguments
        1.5,		// priority
        true,		// showWindow
        true,		// hideOnUse
        "",			// shortcut
        "[_target, _this, _originalTarget, cursorTarget] call MPClient_fnc_canspit", 	// condition
        3.5,			// radius
        false,		// unconscious
        "",			// selection
	    ""			// memoryPoint
    ]);

    life_actions pushBack _action;
};
