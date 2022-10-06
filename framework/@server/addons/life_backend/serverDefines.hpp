/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## serverDefines.hpp
*/

//RemoteExec Macros
#define RE_SERVER 2 //Only server
#define RE_CLIENT -2 //Except server
#define RE_GLOBAL 0 //Global

//Display Macros
#define CONTROL(disp,ctrl) ((findDisplay ##disp) displayCtrl ##ctrl)
#define CONTROL_DATA(ctrl) (lbData[##ctrl,(lbCurSel ##ctrl)])
#define CONTROL_DATAI(ctrl,index) ctrl lbData index

//System Macros
#define LICENSE_VARNAME(varName,flag) format ["license_%1_%2",flag,M_CONFIG(getText,"cfgLicenses",varName,"variable")]
#define LICENSE_VALUE(varName,flag) missionNamespace getVariable [LICENSE_VARNAME(varName,flag),false]
#define LICENSE_DISPLAYNAME(varName) localize M_CONFIG(getText,"cfgLicenses",varName,"displayName")
#define ITEM_VARNAME(varName) format ["life_inv_%1",M_CONFIG(getText,"cfgVirtualItems",varName,"variable")]
#define ITEM_VALUE(varName) missionNamespace getVariable [ITEM_VARNAME(varName),0]
#define ITEM_ILLEGAL(varName) M_CONFIG(getNumber,"cfgVirtualItems",ITEM_VARNAME(varName),"illegal")
#define ITEM_SELLPRICE(varName) M_CONFIG(getNumber,"cfgVirtualItems",ITEM_VARNAME(varName),"sellPrice")
#define ITEM_BUYPRICE(varName) M_CONFIG(getNumber,"cfgVirtualItems",ITEM_VARNAME(varName),"buyPrice")
#define ITEM_NAME(varName) M_CONFIG(getText,"cfgVirtualItems",varName,"displayName")
#define ITEM_WEIGHT(varName) M_CONFIG(getNumber,"cfgVirtualItems",varName,"weight")
#define TEXT_LOCALIZE(textStr) if(isLocalized textStr)then{localize textStr}else{textStr}

//Condition Macros
#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitWith { _res = true };} forEach _types;_res}

//Config Macros
#define FETCH_CONFIG(TYPE,CFG,SECTION,CLASS,ENTRY) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY)
#define FETCH_CONFIG2(TYPE,CFG,CLASS,ENTRY) TYPE(configFile >> CFG >> CLASS >> ENTRY)
#define FETCH_CONFIG3(TYPE,CFG,SECTION,CLASS,ENTRY,SUB) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB)
#define FETCH_CONFIG4(TYPE,CFG,SECTION,CLASS,ENTRY,SUB,SUB2) TYPE(configFile >> CFG >> SECTION >> CLASS >> ENTRY >> SUB >> SUB2)
#define M_CONFIG(TYPE,CFG,CLASS,ENTRY) TYPE(missionConfigFile >> CFG >> CLASS >> ENTRY)
#define BASE_CONFIG(CFG,CLASS) inheritsFrom(configFile >> CFG >> CLASS)
#define CFG_MASTER(TYPE,SETTING) TYPE(missionConfigFile >> "cfgMaster" >> SETTING)


//Database Conversion Macros
#define SIDE_TARGET_COP -100
#define SIDE_TARGET_REB -200
#define SIDE_TARGET_MED -300
#define SIDE_TARGET_CIV -400
#define SIDE_TARGET_GLOBAL 0
#define SIDE_TARGET_SERVERS 2
#define SIDE_TARGET_CLIENTS -2

//
#define TYPE_NOT_FOUND "Undefined"

//--
#define INFINTE 1e+011

#define GET_BANK_VAR(target) format["money_bank_%1", getPlayerUID target]
#define GET_DEBT_VAR(target) format["money_debt_%1", getPlayerUID target]
#define GET_CASH_VAR "money_cash"
#define GET_GANG_MONEY_VAR "money_gang"

#define GET_MONEY_CASH(target) target getVariable [GET_CASH_VAR,0]
#define GET_MONEY_DEBT(target) target getVariable [GET_DEBT_VAR(target),0]
#define GET_MONEY_BANK(target) missionNamespace getVariable [GET_BANK_VAR(target),0]
#define GET_MONEY_GANG(target) (group target) getVariable [GET_GANG_MONEY_VAR,0]

#define FORCE_SUSPEND(fnc) if !canSuspend exitWith{_this spawn (missionNamespace getVariable [fnc,{}]); true}
#define RUN_NO_REXEC if(isRemoteExecuted)exitwith{false}
#define RUN_SERVER_ONLY (if (hasInterface OR not(isServer))exitWith{false})
#define RUN_DEDI_SERVER_ONLY (if (hasInterface OR not(isServer) OR not(isDedicated))exitWith{false})
#define RUN_CLIENT_ONLY (if not(hasInterface)exitWith{false})
#define AH_CHECK(var) (if (missionNamespace getVariable [var,false])exitWith{false})
#define AH_CHECK_FINAL(var) (if (isFinal var)exitWith{false})
#define AH_BAN_REMOTE_EXECUTED(var) (if(isRemoteExecuted AND (missionNamespace getVariable ["life_var_rcon_passwordOK",false]))exitwith{[remoteExecutedOwner,format["RemoteExecuted `%1`",var]] call MPServer_fnc_rcon_ban; false})

#define GET_HWID ('BEGuid' callExtension "hwid")
#define GET_BEGUID_S64(var) ('BEGuid' callExtension (["get", var] joinString ":"))
#define GET_BEGUID(obj) GET_BEGUID_S64(getPlayerUID obj)

