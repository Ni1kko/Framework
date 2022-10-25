/*
    File: fn_say3D.sqf
    Author: Bryan "Tonic" Boardwine
    Modified by: blackfisch

    Description:
    Pass your sounds that you want everyone nearby to hear through here.

    Example:   [_veh,"unlock",50,1] remoteExec ["MPClient_fnc_say3D",0];
*/
params [
    ["_object",objNull,[objNull]],
    ["_sound","",[""]],
    ["_distance",100,[0]],
    ["_pitch",1,[0]],
    ["_time",0,[0]]
];

if (isNull _object OR {_sound isEqualTo "" OR {not(isClass (missionConfigFile >> "CfgSounds" >> _sound))}}) exitWith {objNull}; 
if (_distance < 0) then {_distance = 100};

private _soundObject = _object say3D [_sound,_distance,_pitch];

if(_time > 0)then{
    [_soundObject, _time] spawn {
        scriptName 'MPClient_fnc_say3DTimer';
        params ["_soundObject","_time"];
        sleep _time;
        if(not(isNull _soundObject))then{
            deleteVehicle _soundObject;
        };
    };
};

if(_object getVariable ["endSoundPending",false])then{
    [_object,_soundObject, _time] spawn {
        scriptName 'MPClient_fnc_say3DVar';
        params ["_object","_soundObject"];
        waitUntil {isNull _soundObject OR {not(_object getVariable ["endSoundPending",true])}};
        if(not(isNull _soundObject))then{
            deleteVehicle _soundObject;
        };
    };
};

_soundObject