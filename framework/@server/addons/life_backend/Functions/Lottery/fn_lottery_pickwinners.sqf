/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_vaultObject",objNull,[objNull]]
];

//-- Get tents from database
private _queryTickets = ["READ", "lotteryTickets", 
	[
		["id", "BEGuid", "numbers"],
		[["active", ["DB","BOOL", true] call life_fnc_database_parse]]
	]
] call life_fnc_database_request;

uiSleep 5;

private _Winners = [];
private _jackpotRollover = _vaultObject getVariable ["safe",0];
private _winningNumbers = [floor(random(1000)),round(random(1000)),floor(random(1000)),round(random(1000)),floor(random(1000)),round(random(1000))];
private _Count = count _queryTickets;
private _JackPot = ((300 * _Count) * 0.9) + _jackpotRollover;
private _Split = _JackPot / (count(_Winners));

//-- Check if there are any winning tickets
{
	_x params ["_ticketid", "_BEGuid", "_numbers"];

	if(_numbers in _winningNumbers)then{
		_Winners pushBack [_ticketid,_BEGuid];
	};
} forEach (_queryTickets call BIS_fnc_arrayShuffle);

//-- Make tickets dead in database
["CALL", "deactiveLotteryTickets"] call life_fnc_database_request;

//-- Nobody one (Rollover)
if (count(_Winners) <= 0) exitWith {
	[0,format["No one has won the lottery! $%1 will be added to next drawing.",[_Jackpot] call life_fnc_numberText]] remoteExec ["life_fnc_broadcast",0];
	 
	_vaultObject setVariable ["safe",_JackPot,true];

	["UPDATE", "servers", [
		[
			["vault",["DB","INT", _JackPot] call life_fnc_database_parse]
		],
		[
			["serverID",["DB","INT",call life_var_serverID] call life_fnc_database_parse]
		]
	]]call life_fnc_database_request;
};

//-- Empty vault
_vaultObject setVariable ["safe",0,true];
["UPDATE", "servers", [
	[
		["vault",["DB","INT", 0] call life_fnc_database_parse]
	],
	[
		["serverID",["DB","INT",call life_var_serverID] call life_fnc_database_parse]
	]
]]call life_fnc_database_request;

//-- Notify
[0,format["Someone has won the lottery jackpot of $%1!",[_Jackpot] call life_fnc_numberText]] remoteExec ["life_fnc_broadcast",0];

//-- Paytime
{
	if (getPlayerUID _x in _Winners) then 
	{
		[0,format["%1 is a lotto winner!",name _x]] remoteExec ["life_fnc_broadcast",0];

		[_Split,{
			life_var_cash = life_var_cash + _this;
			systemChat format["You have won $%1 from the lottery!",[_this] call life_fnc_numberText]
		}] remoteExec ["spawn",owner _x]; 
	};
} forEach playableUnits;

//-- Delete dead tickets from database
["CALL", "deleteOldLotteryTickets"] call life_fnc_database_request;

Life_var_lottoDrawLock = false;
publicVariable "Life_var_lottoDrawLock";

true