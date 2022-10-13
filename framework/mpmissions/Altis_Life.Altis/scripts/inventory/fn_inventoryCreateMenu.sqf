#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryCreateMenu.sqf
*/

disableSerialization;

private _ctrlParent = displayNull;

//-- Setup control group position ofsets
private _controlOffsetX = 0.085;     //-- Larger number will move all buttons right, smaller number will move all buttons left
private _controlOffsetY = 0;         //-- Larger number will move all buttons down, smaller number will move all buttons up
private _controlOffsetW = 1;         //-- Larger number will make all buttons wider, smaller number will make all buttons narrower
private _controlOffsetH = 1;     	 //-- Larger number will make all buttons taller, smaller number will make all buttons shorter
private _controlOffsetGap = 0.004;   //-- Larger number will add more space between buttons, smaller number will add less space between buttons
private _maxNameLength = 20;         //-- Max length of the player name

//-- Wait for display to load
waitUntil{ _ctrlParent = uiNamespace getVariable ["RscDisplayInventory",findDisplay 602]; not(isNull _ctrlParent)};

//-- Get control playersname
private _controlName = (_ctrlParent displayCtrl 111);

//-- Trim name make sure it dont get in way of controls
if(isStreamFriendlyUIEnabled)then{
    _controlName ctrlSetText format["%1 Life",worldName select[0,_maxNameLength]];
}else{
    if(count profileName > _maxNameLength)then{
        _controlName ctrlSetText format["%1...",profileName select[0,_maxNameLength]];
    };
};

//-- Get controls
private _controlGroup = (_ctrlParent displayCtrl 77600);

//-- Create control group
if(isNull _controlGroup)then{
    _controlGroup = _ctrlParent ctrlCreate ["RscDefineControlsGroupNoScrollbars", 77600];
};

//-- Set position of the control group
_controlGroup ctrlSetPosition [-0.070, 0, 1, 1];
_controlGroup ctrlCommit 0;

//-- Update control group var
_ctrlParent setVariable ["RscDisplayInventory_Control77600", _controlGroup];

private _ctrlIDClist = [];

//-- Create controls
{
    private _idc = (INVENTORY_IDC_WALLET + _forEachIndex);
    private _control = (_ctrlParent displayCtrl _idc);
    private _controlVar = format ["RscDisplayInventory_Control%1", _idc];

    if(isNull _control)then{
        _control = _ctrlParent ctrlCreate [_x, _idc, _controlGroup];
    };

    _ctrlParent setVariable [_controlVar, _control];

    //-- Hide every control but buttons to activate menu
    _control ctrlShow false;
    _control ctrlEnable false;
    
    switch _idc do 
    {
        //-- Menu button (Wallet) 
        case INVENTORY_IDC_WALLET:          {_control ctrlSetPosition [0.609,0.04,0.10,0.04]};
        //-- Menu button (Virtual Items) 
        case INVENTORY_IDC_VIRTUALITEMS:    {_control ctrlSetPosition [0.714,0.04,0.15,0.04]};
        //-- Menu button (Keys) 
        case INVENTORY_IDC_KEYS:            {_control ctrlSetPosition [0.869,0.04,0.10,0.04]};
		//-- Menu Header
        case INVENTORY_IDC_BACKGROUND:      {_control ctrlSetPosition [-0.06175, -0.0132, 0.420, 0.05]};
        //-- Menu Title
        case INVENTORY_IDC_TITLE:           {_control ctrlSetPosition [0, -0.005, 0.422, 0.04]};
		//-- Menu SubTitle
        case INVENTORY_IDC_WEIGHT:          {_control ctrlSetPosition [0.225, -0.005, 0.422, 0.04]};
        //-- Menu listbox
        case INVENTORY_IDC_LIST:            {_control ctrlSetPosition [0, 0.085, 0.359, 0.54];lbClear _control};
        //-- Menu button (Use)
        case INVENTORY_IDC_USE:             {_control ctrlSetPosition [0, 0.7, 0.178, 0.04]};
		//-- Menu button (Drop)
        case INVENTORY_IDC_DROP:            {_control ctrlSetPosition [0.182, 0.7, 0.178, 0.04]};
		//-- Amount edit box
        case INVENTORY_IDC_EDIT:            {_control ctrlSetPosition [0, 0.64, 0.359,0.04]};
		//-- Menu combo
        case INVENTORY_IDC_COMBOPLAYERS:    {_control ctrlSetPosition [0, 0.814, 0.361, 0.04];lbClear _control};
        //-- Menu button (Give)
        case INVENTORY_IDC_GIVE:            {_control ctrlSetPosition [0, 0.85, 0.358, 0.04]};
		//-- Menu combo
        case INVENTORY_IDC_COMBOPAGE:       {_control ctrlSetPosition [0, 0.04, 0.361, 0.04];lbClear _control};
		//-- Menu button (Store)
        case INVENTORY_IDC_STORE:           {_control ctrlSetPosition [0, 0.90, 0.358, 0.04]};
    };

    //-- Handle error creating
    if(_ctrlIDClist pushBackUnique _idc isEqualTo -1)then{
        //-- Handle error deleting
        if not(ctrlDelete _control)then{
            _control ctrlShow false;
            _control ctrlEnable false;
            _control ctrlSetPosition [-1,-1,-1,-1];
        };
    };
    
    _control ctrlCommit 0;
}forEach [
    "RscDefineInventoryButton",         //-- INVENTORY_IDC_WALLET
    "RscDefineInventoryButton",         //-- INVENTORY_IDC_VIRTUALITEMS
    "RscDefineInventoryButton",         //-- INVENTORY_IDC_KEYS
    "RscDefineInventoryGUIBack",        //-- INVENTORY_IDC_BACKGROUND
    "RscDefineInventoryText",           //-- INVENTORY_IDC_TITLE
    "RscDefineInventoryText",           //-- INVENTORY_IDC_WEIGHT
    "RscDefineInventoryListBox",        //-- INVENTORY_IDC_LIST
    "RscDefineInventoryButtonMenu",     //-- INVENTORY_IDC_USE
    "RscDefineInventoryButtonMenu",     //-- INVENTORY_IDC_DROP
    "RscDefineInventoryTextEdit",       //-- INVENTORY_IDC_EDIT
    "RscDefineInventoryCombo",          //-- INVENTORY_IDC_COMBOPLAYERS
    "RscDefineInventoryButtonMenu",     //-- INVENTORY_IDC_GIVE
    "RscDefineInventoryCombo",          //-- INVENTORY_IDC_COMBOPAGE
	"RscDefineInventoryButtonMenu"      //-- INVENTORY_IDC_STORE
];

_ctrlParent setVariable ["RscDisplayInventory_RscControls", _ctrlIDClist];
_ctrlParent setVariable ["RscDisplayInventory_DefaultRscControls", [632,640,1240,6321,6401,6554,6307]];

//-- 
[_ctrlParent,true] call MPClient_fnc_inventoryRefresh;

true