#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_setLoadingText.sqf
*/

params [
	["_HeaderText","",[""]],
	["_BodyText","",[""]],
	["_color","green"],
	["_bodycolor",""] 
];

disableSerialization; 

private _display = uiNamespace getVariable ["life_Rsc_DisplayLoading", displayNull];

private _getcolorcode = {
	switch (param [0,""]) do 
	{
		case "red": {"#FF0000"};
		case "green": {"#04d11f"};
		case "blue": {"#0000FF"};
		case "yellow": {"#FFFF00"};
		case "orange": {"#FFA500"};
		case "purple": {"#800080"};
		case "black": {"#000000"};
		case "white";
		default {"#FFFFFF"};
	};
};

private _structuredText = [
	["<t", "size='1.4'", format["color='%1'", _color call _getcolorcode], ">", _HeaderText, "</t>"] joinString " ",
	[
		_BodyText,
		["<t", format["color='%1'", _bodycolor call _getcolorcode], ">", _HeaderText, "</t>"] joinString " "
	]select (count _bodycolor > 0)
	
] joinString "<br/>";

if(isNull _display OR not(life_var_loadingScreenActive))then
{
	FORCE_SUSPEND("MPClient_fnc_setLoadingText");
	startLoadingScreen ["","Life_Rsc_DisplayLoading"];
	waitUntil{life_var_loadingScreenActive AND {call BIS_fnc_isLoading}};
	(_display displayCtrl 100) ctrlSetStructuredText parseText(_structuredText);
}else{
	(_display displayCtrl 100) ctrlSetStructuredText parseText(_structuredText);
};

true;