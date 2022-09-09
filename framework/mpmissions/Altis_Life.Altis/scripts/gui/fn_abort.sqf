/*

	Function: 	MPClient_fnc_abort
	Project: 	AsYetUntitled
	Author:     Nikko, IceEagle132
	Github:		https://github.com/AsYetUntitled/Framework
	
*/
 
//-- Close escape menu (must be closed before display 46 is closed)
(findDisplay 49) closeDisplay 2;

for "_idd" from 140 to 46 do {
    private _display = (findDisplay _idd);
    if(!isNull _display)then{
        _display closeDisplay 2;
    };
};

(findDisplay 46) spawn{
    startLoadingScreen ["","Life_Rsc_DisplayLoading"];

    //-- Sync player data to server
    [] call MPClient_fnc_updateRequest;
    ["Syncing your data", "Please wait...", "red"] call MPClient_fnc_setLoadingText;
    uiSleep 2;

    //--- Request server to clean up player
    [player] remoteExec ["MPServer_fnc_cleanupRequest",2];
    ["Server Cleanup", "Please wait...", "red"] call MPClient_fnc_setLoadingText;
    uiSleep 2;

    ["Thanks for playing","Till next time","red"] call MPClient_fnc_setLoadingText;
    playSound "byebye";
    uiSleep 3;
    endLoadingScreen;
    _this closeDisplay 2; 
};