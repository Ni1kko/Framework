/*
    File: fn_abort.sqf
    Author: Ni1kko
    Description:
*/
life_fnc_abort = {
    params[
        ["_control",controlNull,[controlNull]],
        ["_handler",""],
        ["_function",""]
    ];
    
    //-- Get escape menu object
    private _display = displayParent _control;
     
    //-- Close escape menu (must be closed before display 46 is closed)
    _display closeDisplay 2;
    startLoadingScreen ["","Life_Rsc_DisplayLoading"];

    //---
    ["Thanks for playing","Till next time"] call life_fnc_setLoadingText;

    //-- Sync player data to server
    [] call SOCK_fnc_updateRequest;

    //--- Request server to clean up player
    [player] remoteExec ["TON_fnc_cleanupRequest",2];
    
    [findDisplay 46]spawn{
        uiSleep 5;
        endLoadingScreen;
        _this closeDisplay 2; 
    };
};