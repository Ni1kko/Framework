#include "..\..\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_setLoadingText.sqf
*/
disableSerialization; 

private _display = uiNamespace getVariable ["RscDisplayLoadingScreen", displayNull];
private _controlText = _display displayCtrl 100;

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

private _HeaderString = ["<t", "size='1.4'", format["color='%1'", [param[2, "green",[""]]] call _getcolorcode], ">", (param[0, "",[""]]) call BIS_fnc_localize, "</t>"] joinString " ";
private _BodyString = ["<t", format["color='%1'", [param[3, "white",[""]]] call _getcolorcode], ">", (param[1, "",[""]]) call BIS_fnc_localize, "</t>"] joinString " ";
private _structuredText = parseText([_HeaderString,_BodyString] joinString "<br/>");

if(isNull _display OR not(life_var_loadingScreenActive))then
{
	FORCE_SUSPEND("MPClient_fnc_setLoadingText");
	startLoadingScreen ["","RscDisplayLoadingScreen"];
	waitUntil{life_var_loadingScreenActive};
	_controlText ctrlSetStructuredText _structuredText;
}else{
	_controlText ctrlSetStructuredText _structuredText;
};

true;