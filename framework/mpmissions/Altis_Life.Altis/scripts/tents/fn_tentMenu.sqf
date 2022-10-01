/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

disableSerialization;

//--- Get target object
private _tent = param [0,objNull,[objNull]];
if (isNull _tent OR {!(_tent call MPClient_fnc_isTent)}) exitWith {false};

//-- Config
private _config = call (missionNamespace getVariable ["life_var_tent_config",{[]}]);
_config params [
	["_oneTimeUse", false],
	["_garages", false]
];

//--- Create UI
private _display = createDialog ["RscDisplayInteractionMenu",true];
private _title = _display displayCtrl 37401;
private _btns = [37450,37451,37452,37453,37454,37455,37456,37457] apply {private _control = _display displayCtrl _x; _control ctrlShow false; _control};
_btns params ["_btn1","_btn2","_btn3","_btn4","_btn5","_btn6","_btn7","_btn8"];
life_pInact_tent = _tent;

//--- BTN 1 (Packup campsite)
_Btn1 ctrlSetText "Packup Campsite";
_Btn1 buttonSetAction "closeDialog 0; [life_pInact_tent] spawn MPClient_fnc_packupTent;";
_Btn1 ctrlShow true;


//--- BTN 2 (Move campsite)
_Btn2 ctrlSetText "Move Campsite";
_Btn2 buttonSetAction "closeDialog 0; hint 'Moving campsite feature has not been created yet.';";
_Btn2 ctrlShow true;

//--- BTN 3 (Toggle campfire)
_Btn3 ctrlSetText "Toggle Campfire";
_Btn3 buttonSetAction "closeDialog 0; hint 'Toggling campfire feature has not been created yet.';";
_Btn3 ctrlShow true;

//--- BTN 4 
//_Btn4 ctrlSetText "";
//_Btn4 buttonSetAction "";
//_Btn4 ctrlShow true;

//--- Enable garage accses
if(_garages) then {
	//--- BTN 5
	_Btn5 ctrlSetText localize "STR_pInAct_AccessGarage";
	_Btn5 buttonSetAction "closeDialog 0; [life_pInact_tent,""Car""] spawn MPClient_fnc_vehicleGarage;";
	_Btn5 ctrlShow true;

	//--- BTN 6
	_Btn6 ctrlSetText localize "STR_pInAct_StoreVeh";
	_Btn6 buttonSetAction "closeDialog 0; [life_pInact_tent,player] spawn MPClient_fnc_storeVehicle;";
	_Btn6 ctrlShow true;
};

//--- Double check who in using menu
if ((_tent getVariable ["BEGuid",""]) isNotEqualTo (call life_BEGuid)) then {
	{_x ctrlEnable false}forEach [_Btn1,_Btn2,_Btn5,_Btn6];
};

true