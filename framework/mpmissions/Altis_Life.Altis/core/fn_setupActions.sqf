/*
    File: fn_setupActions.sqf
    Author:

    Description:
    Master addAction file handler for all client-based actions.
*/

private _lifeConfig = missionConfigFile >> "Life_Settings";
private _spitConfig = _lifeConfig >> "spitting";

private _spitEnabled = [_spitConfig >> "side", str playerSide, false]call BIS_fnc_returnConfigEntry;

life_actions = [];

switch (playerSide) do {

    //Civilian
    case civilian: {
        //Drop fishing net
        life_actions pushBack (player addAction[localize "STR_pAct_DropFishingNet",life_fnc_dropFishingNet,"",0,false,false,"",'
        (surfaceisWater (getPos vehicle player)) && (vehicle player isKindOf "Ship") && life_var_carryWeight < life_maxWeight && speed (vehicle player) < 2 && speed (vehicle player) > -1 && !life_net_dropped ']);

        //Rob person
        life_actions pushBack (player addAction[localize "STR_pAct_RobPerson",life_fnc_robAction,"",0,false,false,"",'
        !isNull cursorObject && player distance cursorObject < 3.5 && isPlayer cursorObject && animationState cursorObject == "Incapacitated" && !(cursorObject getVariable ["robbed",false]) ']);
    };
    
    //Cops
    case west: { };
    
    //EMS
    case independent: { };

};

if(_spitEnabled) then{
    
    private _action = (player addAction[
        "Spit at player",
        life_fnc_spit,
        nil,		// arguments
        1.5,		// priority
        true,		// showWindow
        true,		// hideOnUse
        "",			// shortcut
        "[_target, _this, _originalTarget] call life_fnc_canspit", 	// condition
        3.5,			// radius
        false,		// unconscious
        "",			// selection
	    ""			// memoryPoint
    ]);

    life_actions pushBack _action;
};
