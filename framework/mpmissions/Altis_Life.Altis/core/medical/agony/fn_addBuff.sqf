/*

	Function: 	life_fnc_addBuff
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_type","",[""]],	
	["_section","",[""]],
	["_time",0,[0]]
];
switch (true) do {
	case (life_var_bleeding) : {[] spawn life_fnc_effects_bleeding};
	case (life_var_pain_shock) : {[] spawn life_fnc_effects_painShock};
	case (life_var_critHit) : {[] spawn life_fnc_effects_critHit};
	default { missionNamespace setVariable [_type,true]; _this call life_fnc_addBuff; }; 
};