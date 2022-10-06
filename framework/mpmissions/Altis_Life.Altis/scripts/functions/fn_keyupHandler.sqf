/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

#include "..\..\script_macros.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"

disableSerialization;

private _caller = _this select 0;
private _keyCode = _this select 1;
private _shiftState = _this select 2;
private _controlState = _this select 3;
private _altState = _this select 4;
private _stopPropagation = false;

// -- Disable commander/tactical view
if (CFG_MASTER(getNumber,"disableCommanderView") isEqualTo 1) then { 
	if (_keyCode in actionKeys "tacticalView") then {
		hint localize "STR_NOTF_CommanderView";
		_stopPropagation = true;
	};
};

//Vault handling...
if ((_keyCode in (actionKeys "GetOver") || _keyCode in (actionKeys "salute") || _keyCode in (actionKeys "SitDown") || _keyCode in (actionKeys "Throw") || _keyCode in (actionKeys "GetIn") || _keyCode in (actionKeys "GetOut") || _keyCode in (actionKeys "Fire") || _keyCode in (actionKeys "ReloadMagazine") || _keyCode in [16,18]) && ((player getVariable ["restrained",false]) || (player getVariable ["playerSurrender",false]) || life_var_unconscious || life_var_tazed)) exitWith {
    true;
};

if (life_var_isBusy) exitWith {
    if (!life_var_interrupted && _keyCode in _interruptionKeys) then {
        if (life_var_autorun) then {
            ["abort"] call MPClient_fnc_autoruntoggle;
        };
        life_var_interrupted = true
    };
    _stopPropagation;
};

if (_keyCode in (actionKeys "User2")) exitWith
{
	if (profileNamespace getVariable ["life_var_partyESPtoggle", true]) then 
	{
		if ((group player getVariable ["gang_id",-1]) isNotEqualTo -1) then 
		{
			//[]call MPClient_fnc_updatePartyMarker; 
		};
	};
	true
};

if (_keyCode in (actionKeys "User3")) exitWith
{
	life_var_hud_waypoints = [];
	true
};

private _interactionKey = if (actionKeys "User10" isEqualTo []) then {DIK_LWIN} else {(actionKeys "User10") select 0};

if (life_container_active) exitwith {
    if (life_var_autorun) then {
        ["abort"] call MPClient_fnc_autoruntoggle;
    };
    //ignore movement actions
    private _allowedMoves = [
        "MoveForward",
        "MoveBack",
        "TurnLeft",
        "TurnRight",
        "MoveFastForward",
        "MoveSlowForward",
        "turbo",
        "TurboToggle",
        "MoveLeft",
        "MoveRight",
        "WalkRunTemp",
        "WalkRunToggle",
        "AdjustUp",
        "AdjustDown",
        "AdjustLeft",
        "AdjustRight",
        "Stand",
        "Crouch",
        "Prone",
        "MoveUp",
        "MoveDown",
        "LeanLeft",
        "LeanLeftToggle",
        "LeanRight",
        "LeanRightToggle"
    ];
    if (({_keyCode in (actionKeys _x)} count _allowedMoves) > 0) exitwith {
        false;
    };
    //handle other keys
    if (_keyCode isEqualTo DIK_SPACE) then {//space key -> place
        life_var_storagePlacing = 0 spawn MPClient_fnc_placestorage;
    } else { //other keys -> abort
        if (!isNull life_var_storagePlacing) exitWith {}; //already placing down a box
        if (!isNull life_var_activeContaineObject) then {
            deleteVehicle life_var_activeContaineObject;
            titleText [localize "STR_NOTF_PlaceContainerAbort", "PLAIN"];
        };
        life_container_active = false;
    };
    true;
};

switch (_keyCode) do  
{ 
	//-- row 1
	case DIK_ESCAPE: { };
	case DIK_F1: { _stopPropagation = true; }; 
	case DIK_F2: { _stopPropagation = true; };
	case DIK_F3: { _stopPropagation = true; };
	case DIK_F4: { _stopPropagation = true; };
	case DIK_F5: { _stopPropagation = true; };
	case DIK_F6: { _stopPropagation = true; };
	case DIK_F7: { _stopPropagation = true; }; 
	case DIK_F8: { _stopPropagation = true; }; 
	case DIK_F9: { _stopPropagation = true; }; 
	case DIK_F10: { _stopPropagation = true; }; 
	case DIK_F11: { _stopPropagation = true; }; 
	case DIK_F12: { _stopPropagation = true; };   
	
	//-- row 2
	case DIK_GRAVE:	{ _stopPropagation = true; };
	case DIK_1: 	
	{  
		if (primaryWeapon player != "") then {
			if (primaryWeapon player != currentWeapon player) then {
				if (life_var_autorun) then {
					["abort"] call MPClient_fnc_autoruntoggle; 
				};
				player selectWeapon (primaryWeapon player);
			};
		}; 
		_stopPropagation = true; 
	};
	case DIK_2: 	
	{  
		if (handgunWeapon player != "") then {
			if (handgunWeapon player != currentWeapon player) then {
				if (life_var_autorun) then {
					["abort"] call MPClient_fnc_autoruntoggle; 
				};
				player selectWeapon (handgunWeapon player);
			};
		}; 
		_stopPropagation = true; 
	};
	case DIK_3: 	
	{
		if (secondaryWeapon player != "") then {
			if (secondaryWeapon player != currentWeapon player) then {
				if (life_var_autorun) then {
					["abort"] call MPClient_fnc_autoruntoggle; 
				};
				player selectWeapon (secondaryWeapon player);
			};
		};
		_stopPropagation = true; 
	};
	case DIK_4: { _stopPropagation = true; };
	case DIK_5: { _stopPropagation = true; };
	case DIK_6: { _stopPropagation = true; };
	case DIK_7: { _stopPropagation = true; };
	case DIK_8: { _stopPropagation = true; };   
	case DIK_9: { _stopPropagation = true; };
	case DIK_0: 
	{ 
		if (!dialog && !(player getVariable ["restrained",false]) && {!life_var_isBusy}) then  {
			["toggle"] call MPClient_fnc_autoruntoggle;
		};
        _stopPropagation = true;
	};
	case DIK_BACK: { _stopPropagation = true; }; 
	case DIK_HOME: { };

	//-- row 3 
	case DIK_Q:
    {
        private _vehicle = vehicle player;
        if(_vehicle isNotEqualTo player AND {driver _vehicle isEqualTo player})then{
            [player, "left"] remoteExec ["MPClient_fnc_enableIndicator"];
            _stopPropagation = true;
        };
    };
	case DIK_W:
	{
		if (life_var_autorun) then {
			["abort"] call MPClient_fnc_autoruntoggle;
			_stopPropagation = true; 
		};
	};
	case DIK_E: 
    {
        private _vehicle = vehicle player;
        if(_vehicle isNotEqualTo player AND {driver _vehicle isEqualTo player})then{
            [player, "right"] remoteExec ["MPClient_fnc_enableIndicator"];
            _stopPropagation = true;
        };
    };
	case DIK_R: 
	{
        if (_shiftState && playerSide isEqualTo west && {!isNull cursorObject} && {cursorObject isKindOf "CAManBase"} && {(isPlayer cursorObject)} && {(side cursorObject in [civilian,independent])} && {alive cursorObject} && {cursorObject distance player < 3.5} && {!(cursorObject getVariable "Escorting")} && {!(cursorObject getVariable "restrained")} && {speed cursorObject < 1}) then {
            if (life_var_autorun) then {
                ["abort"] call MPClient_fnc_autoruntoggle;
            };
            [] call MPClient_fnc_restrainAction;
			_stopPropagation = true
        };
	};
	case DIK_T: 
	{
        if (!_altState && {!_controlState} && {!dialog} && {!life_var_isBusy} && {!(player getVariable ["playerSurrender",false])} && {!(player getVariable ["restrained",false])} && {!life_var_unconscious} && {!life_var_tazed}) then {
            if (!(isNull objectParent player) && alive vehicle player) then {
                if ((vehicle player) in life_var_vehicles) then {
                    [vehicle player] spawn MPClient_fnc_openInventory;
                };
            } else {
                private "_list";
                _list = ((ASLtoATL (getPosASL player)) nearEntities [["Box_IND_Grenades_F","B_supplyCrate_F"], 2.5]) select 0;
                if (!(isNil "_list")) then {
                    _house = nearestObject [(ASLtoATL (getPosASL _list)), "House"];
                    if (_house getVariable ["locked", false]) then {
                        hint localize "STR_House_ContainerDeny";
                    } else {
                        [_list] spawn MPClient_fnc_openInventory;
                    };
                } else {
                    _list = ["landVehicle","Air","Ship"];
                    if (KINDOF_ARRAY(cursorObject,_list) && {player distance cursorObject < 7} && {isNull objectParent player} && {alive cursorObject} && {!life_var_isBusy}) then {
                        if (cursorObject in life_var_vehicles || {locked cursorObject isEqualTo 0}) then {
                            [cursorObject] spawn MPClient_fnc_openInventory;
                        };
                    };
                };
            };
        };
    };
	case DIK_Y: 
	{
        if (!_altState && !_controlState) then {
            [] call MPClient_fnc_openInventoryMenu;
        };
    };
	case DIK_U: 
	{
        if (!_altState && !_controlState) then {
            if (life_var_autorun) then {
                ["abort"] call MPClient_fnc_autoruntoggle;
            };
            private _veh = if (isNull objectParent player) then {
                cursorObject;
            } else {
                vehicle player;
            };

            if (_veh isKindOf "House_F") then {
                if (_veh in life_var_vehicles && {player distance _veh < 20}) then {
                    private _door = [_veh] call MPClient_fnc_nearestDoor;
                    if (_door isEqualTo 0) exitWith {hint localize "STR_House_Door_NotNear"};
                    private _locked = _veh getVariable [format ["bis_disabled_Door_%1",_door],0];

                    if (_locked isEqualTo 0) then {
                        _veh setVariable [format ["bis_disabled_Door_%1",_door],1,true];
                        _veh animateSource [format ["Door_%1_source", _door], 0];
                        systemChat localize "STR_House_Door_Lock";
                    } else {
                        _veh setVariable [format ["bis_disabled_Door_%1",_door],0,true];
                        _veh animateSource [format ["Door_%1_source", _door], 1];
                        systemChat localize "STR_House_Door_Unlock";
                    };
                };
            } else { 
                if (_veh in life_var_vehicles && {player distance _veh < 20}) then {
                    [player, _veh, _shiftState] remoteExec ["MPServer_fnc_vehicle_lockingRequest",2];
                }else{
                    //create dialog for user to enter lockcode and gain keys. [player, _veh, false, ""] remoteExec ["MPServer_fnc_vehicle_lockingRequest",2]; 
                };
            };
        };
    };
	case DIK_I: { };
	case DIK_O: 
	{
        if (_shiftState) then {
			if(life_var_earplugs)then{
				life_var_earplugs = false;
				1 fadeSound 1;
                systemChat localize "STR_MISC_soundnormal";
			}else{
				life_var_earplugs = true;
				1 fadeSound 0.1;
                systemChat localize "STR_MISC_soundfade";
			};
        };
    };
	case DIK_P: { };
	case DIK_END: { };
	
	//-- row 4 
	case DIK_A:
	{
		if (life_var_autorun) then {
			["abort"] call MPClient_fnc_autoruntoggle;
			_stopPropagation = true; 
		};
	};
	case DIK_S:
	{
		if (life_var_autorun) then {
			["abort"] call MPClient_fnc_autoruntoggle;
			_stopPropagation = true; 
		};
	};
	case DIK_D:
	{
		if (life_var_autorun) then {
			["abort"] call MPClient_fnc_autoruntoggle;
			_stopPropagation = true; 
		};
	};
	case DIK_F: 
	{
        if (playerSide in [west,independent] && {vehicle player != player} && {!life_var_sirenActive} && {((driver vehicle player) == player)}) then {
            [] spawn {
                life_var_sirenActive = true;
                sleep 4.7;
                life_var_sirenActive = false;
            };

            private _veh = vehicle player;
            if (isNil {_veh getVariable "siren"}) then {_veh setVariable ["siren",false,true];};
            if ((_veh getVariable "siren")) then {
                titleText [localize "STR_MISC_SirensOFF","PLAIN"];
                _veh setVariable ["siren",false,true];
                if !(isNil {(_veh getVariable "sirenJIP")}) then {
                    private _jip = _veh getVariable "sirenJIP";
                    _veh setVariable ["sirenJIP",nil,true];
                    remoteExec ["",_jip]; //remove from JIP queue
                };
            } else {
                titleText [localize "STR_MISC_SirensON","PLAIN"];
                _veh setVariable ["siren",true,true];
                private "_jip";
                if (playerSide isEqualTo west) then {
                    _jip = [_veh] remoteExec ["MPClient_fnc_copSiren",RE_CLIENT,true];
                } else {
                    _jip = [_veh] remoteExec ["MPClient_fnc_medicSiren",RE_CLIENT,true];
                };
                _veh setVariable ["sirenJIP",_jip,true];
            };
        };
    };
	case DIK_G: 
	{ 
		if (_shiftState && playerSide isEqualTo civilian && !isNull cursorObject && cursorObject isKindOf "CAManBase" && isPlayer cursorObject && alive cursorObject && cursorObject distance player < 4 && speed cursorObject < 1) then {
            if ((animationState cursorObject) != "Incapacitated" && (currentWeapon player == primaryWeapon player || currentWeapon player == handgunWeapon player) && currentWeapon player != "" && !life_var_knockoutBusy && !(player getVariable ["restrained",false]) && !life_var_tazed && !life_var_unconscious) then {
                [cursorObject] spawn MPClient_fnc_knockoutAction;
            };
            _stopPropagation = true;
        };
	};
	case DIK_H: 
	{
        if (_shiftState && !_controlState && !(currentWeapon player isEqualTo "")) then {
            life_curWep_h = currentWeapon player;
            player action ["SwitchWeapon", player, player, 100];
            player switchCamera cameraView;
			_stopPropagation = true;
        };

        if (!_shiftState && _controlState && !isNil "life_curWep_h" && {!(life_curWep_h isEqualTo "")}) then {
            if (life_curWep_h in [primaryWeapon player,secondaryWeapon player,handgunWeapon player]) then {
                player selectWeapon life_curWep_h;
				_stopPropagation = true;
            };
        };
    };
	case DIK_J: 
    {
        private _vehicle = vehicle player;
        if(_vehicle isNotEqualTo player)then{
            [player, "hazards"] remoteExec ["MPClient_fnc_enableIndicator"];
            _stopPropagation = true;
        };
    };
	case DIK_K: { };
	case DIK_L: 
	{
        //If cop run checks for turning lights on.
        if (_shiftState && playerSide in [west,independent]) then {
            if (!(isNull objectParent player) && (typeOf vehicle player) in ["C_Offroad_01_F","B_MRAP_01_F","C_SUV_01_F","C_Hatchback_01_sport_F","B_Heli_Light_01_F","B_Heli_Transport_01_F"]) then {
                if (!isNil {vehicle player getVariable "lights"}) then {
                    if (playerSide isEqualTo west) then {
                        [vehicle player] call MPClient_fnc_sirenLights;
                    } else {
                        [vehicle player] call MPClient_fnc_medicSirenLights;
                    };
                    _stopPropagation = true;
                };
            };
        };

        if (!_altState && !_controlState) then { [] call MPClient_fnc_radar; };
    };

	//-- row 5 
	case DIK_Z: { };
	case DIK_X: { };
	case DIK_C: { };
	case DIK_V: { };
	case DIK_B: 
	{
        if (_shiftState) then {
            if (life_var_autorun) then {
                ["abort"] call MPClient_fnc_autoruntoggle;
            };
            if (player getVariable ["playerSurrender",false]) then {
                player setVariable ["playerSurrender",false,true];
            } else {
                [] spawn MPClient_fnc_surrender;
            };
            _stopPropagation = true;
        };
    };
	case DIK_N: { };
	case DIK_M: { };

	//-- row 6 
	case _interactionKey:
	{
		if(_shiftState)then{
			life_var_hud_partyespmode =  switch (life_var_hud_partyespmode) do {  
				default  {0};
				case 2;
				case 1:  {2};
				case 0:  {1}; 
			}; 
            hint format ["PartyESP Mode %1",life_var_hud_partyespmode];
		}else{
			if (!life_var_isBusy) then {
				if (life_var_autorun) then {
					["abort"] call MPClient_fnc_autoruntoggle;
				};
				[] spawn  {
					private _handle = [] spawn MPClient_fnc_actionKeyHandler;
					waitUntil {scriptDone _handle};
					life_var_isBusy = false;
				};
			};
		};
		
		_stopPropagation = true;
	};
	case DIK_SPACE:
	{
        if (life_var_autorun) then {
            ["abort"] call MPClient_fnc_autoruntoggle;
        };
        if (isNil "jumpActionTime") then {jumpActionTime = 0;};
        if (_shiftState && {!(animationState player isEqualTo "AovrPercMrunSrasWrflDf")} && {isTouchingGround player} && {stance player isEqualTo "STAND"} && {speed player > 2} && {not((player getVariable ["arrested",false]))} && {((velocity player) select 2) < 2.5} && {time - jumpActionTime > 1.5}) then {
            jumpActionTime = time; //Update the time.
            [player] remoteExec ["MPClient_fnc_jumpFnc",RE_GLOBAL]; //Global execution
            _stopPropagation = true;
        };
    };
	case DIK_PRIOR: { };
	case DIK_NEXT: { };
};


_stopPropagation