/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
	["_object",player,[objNull]],
	["_camTime",12,[0]],
	["_camDistance",350,[0]]
];

private _randCamX = 75 - floor(random 150);
private _randCamY = 75 - floor(random 150);
private _cameraPos = position _object;
  
_cameraPos params [
	["_cameraPosX",0,[0]],
	["_cameraPosY",0,[0]],
	["_cameraPosZ",0,[0]]
];

//-- Hide cinema borders
showCinemaBorder false;

//-- Hide HUD
[false] call MPClient_fnc_gui_hook_management;

//-- Create camera view
private _camera = "camera" camCreate [_cameraPosX+_randCamX, _cameraPosY+_randCamY,_cameraPosZ+_camDistance];
_camera cameraEffect ["internal","back"];
_camera camSetFOV 2.000;
_camera camCommit 0;
waitUntil {camCommitted _camera};

//-- Adjust view to object
_camera camSetTarget ([_object, vehicle _object] select (_object isKindOf "Man"));
_camera camSetRelPos [0,0,2];
_camera camCommit _camTime;
waitUntil {camCommitted _camera};

//-- Terminate camera
_camera cameraEffect ["terminate","back"];
camDestroy _camera;

//-- Show HUD
[true] call MPClient_fnc_gui_hook_management;

true