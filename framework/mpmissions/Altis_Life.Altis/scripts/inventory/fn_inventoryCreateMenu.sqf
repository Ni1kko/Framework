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
private _controlOffsetH = 0.078;     //-- Larger number will make all buttons taller, smaller number will make all buttons shorter
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
_controlGroup ctrlSetPosition [-0.070, _controlOffsetY, _controlOffsetW, _controlOffsetH];
_controlGroup ctrlCommit 0;

//-- Update control group var
_ctrlParent setVariable ["RscDisplayInventory_Control77600", _controlGroup];

//-- Update ofsets for buttons
_controlOffsetX = (_controlOffsetX + 0.235);
_controlOffsetY = (_controlOffsetY + 0.04);
_controlOffsetW = (_controlOffsetW + -0.83);
_controlOffsetH = (_controlOffsetH + -0.012);
_controlOffsetGap = (_controlOffsetGap + 0.170);

//-- Create controls
{
    private _idc = (77700 + _forEachIndex);
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
        case 77700: 
        {
            //-- Menu button (Wallet)
            _controlOffsetX = (_controlOffsetX + _controlOffsetGap);
            _control ctrlSetPosition [_controlOffsetX, _controlOffsetY, _controlOffsetW, _controlOffsetH];
        };
        case 77701:
        { 
            //-- Menu button (Virtual Items)
            _controlOffsetX = (_controlOffsetX + _controlOffsetGap);
            _control ctrlSetPosition [_controlOffsetX, _controlOffsetY, _controlOffsetW, _controlOffsetH];
        };
        case 77702: 
        { 
            //-- Menu button (Keys)
            _controlOffsetX = (_controlOffsetX + _controlOffsetGap);
            _control ctrlSetPosition [_controlOffsetX, _controlOffsetY, (_controlOffsetW - 0.06), _controlOffsetH];
        };
		//-- Menu Header
        case 77703: {_control ctrlSetPosition [-0.06175, -0.0132, 0.420, 0.05]};
        //-- Menu Title
        case 77704: {_control ctrlSetPosition [0,-0.005, 0.422, 0.04]};
		//-- Menu SubTitle
        case 77705: {_control ctrlSetPosition [0.225, -0.005, 0.422, 0.04]};
        //-- Menu listbox
        case 77706: {_control ctrlSetPosition [-0.04425, 0.0808, 0.3125, 0.54];lbClear _control};
        //-- Menu button (Use)
        case 77707: {_control ctrlSetPosition [-0.0375, 0.7, 0.125, 0.04]};
		//-- Menu button (Drop)
        case 77708: {_control ctrlSetPosition [0.1375, 0.7, 0.125, 0.04]};
		//-- Amount edit box
        case 77709: {_control ctrlSetPosition [-0.0125, 0.64, 0.2625, 0.04]};
		//-- Menu combo
        case 77710: {_control ctrlSetPosition [-0.03175, 0.804, 0.2875, 0.04];lbClear _control};
        //-- Menu button (Give)
        case 77711: {_control ctrlSetPosition [0.1375, 0.7, 0.125, 0.04]};
    };

    _control ctrlCommit 0;
}forEach [
    "RscDefineInventoryButton",         //-- 77700
    "RscDefineInventoryButton",         //-- 77701
    "RscDefineInventoryButton",         //-- 77702
    "RscDefineInventoryGUIBack",        //-- 77703
    "RscDefineInventoryText",           //-- 77704
    "RscDefineInventoryText",           //-- 77705
    "RscDefineInventoryListBox",        //-- 77706
    "RscDefineInventoryButtonMenu",     //-- 77707
    "RscDefineInventoryButtonMenu",     //-- 77708
    "RscDefineInventoryTextEdit",       //-- 77709
    "RscDefineInventoryCombo",          //-- 77710
    "RscDefineInventoryButtonMenu"      //-- 77711
];

//-- 
[_ctrlParent,true] call MPClient_fnc_inventoryRefresh;

true