/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isServer)exitwith{false};
if(isRemoteExecuted)exitwith{false};

life_var_database_error = false;

if (!isFinal "life_var_databaseID") then 
{
    life_var_databaseID = compileFinal str(round(random(99999)));  
    life_var_databaseCFG = "altislife";
	try {
        _result = "extDB3" callExtension format ["9:ADD_DATABASE:%1",life_var_databaseCFG];
        if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};
        
		_result = "extDB3" callExtension format ["9:ADD_DATABASE_PROTOCOL:%2:SQL:%1:TEXT2",(call life_var_databaseID),life_var_databaseCFG];
        if (!(_result isEqualTo "[1]")) then {throw "extDB3: Error with Database Connection"};

		"extDB3" callExtension "9:LOCK";
		diag_log "extDB3: Connected to Database";
    } catch {
        diag_log _exception;
		life_var_database_error = true;
    }; 
} else {
    diag_log "extDB3: Still Connected to Database";
};

publicVariable "life_var_database_error";

if (life_var_database_error) exitWith {false};

/* Run stored procedures for SQL side cleanup */
["CALL resetLifeVehicles",1] call DB_fnc_asyncCall;
["CALL deleteDeadVehicles",1] call DB_fnc_asyncCall;
["CALL deleteOldHouses",1] call DB_fnc_asyncCall;
["CALL deleteOldGangs",1] call DB_fnc_asyncCall;

if (getNumber(missionConfigFile >> "Life_Settings" >> "save_civilian_position_restart") isEqualTo 1) then {
    ["UPDATE players SET civ_alive = '0' WHERE civ_alive = '1'",1] call DB_fnc_asyncCall;
};


true