#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryShowWallet.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _mode = param [1, -1, [0]];
private _ctrlParent = ctrlParent _control;
private _ctrlIDC = ctrlIDC _control;
private _ctrlIDClist = [77700,77701,77702,77703,77704,77705,77706,77707,77708,77709,77710,77711,77712];
private _modes = [
    "Money",
    "Licenses"
];

if(_mode < 0 OR {_mode > count _modes})exitWith{false};

_ctrlIDClist pushBackUnique _ctrlIDC;

//-- 
[_ctrlParent,false] call MPClient_fnc_inventoryRefresh;

//-- Handle our controls
{
    private _idc = _x;
    private _control = (_ctrlParent displayCtrl _idc);
    private _controlVar = format ["RscDisplayInventory_Control%1", _idc];
    private _controlToHide = ([[77705,77707,77713], [77705,77707,77709,77713]] select _mode);
    private _controlShow = not(_idc in _controlToHide);
    
    _ctrlParent setVariable [_controlVar, _control];
    
    _control ctrlShow _controlShow;
    _control ctrlEnable _controlShow;
    
    //-- Button that called this menu make it retun back to last menu  
    if (_idc isEqualTo _ctrlIDC) then {
        _ctrlParent setVariable ["RscDisplayInventory_ReturnControl", _control];
        _control ctrlSetStructuredText parseText "<t align='center'>Inv...</t>";
        _control ctrlSetToolTip "Return to inventory";
        _control ctrlRemoveAllEventHandlers "ButtonClick";
        _control ctrlAddEventHandler ["ButtonClick", "_this spawn MPClient_fnc_inventoryShow"]; 
        ctrlSetFocus _control;  
    }else{
        //-- Menu combo
        if (_idc isEqualTo 77712) then {
            lbClear _control;
            {_control lbAdd _x} forEach _modes;
            _control lbSetCurSel _mode;
            _control ctrlRemoveAllEventHandlers "LBListSelChanged";
            _control ctrlAddEventHandler ["LBListSelChanged", "_this call MPClient_fnc_inventoryWalletComboSelChanged"];
        }else{
            if (_idc isEqualTo 77704) then {
                _control ctrlSetText "Wallet";
            }else{
                switch _mode do 
                {
                    case 0: 
                    {
                        switch _idc do
                        {
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
                                _control ctrlRemoveAllEventHandlers "LBSelChanged";
                                _control ctrlAddEventHandler ["LBSelChanged", "_this call MPClient_fnc_inventoryWalletLBSelChanged"]; 
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
                                    _control lbSetCurSel 0;
                                };
                                _control ctrlRemoveAllEventHandlers "LBListSelChanged";
                                _control ctrlAddEventHandler ["LBListSelChanged", "_this call MPClient_fnc_inventoryWalletPlayersComboSelChanged"];
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
                    };
                    case 1:
                    { 
                        switch _idc do
                        {
                            case 77706: 
                            { 
                                //-- Menu list
                                lbClear _control;
                                {  
                                    private _displayName = LICENSE_DISPLAYNAME(_x);
                                    private _side = LICENSE_SIDE(_x);
                                    private _price = LICENSE_PRICE(_x);
                                    private _icon = LICENSE_ICON(_x);

                                    _control lbAdd _displayname; 
                                    _control lbSetPicture [_forEachIndex,_icon];
                                    _control lbSetValue [_forEachIndex, _price];
                                    _control lbSetData [_forEachIndex, _displayname];
                                    _control lbSetTextRight [_forEachIndex, _side];    
                                    _control lbSetColorRight [_forEachIndex, (switch (toLower _side) do {
                                        case "med": {[0,0.8,0,1]};//Green
                                        case "reb": {[0.8,0,0,1]};//Red
                                        case "cop": {[0,0,0.8,1]};//Blue
                                        case "civ": {[0.62,0.12,0.94,1]};//Purple
                                        default {[0.8,0.8,0.8,1]};//White
                                    })];
                                } forEach ([player,true,true,false,false] call MPClient_fnc_getLicenses);
                            }; 
                            case 77708: 
                            {
                                private _text = "Drop";
                                _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                _control ctrlSetToolTip format["%1 selected license", toLower _text];
                                _control ctrlRemoveAllEventHandlers "ButtonClick";
                                _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryWalletDropLicense"];
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
                                    _control lbSetCurSel 0;
                                };
                                _control ctrlRemoveAllEventHandlers "LBListSelChanged";
                                _control ctrlAddEventHandler ["LBListSelChanged", "_this call MPClient_fnc_inventoryWalletPlayersComboSelChanged"];
                            };
                            case 77711: 
                            {
                                private _text = "Show";
                                _control ctrlSetStructuredText parseText format["<t align='center'>%1</t>",_text];
                                _control ctrlSetToolTip format["%1 selected license to selected person", toLower _text];
                                _control ctrlRemoveAllEventHandlers "ButtonClick";
                                _control ctrlAddEventHandler ["ButtonClick", "_this call MPClient_fnc_inventoryWalletShowLicense"];
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