#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryShowVirtual.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _selectedPage = param [1, 0, [0]];
private _ctrlParent = ctrlParent _control;
private _ctrlIDC = ctrlIDC _control;
private _ctrlIDClist = _ctrlParent getVariable ["RscDisplayInventory_RscControls", []];
private _pages = ["Player","Ground"];    
private _vehicle = vehicle player;
private _object = ([_vehicle,cursorObject] select {(not(isNull _x) AND _x isNotEqualTo player)}) param [0, objNull];
private _vehicleVirtualItems = _object getVariable ["Trunk",[]];
private _inVehicle = (_vehicle isNotEqualTo player);
private _isKindOfVehicle = true in (["Car","Air","Ship"] apply ({_object isKindOf _x}));
private _isKindOfHouse =  true in (["Box_IND_Grenades_F","B_supplyCrate_F"] apply ({_object isKindOf _x}));
private _inHouse = not(isNull(objectParent player));
private _isKindOfTent = false;  // --- TODO ---
private _inTent = false;        // --- TODO ---
private _isCloseEnough = (player distance2D _object < 7);
private _storageUser = (([_object,player] select {not(isNull _x)}) param [0, objNull]) getVariable ["storageUser",objNull];
private _isNotBeingUsed = (isNull(_storageUser) OR (_storageUser isEqualTo player));

([_object] call MPClient_fnc_vehicleWeight) params [
    ["_objectWeight",0],
    ["_objectMaxWeight",0]
];

//-- check for other inventorys
switch (true) do 
{
    //-- Add vehicle inventory to combo selection
    case (_isKindOfVehicle AND (_inVehicle OR _isCloseEnough)): {_pages pushBackUnique "Vehicle"};
    //-- Add house inventory to combo selection
    case (_isKindOfHouse AND (_inHouse OR _isCloseEnough)): {_pages pushBackUnique "House"};
    //-- Add tent inventory to combo selection
    case (_isKindOfTent AND (_inTent OR _isCloseEnough)): {_pages pushBackUnique "Tent"};
};

if(_selectedPage < 0 OR {_selectedPage > ((count _pages) -1)})exitWith{false};

_ctrlParent setVariable ["RscDisplayInventory_mainPageIndex", _selectedPage];

private _currentPage = _pages param [_selectedPage, ""];

_ctrlIDClist pushBackUnique _ctrlIDC;

//-- 
[_ctrlParent,false] call MPClient_fnc_inventoryRefresh;

//-- Handle our controls
{
    private _idc = _x;
    private _control = (_ctrlParent displayCtrl _idc);
    private _controlVar = format ["RscDisplayInventory_Control%1", _idc];

    _ctrlParent setVariable [_controlVar, _control];
    
    _control ctrlShow true;
    _control ctrlEnable true;
    
    //-- Button that called this menu make it retun back to last menu
    if (_idc isEqualTo _ctrlIDC) then
    { 
        _ctrlParent setVariable ["RscDisplayInventory_ReturnControl", _control];
        _control ctrlSetStructuredText parseText "<t align='center'>Inventory</t>";
        _control ctrlSetToolTip "Return to inventory";
        _control ctrlRemoveAllEventHandlers "MouseButtonUp";
        _control ctrlAddEventHandler ["MouseButtonUp", "_this spawn MPClient_fnc_inventoryShow"]; 
        ctrlSetFocus _control;
    }else{
        if (_idc isEqualTo 77712) then
        { 
            _control ctrlRemoveAllEventHandlers "LBSelChanged";
            lbClear _control;
            {_control lbAdd _x} forEach _pages;
            _control lbSetCurSel _selectedPage;//select page before we add the event handler
            _control ctrlAddEventHandler ["LBSelChanged", "_this call MPClient_fnc_inventoryVirtualComboSelChanged"];
        }else{
            //-- Menu Title
            if (_idc isEqualTo 77704) then
            { 
                _control ctrlSetText "Virtual Inventory";
            }else{
                //-- Amount edit box
                if (_idc isEqualTo 77709) then
                { 
                    _control ctrlSetText "1";
                }else{
                    //-- Near players combo
                    if (_idc isEqualTo 77710) then
                    {
                        lbClear _control;
                        private _nearByPlayers = (playableUnits apply {if (alive _x AND player distance _x < 10 AND _x isNotEqualTo player) then {_x}else{""}}) - [""];
                        if(count _nearByPlayers > 0)then{
                            {
                                _control lbAdd format ["[%2] %1", _x getVariable ["realname",name _x], [side _x,true] call MPServer_fnc_util_getSideString];
                                _control lbSetData [_forEachIndex, str(_x)];
                            } forEach _nearByPlayers;
                        }else{
                            _control lbAdd "No players nearby";
                            _control ctrlEnable false;
                        };
                        _ctrlParent setVariable ["RscDisplayInventory_NearPlayerList", _nearByPlayers];
                        _control lbSetCurSel 0;
                        _control ctrlRemoveAllEventHandlers "LBSelChanged";
                        _control ctrlAddEventHandler ["LBSelChanged", "_this call MPClient_fnc_inventoryVirtualPlayersComboSelChanged"]; 
                    }else{
                        if (_currentPage in ["Vehicle","House","Tent"])then
                        {
                            switch _idc do
                            {
                                case 77705: 
                                { 
                                    _control ctrlSetText format ["Weight: %1 / %2", _objectWeight, _objectMaxWeight];
                                };
                                case 77706:
                                { 
                                    //-- Menu list
                                    _control ctrlRemoveAllEventHandlers "LBSelChanged";
                                    lbClear _control;
                                    if(count [] > 0)then{
                                        { 
                                            private _amountOwned = ITEM_VALUE(_x);
                                            _control lbAdd format ["%1 [x%2]",ITEM_DISPLAYNAME(_x), _amountOwned];
                                            _control lbSetData [_forEachIndex,_x];
                                            _control lbSetValue [_forEachIndex, _amountOwned];
                                            private _icon = ITEM_ICON(_x);
                                            if (count _icon > 0) then {
                                                _control lbSetPicture [_forEachIndex,_icon];
                                            };
                                        } forEach _vehicleVirtualItems;
                                    };
                                    _control ctrlAddEventHandler ["LBSelChanged", "_this call MPClient_fnc_inventoryVirtualLBSelChanged"];
                                    _control lbSetCurSel 0;
                                };
                                case 77707: 
                                { 
                                    private _text = "Use";
                                    _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                    _control ctrlSetToolTip format["%1 selected item", toLower _text];
                                    _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                    _control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualVehicleUseItem"];
                                    _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0 AND _isNotBeingUsed AND _isKindOfVehicle AND (_inVehicle OR _isCloseEnough));
                                    _control ctrlShow true;
                                };
                                case 77708: 
                                {
                                    private _text = "Take";
                                    _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                    _control ctrlSetToolTip format["%1 selected item from vehicle", toLower _text];
                                    _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                    _control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualVehicleTakeItem"];
                                    _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0 AND _isNotBeingUsed AND _isKindOfVehicle AND (_inVehicle OR _isCloseEnough));
                                    _control ctrlShow true;
                                };
                                case 77711: {_control ctrlshow false};
                                case 77713: {_control ctrlshow false};
                            };
                        }else{
                            switch _currentPage do 
                            {
                                case "Player": 
                                { 
                                    switch _idc do
                                    {
                                        case 77705: 
                                        { 
                                            //-- Carry weight
                                            _control ctrlSetText format ["Weight: %1 / %2", life_var_carryWeight, life_var_maxCarryWeight];
                                        };
                                        case 77706: 
                                        { 
                                            //-- Menu list
                                            _control ctrlRemoveAllEventHandlers "LBSelChanged";
                                            lbClear _control;
                                            private _ownedVirtualItemConfigNames = ([player,true,false,true] call MPClient_fnc_getGear)#1;
                                            if(count _ownedVirtualItemConfigNames > 0)then{
                                                { 
                                                    private _amountOwned = ITEM_VALUE(_x);
                                                    _control lbAdd format ["%1 [x%2]",ITEM_DISPLAYNAME(_x), _amountOwned];
                                                    _control lbSetData [_forEachIndex,_x];
                                                    _control lbSetValue [_forEachIndex, _amountOwned];
                                                    private _icon = ITEM_ICON(_x);
                                                    if (count _icon > 0) then {
                                                        _control lbSetPicture [_forEachIndex,_icon];
                                                    };
                                                } forEach _ownedVirtualItemConfigNames;
                                            };
                                            _control ctrlAddEventHandler ["LBSelChanged", "_this call MPClient_fnc_inventoryVirtualLBSelChanged"]; 
                                            _control lbSetCurSel 0;
                                        };
                                        case 77707: 
                                        { 
                                            private _text = "Use";
                                            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                            _control ctrlSetToolTip format["%1 selected item", toLower _text];
                                            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                            _control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualUseItem"];
                                            _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0);
                                        };
                                        case 77708: 
                                        {
                                            private _text = "Drop";
                                            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                            _control ctrlSetToolTip format["%1 selected item", toLower _text];
                                            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                            _control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualDropItem"];
                                            _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0);
                                        };
                                        case 77711: 
                                        {
                                            private _text = "Give";
                                            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                            _control ctrlSetToolTip format["%1 selected item to selected person", toLower _text];
                                            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                            _control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualGiveItem"];
                                            _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0);
                                        };
                                        case 77713: 
                                        {
                                            private _text = "Store";
                                            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                            _control ctrlSetToolTip format["%1 selected item in vehicle", toLower _text];
                                            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                            _control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualMoveItemToVehicle"];
                                            _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0 AND _isKindOfVehicle AND (_inVehicle OR _isCloseEnough));
                                            _control ctrlShow true;
                                        };
                                    };
                                };
                                case "Ground": 
                                {
                                    switch _idc do
                                    {
                                        //-- Weight (droped items / max weight)
                                        case 77705: 
                                        { 
                                            _control ctrlSetText format ["Weight: %1 / %2", 0, 0];
                                        };
                                        //-- Menu list (droped items)
                                        case 77706:
                                        { 
                                            _control ctrlRemoveAllEventHandlers "LBSelChanged";
                                            lbClear _control;
                                            if(count [] > 0)then{
                                                { 
                                                    private _amountOwned = ITEM_VALUE(_x);
                                                    _control lbAdd format ["%1 [x%2]",ITEM_DISPLAYNAME(_x), _amountOwned];
                                                    _control lbSetData [_forEachIndex,_x];
                                                    _control lbSetValue [_forEachIndex, _amountOwned];
                                                    private _icon = ITEM_ICON(_x);
                                                    if (count _icon > 0) then {
                                                        _control lbSetPicture [_forEachIndex,_icon];
                                                    };
                                                } forEach [];
                                            };
                                            _control ctrlAddEventHandler ["LBSelChanged", "_this call MPClient_fnc_inventoryVirtualLBSelChanged"];  
                                            _control lbSetCurSel 0;
                                        };
                                        //-- Use (droped item from ground)
                                        case 77707: 
                                        { 
                                            private _text = "Use";
                                            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                            _control ctrlSetToolTip format["%1 selected item", toLower _text];
                                            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                            //_control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualVehicleUseItem"];
                                            _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0 AND _isNotBeingUsed AND _isKindOfVehicle AND (_inVehicle OR _isCloseEnough));
                                            _control ctrlShow true;
                                        };
                                        //-- Take (droped item from ground)
                                        case 77708: 
                                        {
                                            private _text = "Take";
                                            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                            _control ctrlSetToolTip format["%1 selected item from ground", toLower _text];
                                            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
                                            //_control ctrlAddEventHandler ["MouseButtonUp", "_this call MPClient_fnc_inventoryVirtualVehicleTakeItem"];
                                            _control ctrlEnable (lbSize (_ctrlParent displayCtrl 77706) > 0 AND _isNotBeingUsed AND _isKindOfVehicle AND (_inVehicle OR _isCloseEnough));
                                            _control ctrlShow true;
                                        };
                                        case 77711: {_control ctrlshow false};
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };
    _control ctrlCommit 0;
}forEach _ctrlIDClist;

true