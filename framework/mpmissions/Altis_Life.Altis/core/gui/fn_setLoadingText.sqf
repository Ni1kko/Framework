 /*   
 	File: fn_setLoadingText.sqf
    Author: Fallox
*/
params [
	["_HeaderText","",[""]],
	["_BodyText","",[""]],
	["_color",""] 
];

disableSerialization; 

private _colorcode = (switch (_color) do {
	case "red": {"#FF0000"};
	default {"#04d11f"};//green
});

_LoadingScreen = "<t size='1.4' color='"+_colorcode+"'>" + (_HeaderText) + "</t><br/>";
_LoadingScreen = _LoadingScreen + _BodyText;
 
((uiNamespace getVariable "life_Rsc_DisplayLoading") displayCtrl 100) ctrlSetStructuredText parseText(_LoadingScreen);
true;