#include "..\..\clientDefines.hpp"
/*
    File: fn_actionKeyHandler.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Master action key handler, handles requests for picking up various items and
    interacting with other players (Cops = Cop Menu for unrestrain,escort,stop escort, arrest (if near cop hq), etc).
*/
private ["_curObject","_isWater","_CrateModelNames","_crate","_fish","_animal","_whatIsIt","_handle"];
_curObject = cursorObject;
if (life_var_isBusy) exitWith {}; //Action is in use, exit to prevent spamming.
if (life_var_interrupted) exitWith {life_var_interrupted = false;};
_isWater = surfaceIsWater (visiblePositionASL player);

if (playerSide isEqualTo west && {player getVariable ["isEscorting",false]}) exitWith {
    [] call MPClient_fnc_copInteractionMenu;
};

//Check if the player is near an ATM.
if ((call MPClient_fnc_nearATM) && {!dialog}) exitWith {
    [] call MPClient_fnc_atmMenu;
};

if (isNull _curObject) exitWith {
    if (_isWater) then {
        _fish = (nearestObjects[player,(CFG_MASTER(getArray,"animaltypes_fish")),3]) select 0;
        if (!isNil "_fish") then {
            if (!alive _fish) then {
                [_fish] call MPClient_fnc_catchFish;
            };
        };
    } else {
        _animal = (nearestObjects[player,(CFG_MASTER(getArray,"animaltypes_hunting")),3]) select 0;
        if (!isNil "_animal") then {
            if (!alive _animal) then {
                [_animal] call MPClient_fnc_gutAnimal;
            };
        } else {
            private "_handle";
            if (playerSide isEqualTo civilian && !life_var_gatheringResource) then {
          _whatIsIt = [] call MPClient_fnc_whereAmI;
                if (life_var_gatheringResource) exitWith {};                 //Action is in use, exit to prevent spamming.
                switch (_whatIsIt) do {
                    case "mine" : { _handle = [] spawn MPClient_fnc_mine };
                    default { _handle = [] spawn MPClient_fnc_gather };
                };
                life_var_gatheringResource = true;
                waitUntil {scriptDone _handle};
                life_var_gatheringResource = false;
            };
        };
    };
};

if ((_curObject isKindOf "B_supplyCrate_F" || _curObject isKindOf "Box_IND_Grenades_F") && {player distance _curObject < 3} ) exitWith {
    if (alive _curObject) then {
        [_curObject] call MPClient_fnc_containerMenu;
    };
};

private _vaultHouse = [[["Altis", "Land_Research_house_V1_F"], ["Tanoa", "Land_Medevac_house_V1_F"]]] call MPServer_fnc_terrainSort;
private _altisArray = [16019.5,16952.9,0];
private _tanoaArray = [11074.2,11501.5,0.00137329];
private _pos = [[["Altis", _altisArray], ["Tanoa", _tanoaArray]]] call MPServer_fnc_terrainSort;

//-- Houses
if (_curObject isKindOf "House_F" && {player distance _curObject < 12} || ((nearestObject [_pos,"Land_Dome_Big_F"]) isEqualTo _curObject || (nearestObject [_pos,_vaultHouse]) isEqualTo _curObject)) exitWith {
    [_curObject] call MPClient_fnc_houseMenu;
};

//-- Tents
if(_curObject call MPClient_fnc_isTent && {player distance _curObject <= 7}) exitWith { 
    [_curObject] spawn MPClient_fnc_tentMenu;
};

if (dialog) exitWith {}; //Don't bother when a dialog is open.
if !(isNull objectParent player) exitWith {}; //He's in a vehicle, cancel!
life_var_isBusy = true;

//Temp fail safe.
[] spawn {
    scriptName 'MPClient_fnc_busyFailSafe';
    sleep 60;
    life_var_isBusy = false;
};

//Check if it's a dead body.
if (_curObject isKindOf "CAManBase" && {!alive _curObject}) exitWith {
    //Hotfix code by ins0
    if ((playerSide isEqualTo west && {(CFG_MASTER(getNumber,"revive_cops") isEqualTo 1)}) || {(playerSide isEqualTo civilian && {(CFG_MASTER(getNumber,"revive_civ") isEqualTo 1)})} || {(playerSide isEqualTo east && {(CFG_MASTER(getNumber,"revive_east") isEqualTo 1)})} || {playerSide isEqualTo independent}) then {
        if (life_inv_defibrillator > 0) then {
            [_curObject] call MPClient_fnc_revivePlayer;
        };
    };
};

//If target is a player then check if we can use the cop menu.
if (isPlayer _curObject && _curObject isKindOf "CAManBase") then {
    if ((_curObject getVariable ["restrained",false]) && !dialog && playerSide isEqualTo west) then {
        [_curObject] call MPClient_fnc_copInteractionMenu;
    };
} else {
    //OK, it wasn't a player so what is it?
    private ["_isVehicle","_miscItems","_money","_list"];

    _list = ["landVehicle","Ship","Air"];
    _isVehicle = if (KIND_OF_ARRAY(_curObject,_list)) then {true} else {false};
    _miscItems = ["Land_BottlePlastic_V1_F","Land_TacticalBacon_F","Land_Can_V3_F","Land_CanisterFuel_F","Land_Suitcase_F"];

    //It's a vehicle! open the vehicle interaction key!
    if (_isVehicle) then {
        if (!dialog) then {
            if (player distance _curObject < ((boundingBox _curObject select 1) select 0)+2 && (!(player getVariable ["restrained",false])) && (!(player getVariable ["playerSurrender",false])) && !life_var_unconscious && !life_var_tazed) then {
                [_curObject] call MPClient_fnc_vInteractionMenu;
            };
        };
    } else {
        //OK, it wasn't a vehicle so let's see what else it could be?
        if ((typeOf _curObject) in _miscItems) then {
            [_curObject,player,false] remoteExecCall ["MPServer_fnc_pickupAction",RE_SERVER];
        } else {
            //It wasn't a misc item so is it money?
            if ((typeOf _curObject) isEqualTo "Land_Money_F" && {!(_curObject getVariable ["inUse",false])}) then {
                [_curObject,player,true] remoteExecCall ["MPServer_fnc_pickupAction",RE_SERVER];
            };
        };
    };
};
