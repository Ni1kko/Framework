#include "..\..\script_macros.hpp"
/*	
	File: fn_intro.sqf
	Usage: [] spawn life_fnc_intro;
*/

private _camDistance = LIFE_SETTINGS(getNumber,"cam_distance");
private _camTime = LIFE_SETTINGS(getNumber,"cam_time");
private _randCamX = 75 - floor(random 150);
private _randCamY = 75 - floor(random 150);

//intro move
showCinemaBorder false;
playsound "intro"; // Lets Play Some Music
private ["_camera"];
_camera = "camera" camCreate [(position player select 0)+_randCamX, (position player select 1)+_randCamY,(position player select 2)+_camDistance];
_camera cameraEffect ["internal","back"];
_camera camSetFOV 2.000;
_camera camCommit 0;
waitUntil {camCommitted _camera};
_camera camSetTarget vehicle player;
_camera camSetRelPos [0,0,2];
_camera camCommit _camTime;
waitUntil {camCommitted _camera};
_camera cameraEffect ["terminate","back"];
camDestroy _camera;