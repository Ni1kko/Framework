#include "..\..\clientDefines.hpp"
/*
    File: fn_houseMenu.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Building interaction menu
*/
#define Btn1 37450
#define Btn2 37451
#define Btn3 37452
#define Btn4 37453
#define Btn5 37454
#define Btn6 37455
#define Btn7 37456
#define Btn8 37457
#define Title 37401

private ["_display","_curTarget","_Btn1","_Btn2","_Btn3","_Btn4","_Btn5","_Btn6","_Btn7","_Btn8"];
disableSerialization;
_curTarget = param [0,objNull,[objNull]];
if (isNull _curTarget) exitWith {}; //Bad target
_houseCfg = [(typeOf _curTarget)] call MPClient_fnc_houseConfig;
if (count _houseCfg isEqualTo 0 && playerSide isEqualTo civilian) exitWith {};

if (!dialog) then {
    createDialog "RscDisplayInteractionMenu";
};

_Btn1 = CONTROL(37400,Btn1);
_Btn2 = CONTROL(37400,Btn2);
_Btn3 = CONTROL(37400,Btn3);
_Btn4 = CONTROL(37400,Btn4);
_Btn5 = CONTROL(37400,Btn5);
_Btn6 = CONTROL(37400,Btn6);
_Btn7 = CONTROL(37400,Btn7);
_Btn8 = CONTROL(37400,Btn8);
{_x ctrlShow false;} forEach [_Btn1,_Btn2,_Btn3,_Btn4,_Btn5,_Btn6,_Btn7,_Btn8];

life_pInact_curTarget = _curTarget;

if (_curTarget in life_var_gangHideoutBuildings) exitWith {
    closeDialog 0;
    hint localize "STR_House_Hideout";
};

if (_curTarget isKindOf "House_F" && playerSide isEqualTo west) exitWith {

    private _vaultHouse = [[["Altis", "Land_Research_house_V1_F"], ["Tanoa", "Land_Medevac_house_V1_F"]]] call MPServer_fnc_terrainSort;
    private _altisArray = [16019.5,16952.9,0];
    private _tanoaArray = [11074.2,11501.5,0.00137329];
    private _pos = [[["Altis", _altisArray], ["Tanoa", _tanoaArray]]] call MPServer_fnc_terrainSort;

    if ((nearestObject [_pos,"Land_Dome_Big_F"]) isEqualTo _curTarget || (nearestObject [_pos,_vaultHouse]) isEqualTo _curTarget) then {

        _Btn1 ctrlSetText localize "STR_pInAct_Repair";
        _Btn1 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPClient_fnc_repairDoor;";
        _Btn1 ctrlShow true;

        _Btn2 ctrlSetText localize "STR_pInAct_CloseOpen";
        _Btn2 buttonSetAction "closeDialog 0; [life_pInact_curTarget] call MPClient_fnc_doorAnimate;";
        _Btn2 ctrlShow true;

    } else {
        if (!isNil {_curTarget getVariable "house_owner"}) then {
            _Btn1 ctrlSetText localize "STR_House_Raid_Owner";
            _Btn1 buttonSetAction "[life_pInact_curTarget] call MPClient_fnc_copHouseOwner;";
            _Btn1 ctrlShow true;

            _Btn2 ctrlSetText localize "STR_pInAct_BreakDown";
            _Btn2 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPClient_fnc_copBreakDoor;";
            _Btn2 ctrlShow true;

            _Btn3 ctrlSetText localize "STR_pInAct_SearchHouse";
            _Btn3 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPClient_fnc_raidHouse;";
            _Btn3 ctrlShow true;

            if (player distance _curTarget > 3.6) then {
                _Btn3 ctrlEnable false;
            };

            _Btn4 ctrlSetText localize "STR_pInAct_LockHouse";
            _Btn4 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPClient_fnc_lockupHouse;";
            _Btn4 ctrlShow true;
        } else {
            closeDialog 0;
        };
    };
};

if (!(_curTarget in life_var_vehicles) || isNil {_curTarget getVariable "house_owner"}) then {
    private _isHouse = (isClass (missionConfigFile >> "cfgHouses" >> worldName >> typeOf _curTarget));
    private _buildingPurchaseString = [
        "STR_pInAct_BuyGarage",
        "STR_pInAct_BuyHouse"
    ] select _isHouse;
    
    _Btn1 ctrlSetText localize _buildingPurchaseString;
    _Btn1 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPClient_fnc_buyHouse;";
    _Btn1 ctrlShow true;

    if (!isNil {_curTarget getVariable "house_owner"}) then {
        _Btn1 ctrlEnable false;
    };

    if (_isHouse) then {
        if (getNumber (missionConfigFile >> "cfgHouses" >> worldName >> (typeOf _curTarget) >> "canGarage") isEqualTo 1) then {
            _Btn2 ctrlSetText localize "STR_pInAct_GarageExt";
            _Btn2 buttonSetAction 'hint format [localize "STR_pInAct_GarageExtNOTF",[CFG_MASTER(getNumber,"houseGarage_buyPrice")] call MPClient_fnc_numberText];';
            _Btn2 ctrlShow true;
        };
    };

} else {
    if (isClass (missionConfigFile >> "cfgGarages" >> worldName >> (typeOf _curTarget))) then {
        _Btn1 ctrlSetText localize "STR_pInAct_SellGarage";
        _Btn1 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPServer_fnc_sellHouse;";
        _Btn1 ctrlShow true;

        if !(((_curTarget getVariable "house_owner") select 0) isEqualTo getPlayerUID player) then {
            _Btn1 ctrlEnable false;
        };

        _Btn2 ctrlSetText localize "STR_pInAct_AccessGarage";
        _Btn2 buttonSetAction "closeDialog 0; [life_pInact_curTarget,""Car""] spawn MPClient_fnc_vehicleGarage;";
        _Btn2 ctrlShow true;

        _Btn3 ctrlSetText localize "STR_pInAct_StoreVeh";
        _Btn3 buttonSetAction "closeDialog 0; [life_pInact_curTarget,player] spawn MPClient_fnc_storeVehicle;";
        _Btn3 ctrlShow true;
    } else {
        _Btn1 ctrlSetText localize "STR_pInAct_SellHouse";
        _Btn1 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPServer_fnc_sellHouse;";
        _Btn1 ctrlShow true;

        if (((_curTarget getVariable "house_owner") select 0) != (getPlayerUID player)) then {
            _Btn1 ctrlEnable false;
        };

        if (_curTarget getVariable ["locked",false]) then {
            _Btn2 ctrlSetText localize "STR_pInAct_UnlockStorage";
        } else {
            _Btn2 ctrlSetText localize "STR_pInAct_LockStorage";
        };
        _Btn2 buttonSetAction "closeDialog 0; [life_pInact_curTarget] call MPClient_fnc_lockHouse;";
        _Btn2 ctrlShow true;

        if (isNull (_curTarget getVariable ["lightSource",objNull])) then {
            _Btn3 ctrlSetText localize "STR_pInAct_LightsOn";
        } else {
            _Btn3 ctrlSetText localize "STR_pInAct_LightsOff";
        };
        _Btn3 buttonSetAction "closeDialog 0; [life_pInact_curTarget] call MPClient_fnc_lightHouseAction;";
        _Btn3 ctrlShow true;

        if (getNumber (missionConfigFile >> "cfgHouses" >> worldName >> (typeOf _curTarget) >> "canGarage") isEqualTo 1 && {!(_curTarget getVariable ["blacklistedGarage",false])}) then {
            if (_curTarget getVariable ["garageBought",false]) then {
                _Btn4 ctrlSetText localize "STR_pInAct_SellGarage";
                _Btn4 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPServer_fnc_sellHouseGarage;";
                _Btn4 ctrlShow true;

                if (((_curTarget getVariable "house_owner") select 0) != (getPlayerUID player)) then {
                    _Btn4 ctrlEnable false;
                };

                _Btn5 ctrlSetText localize "STR_pInAct_AccessGarage";
                _Btn5 buttonSetAction "closeDialog 0; [life_pInact_curTarget,""Car""] spawn MPClient_fnc_vehicleGarage;";
                _Btn5 ctrlShow true;

                _Btn6 ctrlSetText localize "STR_pInAct_StoreVeh";
                _Btn6 buttonSetAction "closeDialog 0; [life_pInact_curTarget,player] spawn MPClient_fnc_storeVehicle;";
                _Btn6 ctrlShow true;
            } else {
                _Btn5 ctrlSetText localize "STR_pInAct_BuyGarage";
                _Btn5 buttonSetAction "closeDialog 0; [life_pInact_curTarget] spawn MPClient_fnc_buyHouseGarage;";
            };

            _Btn5 ctrlShow true;

        };

    };
};
