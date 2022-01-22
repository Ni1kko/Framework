#include "..\..\script_macros.hpp"
/*
    File: fn_insertPlayerInfo.sqf
    Author: Bryan "Tonic" Boardwine

    Description:
    Upon first join inital player data is sent to the server and added to the database.
    Setup data gets sent to life_backend\Functions\MySQL\fn_insertRequest.sqf
*/
if (life_session_completed) exitWith {}; //Why did this get executed when the client already initialized? Fucking arma...

//cutText["The server didn't find a database record matching your BEGuid, attempting to add player into our database.","BLACK FADED"];
//0 cutFadeOut 9999999;
["The server didn't find a database record matching your BEGuid, attempting to add player into our database."] call life_fnc_setLoadingText; uiSleep(random[0.5,3,6]);

[player] remoteExecCall ["DB_fnc_insertRequest",2];