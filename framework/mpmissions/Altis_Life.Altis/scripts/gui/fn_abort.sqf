/*

	Function: 	MPClient_fnc_abort
	Project: 	AsYetUntitled
	Author:     Nikko, IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

private _RscDisplayMainIDD =  getNumber(configFile >> "RscDisplayMain" >> "idd");
private _RscDisplayMissionIDD = getNumber(configFile >> "RscDisplayMission" >> "idd");
private _RscDisplayMPInterruptIDD = getNumber(configFile >> "RscDisplayMPInterrupt" >> "idd");

//-- Close any open dialogs
while {dialog} do {
    closeDialog 2;
};

//-- Close any open RscLayers
{
    private _layerID = [_x] call BIS_fnc_rscLayer;
    _layerID cutText ["","PLAIN"];
    _layerID cutFadeOut 0;
}forEach allCutLayers;

//-- Close certian open displays
for "_idd" from (_RscDisplayMissionIDD + 10000) to _RscDisplayMissionIDD step -1 do 
{
    private _display = (findDisplay _idd);
    
    //-- Run the custom onUnload event handler
    switch _idd do
    {
        //-- Escape menu
        case _RscDisplayMPInterruptIDD:
        {
            //-- Close Escape Menu
            _display closeDisplay 1;

            //-- Start Outro Screen
            startLoadingScreen ["","RscDisplayLoadingScreen"];
            
            //-- Prevent HUD reloading after Escape Menu display close (This is not a bug HUD is designed to open and close automaticly when display(s) is opened and closed)
            [false] call MPClient_fnc_gui_hook_management;
        };
        //-- Mission end
        case _RscDisplayMissionIDD:
        {
            private ["_script"];

            //-- Sync player data to server
            [] call MPClient_fnc_updateRequest;
            _script = ["Syncing your data", "Please wait...", "red"] spawn MPClient_fnc_setLoadingText;
            waitUntil {uiSleep 1.2; scriptDone _script};
            
            //--- Request server to clean up player
            [player] remoteExec ["MPServer_fnc_cleanupRequest",2];
            _script = ["Server Cleanup", "Please wait...", "red"] spawn MPClient_fnc_setLoadingText;
            waitUntil {uiSleep 1.2; scriptDone _script};
            
            //-- Close any other open displays as IDD 46 is the mission end screen
            {([_x] param [0, displayNull]) closeDisplay 2}forEach (allDisplays - [
                findDisplay _RscDisplayMainIDD, 
                findDisplay 8,
                findDisplay 12,
                findDisplay 18,
                _display
            ]);

            //-- Kick player out server    
            _script = ["STR_EndMission_Logoff_Title", "STR_EndMission_Logoff_Desc", "Logoff"] spawn MPClient_fnc_endMission;
            waitUntil {uiSleep 1.2; scriptDone _script};
        };
        //-- Close the display
        default {_display closeDisplay 2};
    };
};

true