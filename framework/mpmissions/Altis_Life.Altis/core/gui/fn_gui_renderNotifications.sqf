/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

disableSerialization;

//-- Thrist Notifcation
if(life_var_hud_thirst_lastval != round life_var_thirst)then{
	life_var_hud_thirst_lastval = round life_var_thirst; 
	switch (life_var_hud_thirst_lastval) do {
		case 45: {hint "Throat is really dry getting";};
		case 25: {hint "I should get somthing to drink";};
		case 15: {hint "So thirsty...";};
		case 5: {hint "You gotta drink homie...";};
	};
}; 

//-- Hunger Notifcation 
if(life_var_hud_hunger_lastval != round life_var_hunger)then{
	life_var_hud_hunger_lastval = round life_var_hunger; 
	switch (life_var_hud_hunger_lastval) do {
		case 45: {hint "Was that my belly? maybe i should eat somthing";};
		case 25: {hint "I should get somthing to eat";};
		case 15: {hint "So hungry...";};
		case 5:  {hint "You gotta eat homie...";};
	};
};

//-- Area Notification
private _currentArea = [getPos player] call MPClient_fnc_util_getNearestLocationName;
if(_currentArea != "" AND life_var_hud_lastlocation != _currentArea)then{ 
	life_var_hud_lastlocation = _currentArea;
	[[
		[(toUpper _currentArea), "align='left' size='0.7' font='PuristaSemibold'"],["","<br/>"],
		[([daytime] call BIS_fnc_timeToString), "align='left' size='0.7' font='PuristaMedium'"]
	]] spawn BIS_fnc_typeText2; 
};
 