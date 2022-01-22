 /*   
 	File: fn_setLoadingText.sqf
    Author: Fallox
*/
params [
	["_HeaderText","",[""]],
	["_BodyText","",[""]] 
];

disableSerialization; 

_LoadingScreen = "<t size='1.4' color='#04d11f'>" + (_HeaderText) + "</t><br/>";
_LoadingScreen = _LoadingScreen + _BodyText;
 
((uiNamespace getVariable "life_Rsc_DisplayLoading") displayCtrl 100) ctrlSetStructuredText parseText(_LoadingScreen);
true;