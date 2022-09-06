/*

	Function: 	MPClient_fnc_addBuff
	Project: 	Misty Peaks RPG
	Author:     Merrick, Nikko, Affect & IceEagle132
	
*/
params [
	["_type","",[""]],	
	["_section","",[""]],
	["_time",0,[0]]
];
switch (true) do {
	case (life_var_bleeding) : {[] spawn MPClient_fnc_effects_bleeding};
	case (life_var_pain_shock) : {[] spawn MPClient_fnc_effects_painShock};
	case (life_var_critHit) : {[] spawn MPClient_fnc_effects_critHit};
	default { missionNamespace setVariable [_type,true]; _this call MPClient_fnc_addBuff; }; 
};