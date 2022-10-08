#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryRefresh.sqf
*/

disableSerialization;

private _ctrlParent = param [0, displayNull, [displayNull]];
private _showDefaultCtrls = param [1, true, [false]];
private _ctrlIDClist = [77700,77701,77702,77703,77704,77705,77706,77707,77708,77709,77710,77711];
private _ctrlIDCBIlist = [632,640,1240,6321,6401,6554,6307];

//-- Handle our controls
{
    private _idc = _x;
    private _control = (_ctrlParent displayCtrl _idc);
    private _controlVar = format ["RscDisplayInventory_Control%1", _idc];
    private _controlShow = (_idc in [77700,77701,77702]);

    _ctrlParent setVariable [_controlVar, _control];
    
    //-- Hide every control but buttons to activate menu
    _control ctrlShow _controlShow;
    _control ctrlEnable _controlShow;
    
    switch _idc do 
    {
        case 77700: 
        {
            private _text = "Wallet";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["View your %1", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryShowWallet"];
        };
        case 77701:
        { 
            private _text = "Virtual Items";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["View your %1", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryShowVirtual"];
        };
        case 77702: 
        { 
            private _text = "Keys";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["View your %1", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryShowKeys"];
        };
    };

    _control ctrlCommit 0;
}forEach _ctrlIDClist;

//-- Make sure defualt controls are shown, They get hidden when vitual inventory or wallet is opened
{(_ctrlParent displayCtrl _x) ctrlShow _showDefaultCtrls}forEach _ctrlIDCBIlist;

true