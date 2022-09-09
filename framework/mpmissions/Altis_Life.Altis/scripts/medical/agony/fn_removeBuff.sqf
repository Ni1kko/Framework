/*

	Function: 	MPClient_fnc_removeBuff
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
private _type = param [0,"",[""]];
    if (_type == "") exitWith {};

    switch (_type) do {
        case "debuffs": {
            life_var_bleeding = false;
            life_var_pain_shock = false;
            life_var_critHit = false;
        }; 
        case "buffs": {};
        case "all": {
            life_var_bleeding = false;
            life_var_pain_shock = false;
            life_var_critHit = false;
        };
        case "revived": {
            life_var_bleeding = false;
            life_var_critHit = false;
        };
        default {
           missionNamespace setVariable [_type,false];
        };
    };