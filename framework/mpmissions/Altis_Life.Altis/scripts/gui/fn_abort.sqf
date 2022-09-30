/*

	Function: 	MPClient_fnc_abort
	Project: 	AsYetUntitled
	Author:     Nikko, IceEagle132
	Github:		https://github.com/Ni1kko/FrameworkV2
	
*/

for "_idd" from 140 to 46 step -1 do 
{
    private _display = (findDisplay _idd);
    
    switch _idd do 
    {
        //-- Escape menu closing lets start outro
        case 49:
        {
            startLoadingScreen ["","Life_Rsc_DisplayLoading"];
            uiSleep 0.5;
        };
        //-- Mission end screen update outro
        case 46:
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

            //-- Kick player out server    
            _script = ["STR_EndMission_Logoff_Title", "STR_EndMission_Logoff_Desc", "Logoff"] spawn MPClient_fnc_endMission;
            waitUntil {uiSleep 1.2; scriptDone _script};
        };
    };
    _display closeDisplay 2
};

true