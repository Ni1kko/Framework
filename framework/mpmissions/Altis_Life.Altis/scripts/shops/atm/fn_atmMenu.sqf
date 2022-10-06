#include "..\..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## fn_atmMenu.sqf
*/

disableSerialization;

if (!life_var_ATMEnabled) exitWith {
    hint format [localize "STR_Shop_ATMRobbed",(CFG_MASTER(getNumber,"federalReserve_atmRestrictionTimer"))];
    false
};

private _displayName = "RscDisplayATM";
private _display = createDialog [_displayName,true];

private _controlTitle = GETControl(_displayName, "Title"); 
private _controlPlayers = GETControl(_displayName, "PlayerList"); 
private _controlMoneyInfo = GETControl(_displayName, "MoneyInfo"); 
private _controlGangWithdraw = GETControl(_displayName, "GangWithdraw");
private _controlGangDeposit = GETControl(_displayName, "GangDeposit");
private _controlTransferButton = GETControl(_displayName, "TransferButton");
private _controlWithdrawButton = GETControl(_displayName, "WithdrawButton");
private _controlDepositButton = GETControl(_displayName, "DepositButton");

//-- Purge Player List
lbClear _controlPlayers;


private _moneyStruct = [
    format ["<img size='1.3' image='textures\icons\ico_bank.paa'/> <t size='0.8'>$%1 Bank</t>",MONEY_BANK_FORMATTED],
    "",//debt
    "",//gang
    format ["<img size='1.2' image='textures\icons\ico_money.paa'/> <t size='0.8'>$%1 Cash</t>",MONEY_CASH_FORMATTED]
];

//-- Account state
private _accountState = switch (true) do {
    case (MONEY_DEBT > 0): {"In Debt"};
    case (life_var_bankrupt): {"Bankrupt"};
    default {"Good Standing"};
};

//-- Account State
_controlTitle ctrlSetText format["Account State: %1",_accountState];

//-- Exit here disable all controls and show cash balance only
if ("bankrupt" in tolower _accountState) exitWith {
    _controlMoneyInfo ctrlSetStructuredText parseText (_moneyStruct#3);
    {_x ctrlEnable false}forEach [
        _controlDepositButton,
        _controlWithdrawButton,
        _controlTransferButton,
        _controlGangWithdraw,
        _controlGangDeposit
    ];
};

//-- Handle Debt
if("debt" in tolower _accountState)then{
    _moneyStruct set [1, format ["<img size='1.3' image='textures\icons\ico_bank.paa'/> <t size='0.8'>$%1 Debt</t>",MONEY_DEBT_FORMATTED]];
};

//-- Handle Gangs
if (HAS_GANG) then {
    _moneyStruct set [2, format ["<img size='1.3' image='textures\icons\ico_bank.paa'/> <t size='0.8'>$%1 Gang</t>",MONEY_GANG_FORMATTED]];
}else{
    {_x ctrlEnable false}forEach [_controlGangWithdraw, _controlGangDeposit];
};

//-- Money Struct
_controlMoneyInfo ctrlSetStructuredText parseText ((_moneyStruct - [""]) joinString "<br/>");

//-- Player List
{
    if (ALIVE_OBJECT(_x)) then
    {
        private _sideString = [side _x, true] call MPServer_fnc_util_getSideString;
        private _name = _x getVariable ["realname",name _x];

        _controlPlayers lbAdd format ["%1 (%2)",_name,_sideString];
        _controlPlayers lbSetData [(lbSize _controlPlayers)-1,str(_x)];
    };
} forEach (playableUnits - [player]);

//-- Select first player
_controlPlayers lbSetCurSel 0;

true