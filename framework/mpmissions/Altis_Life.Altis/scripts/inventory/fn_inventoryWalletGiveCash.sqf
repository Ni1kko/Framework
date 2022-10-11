#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryWalletGiveCash.sqf
*/

disableSerialization;
private _control = param [0, controlNull, [controlNull]];
private _ctrlParent = ctrlParent _control;

//-- Close display of the control that was clicked
if(not(isNull _ctrlParent))then{
	//_ctrlParent closeDisplay 1;
};

hint "Give Cash";

//if (!([_amount] call MPServer_fnc_isNumber)) exitWith {hint localize "STR_NOTF_notNumberFormat";ctrlShow[106,true];};
//hint format [localize "STR_NOTF_youGaveMoney",[(parseNumber(_amount))] call MPClient_fnc_numberText,_unit getVariable ["realname",name _unit]];
//["SUB","CASH",parseNumber _amount] call MPClient_fnc_handleMoney;
//[_unit,_amount,player] remoteExecCall ["MPClient_fnc_receiveMoney",_unit];