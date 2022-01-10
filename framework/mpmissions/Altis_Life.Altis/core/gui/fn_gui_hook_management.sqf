/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

disableSerialization;

params [
    ["_show",true]//note hide before changing layer or will bug 
];

private _layer1 = "RscPlayerHUD"; 
private _layer1_id = (_layer1 call BIS_fnc_rscLayer); 
private _display1 = uiNamespace getVariable [_layer1,displayNull]; 

life_var_hud_layer1_hooks = [//visble when main hud shown
	"PartyESP",
	"StatsPanel",
	"WeaponPanel",
	"GroupPanel",
	"VehiclePanel",
	"GrenadePanel",
	"Waypoints",
	"Notifications"
];
life_var_hud_layer_autohide_hooks = [1];//auto hide hooks
life_var_hud_layer_autohide_displays = [//displays where auto hide hooks are hidden
	12,	 //12 = map visible 
	49,  //49 = escape menu 
	602, //602 = inventory menu
	7300 //7300 = death screen
];

if(_show)then{
    if (life_var_hud_eventhandle isEqualTo -1) then { //Setup hook frame 
        switch (life_var_hud_activelayer) do {
			case 1:
			{
				if(isNull _display1)then{
					_layer1_id cutRsc [_layer1,"PLAIN"]; // show layer
				};
				life_var_hud_layer1shown = true;//shown
			};
		};
        life_var_hud_eventhandle = addMissionEventHandler ["Draw3D", {//--- Render: Hooks
			{0 call (missionNamespace getVariable [format["life_fnc_gui_render%1",_x] ,{}])}forEach (switch (true) do {
				case life_var_hud_layer1shown:{life_var_hud_layer1_hooks};
				default {["Notifications"]};
			});
			true
		}];
    };
    life_var_hud_laststatsrendered_at = diag_tickTime;//skip hook to next frame
}else{
    if (life_var_hud_eventhandle isNotEqualTo -1) then {//Remove hook frame
		switch (life_var_hud_activelayer) do {
			case 1:
			{
				if(!isNull _display1)then{
					(_layer1 call BIS_fnc_rscLayer) cutText ["","PLAIN"]; // remove layer
				};
				life_var_hud_layer1shown = false;//hidden
			};
		};
		removeMissionEventHandler ["Draw3D", life_var_hud_eventhandle]; // remove hooks
		life_var_hud_eventhandle = -1; //reset
	}; 
};

//-- Run Once
if(isFinal "life_var_hud_threads")exitWith{life_var_hud_layer1shown};
life_var_hud_threads = compileFinal str(systemTimeUTC);

//-- AutoHide
[]spawn {
    while {true} do { 
        //Hide
        waitUntil {true in (life_var_hud_layer_autohide_displays apply {if(_x isEqualTo 12)then{visibleMap}else{!isNull(findDisplay _x)}})};
		if (life_var_hud_activelayer in life_var_hud_layer_autohide_hooks)then{
			[false] call life_fnc_gui_hook_management;
		};
        //Show
        waitUntil {!(true in (life_var_hud_layer_autohide_displays apply {if(_x isEqualTo 12)then{visibleMap}else{!isNull(findDisplay _x)}}))};
		if (life_var_hud_activelayer in life_var_hud_layer_autohide_hooks)then{
			[true] call life_fnc_gui_hook_management;
		}; 
    };
};
