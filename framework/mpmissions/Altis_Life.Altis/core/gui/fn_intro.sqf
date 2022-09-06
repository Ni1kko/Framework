/*	
	File: fn_intro.sqf
*/

private ["_camera", "_camDistance","_randCamX","_randCamY","_camTime"];
_camDistance = 350;
_randCamX = 75 - floor(random 150);
_randCamY = 75 - floor(random 150);
_camTime = 12;

//intro move
showCinemaBorder false;
playsound "intro"; // Lets Play Some Music

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

[true] call MPClient_fnc_gui_hook_management;