#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryShowWallet.sqf
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
    private _controlShow = not(_idc in [77705,77707]);
    
    _ctrlParent setVariable [_controlVar, _control];
    
    _control ctrlShow _controlShow;
    _control ctrlEnable _controlShow;
    
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
        case 77704: {_control ctrlSetText "Wallet"};
        case 77706: 
        { 
            //-- Menu list
            lbClear _control; 
            { 
                _x params [
                    "_displayname",
                    "_balance",
                    "_icon"
                ]; 
                _control lbAdd _displayname; 
                _control lbSetPicture [_forEachIndex,_icon];
                _control lbSetValue [_forEachIndex, _balance];
                _control lbSetData [_forEachIndex, _displayname];
                _control lbSetTextRight [_forEachIndex, format ["$%1",[_balance] call MPClient_fnc_numberText]];    
                _control lbSetColorRight [_forEachIndex, (switch (true) do {
                    case (_balance >= 1000000): {[0,0.8,0,1]};//Green
                    case (_balance >= 500000 AND _balance < 1000000): {[1,0.63,0,1]};//Orange
                    default { [0.8,0,0,1]};//Red
                })];
            } forEach [
                ["Bank", MONEY_BANK,"textures\icons\ico_bank.paa"],
                ["Cash", MONEY_CASH, "textures\icons\ico_money.paa"]
            ];
        }; 
        case 77708: 
        {
            private _text = "Drop";
            _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
            _control ctrlSetToolTip format["%1 selected amount of money", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryWalletDropCash"];
        };
        case 77709: {_control ctrlSetText "1"};
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
            _control ctrlSetToolTip format["%1 selected amount of money to selected person", toLower _text];
            _control ctrlRemoveAllEventHandlers "ButtonClick";
            _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryWalletGiveCash"];
        };
    };

    _control ctrlCommit 0;
}forEach _ctrlIDClist;

true