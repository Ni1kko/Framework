/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

if(!isFinal "life_var_banksReady")exitWith{false};

switch (param [0,""]) do 
{
    case "vault": 
    {
        private _vaultObject = missionNamespace getVariable ["fed_bank",objNull]; 

        //-- Get current gold
        private _currentfunds = _vaultObject getVariable ["safe",0];

        //-- Add more gold
        private _newfunds = _currentfunds + round(random ["_addMin","_addMid","_addMax"]);

        //-- Limit reached.... hmmm just half the amount of gold we have?
        if(_newfunds > _maxGold)then{
            _newfunds = _newfunds / 2;
        };

        //-- Update the vault
        _vaultObject setVariable ["safe",_newfunds,true];

        //-- Update the database 
        ["UPDATE", "servers", [[["vault",["DB","INT", _newfunds] call life_fnc_database_parse]],[["serverID",["DB","INT",call life_var_serverID] call life_fnc_database_parse]]]]call life_fnc_database_request;
    };
    case "bank": 
    {
        {
            _x params [
                ["_branchName",""],
                ["_bank",objNull]
            ];

            {
                _shelf = _x;
                {
                    if(isNull (_x select 1)) then {
                        private _open = false;
                        private _doors = getNumber(configFile >> "CfgVehicles" >> (typeof _bank) >> "NumberOfDoors");
                        for "_i" from 1 to _doors do {
                            if(_bank getVariable[format["bis_disabled_Door_%1",_i],1] == 0) exitWith {
                                _open = true;
                            };
                        };						

                        if(_open) exitWith {
                            [0,format["The delivery to the %1 has been stopped as the bank is currently under attack/the doors are not closed!",_branchName]] remoteExecCall ["life_fnc_broadcast",west];
                        };

                        private _m = (_x#2) createVehicle [0,0,0];
                        _m enableSimulationGlobal false;
                        _m allowDamage false;
                        _m setVariable["bankItem",true,true];
                        _m attachTo[_shelf, _x#0];
                        _x set[1, _m];
                    };
                } forEach (_shelf getVariable["bankItemPiles",[]]);
            } forEach ((_x#1) getVariable["bankContainers",[]]);
        } forEach life_var_banks;
    };
    case "atm": 
    {
        private _topupAmount = 1000000;
        private _maxFunds = (_topupAmount * 10);
        {   
            //--- Add funds
            if(!(_x getVariable["robbed",false]))then
            {
                private _availableFunds = _x getVariable["availableFunds",0];
                private _newFunds = _availableFunds + _topupAmount;

                if(_availableFunds < _maxFunds AND _newFunds < _maxFunds) then {
                    _x setVariable["availableFunds",_newFunds,true];
                };
            };

            //--- Reset the robbed state
            if((diag_tickTime - (_x getVariable["lastRobbed",diag_tickTime])) >= (25 * 60)) then {
                _x setVariable["lastRobbed",nil,true];
                _x setVariable["robbers",[],true];
                _x setVariable["robbed",false,true];
            };
        } forEach life_var_atms;
    };
};

true
