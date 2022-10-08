#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryShowVirtual.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;
private _ctrlIDC = ctrlIDC _control;
private _ctrlIDClist = [77700,77701,77702,77703,77704,77705,77706,77707,77708,77709,77710,77711];

_ctrlIDClist pushBackUnique _ctrlIDC;

//-- 
[_ctrlParent,false] call MPClient_fnc_inventoryRefresh;

//-- Make sure defualt controls are hidden, They get shown when inventory is reloaded
{(_ctrlParent displayCtrl _x) ctrlShow false}forEach [632,640,1240,6321,6401,6554,6307];

//-- Handle our controls
{
    private _idc = _x;
    private _control = (_ctrlParent displayCtrl _idc);
    private _controlVar = format ["RscDisplayInventory_Control%1", _idc];

    _ctrlParent setVariable [_controlVar, _control];
    
    _control ctrlShow true;
    _control ctrlEnable true;
    
    switch _idc do
    { 
        //-- Button that called this menu make it retun back to last menu
        case _ctrlIDC:
        { 
            _control ctrlSetStructuredText parseText "<t align='center'>Inventory</t>";
            _control ctrlSetToolTip "Return to inventory";
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this spawn MPClient_fnc_inventoryShow"]; 
        };
        case 77704: 
        { 
            //-- Menu Title
            _control ctrlSetText "Virtual Inventory";
        };
        case 77705: 
        { 
            //-- Carry weight
            _control ctrlSetText format ["Weight: %1 / %2", life_var_carryWeight, life_var_maxCarryWeight];
        };
        case 77706: 
        { 
            //-- Menu list
            lbClear _control;
            if(vehicle player isNotEqualTo player)then{
                //TODO: open vitrual trunk
            }else{
                //
                private _ownedVirtualItemConfigNames = ([player,true,false,true] call MPClient_fnc_getGear)#1;
                if(count _ownedVirtualItemConfigNames > 0)then{
                    { 
                        _control lbAdd format ["%1 [x%2]",ITEM_DISPLAYNAME(_x), ITEM_VALUE(_x)];
                        _control lbSetData [_forEachIndex,_x];
                        private _icon = ITEM_ICON(_x);
                        if (count _icon > 0) then {
                            _control lbSetPicture [_forEachIndex,_icon];
                        };
                    } forEach _ownedVirtualItemConfigNames;
                };
            };
            
        };
        case 77707: 
        { 
            private _text = "Use";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["%1 your item", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryVirtualUseItem"];
        };
        case 77708: 
        {
            private _text = "Drop";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["%1 your item", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryVirtualDropItem"];
        };
        case 77709: 
        {
            //-- Amount edit box
            _control ctrlSetText "1";
        };
        
        case 77710: 
        { 
            //-- Menu combo
            lbClear _control;
            private _nearByPlayers = (playableUnits apply {if (alive _x AND player distance _x < 10 AND _x isNotEqualTo player) then {_x}else{""}}) - [""];
            if(count _nearByPlayers > 0)then{
                {
                    _control lbAdd format ["[%2] %1", _x getVariable ["realname",name _x], [side _x,true] call MPServer_fnc_util_getSideString];
                    _control lbSetData [_forEachIndex, str(_x)];
                } forEach _nearByPlayers;
            };
        };
        case 77711: 
        {
            private _text = "Give";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["%1 selected item to selected person", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryVirtualGiveItem"];
        };
    };

    _control ctrlCommit 0;
}forEach _ctrlIDClist;

true