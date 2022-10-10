#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryRefresh.sqf
*/

disableSerialization;

private _ctrlParent = param [0, displayNull, [displayNull]];
private _showDefaultCtrls = param [1, true, [false]];
private _ctrlIDClist = [77700,77701,77702,77703,77704,77705,77706,77707,77708,77709,77710,77711,77712,77713];
private _ctrlIDCBIlist = [632,640,1240,6321,6401,6554,6307];

//-- Handle our controls
{
    private _idc = _x;
    private _control = (_ctrlParent displayCtrl _idc);
    _ctrlParent setVariable [format ["RscDisplayInventory_Control%1", _idc], _control];
     
    switch _idc do 
    {
        case 77700: 
        {
            private _text = "Wallet";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["View your %1", toLower _text];
            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
            _control ctrlAddEventHandler ["MouseButtonUp", "[_this#0,0] spawn MPClient_fnc_inventoryShowWallet"];
            _control ctrlEnable true;
            _control ctrlShow true;
        };
        case 77701:
        { 
            private _text = "Virtual Items";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["View your %1", toLower _text];
            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
            _control ctrlAddEventHandler ["MouseButtonUp", "[_this#0,0] spawn MPClient_fnc_inventoryShowVirtual"];
            _control ctrlEnable true;
            _control ctrlShow true;
        };
        case 77702: 
        { 
            private _text = "Keys";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["View your %1", toLower _text];
            _control ctrlRemoveAllEventHandlers "MouseButtonUp";
            _control ctrlAddEventHandler ["MouseButtonUp", "_this spawn MPClient_fnc_inventoryShowKeys"];
            _control ctrlEnable true;
            _control ctrlShow true;
        };
        default 
        {
            //-- Clear combo and listbox controls
            if(_idc in [77706,77710,77712])then{
                lbClear _control;
                _control ctrlRemoveAllEventHandlers "LBSelChanged";
            }else{
                _control ctrlRemoveAllEventHandlers "MouseButtonUp";
            };
            
            //-- Disable and hide control
            _control ctrlEnable false;
            _control ctrlShow false;
        };
    };

    _control ctrlCommit 0;
}forEach _ctrlIDClist;

//-- Make sure defualt controls are shown, They get hidden when vitual inventory or wallet is opened
{(_ctrlParent displayCtrl _x) ctrlShow _showDefaultCtrls}forEach _ctrlIDCBIlist;

true