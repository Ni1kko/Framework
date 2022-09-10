/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
    ["_directPlayID",-100,[0]],		    // Number - is the unique DirectPlay ID. Quite useless as the number is too big for in-built string representation and gets rounded. It is also the same id used for user placed markers.
    ["_steamID","",[""]],				// String - is getPlayerUID of the joining player. In Arma 3 it is also the same as Steam ID.
    ["_name","",[""]],		   			// String - is profileName of the joining player.
    ["_didJIP",false,[false]], 			// Boolean - is a flag that indicates whether or not the player joined after the mission has started (Joined In Progress). true when the player is JIP, otherwise false. (since Arma 3 v1.49)
    ["_ownerID",-100,[0]],	   			// Number - is owner id of the joining player. Can be used for kick or ban purposes or just for publicVariableClient. (since Arma 3 v1.49) 
    ["_directPlayIDStr","",[""]],		// String - same as _id but in string format, so could be exactly compared to user marker ids. (since Arma 3 v1.95) 
    ["_customArgs",[]] 		            // User-Defined - custom passed args (since Arma 3 v2.03) 
];

//--- Get BEGuid
private _BEGuid = ('BEGuid' callExtension ("get:"+_steamID));
if(_BEGuid isEqualTo "")exitWith{};

//--- Update current players
private _playerData = [_name,_BEGuid];
private _playerIndex = life_var_serverCurrentPlayers find _playerData;
if(_playerIndex isNotEqualTo -1)then{ 
   if((life_var_serverCurrentPlayers deleteAt _playerIndex) isEqualTo _playerData)then{
        //--- Send query
        ["UPDATE", "servers", [
            [
                ["currentplayers", ["DB","ARRAY",life_var_serverCurrentPlayers] call MPServer_fnc_database_parse]
            ],
            [
                ["serverID", ["DB","INT", (call life_var_serverID)] call MPServer_fnc_database_parse]
            ]
        ]]call MPServer_fnc_database_request;
        [format ["[Player Logout]: `%1` - (%2) - (%3) ", _name, _BEGuid, _steamID]] call MPServer_fnc_log;
    };
};