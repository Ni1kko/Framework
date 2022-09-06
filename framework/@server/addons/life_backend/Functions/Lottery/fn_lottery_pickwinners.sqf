/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

params [
	["_vaultObject",objNull,[objNull]]
];

(call life_var_lotto_config) params [
	"_ticketPrice",
	"_ticketLength",
	"_ticketDrawCount",
	"_ticketsReclaim",
	"_ticketBonusballPrice"
];

//-- Get tickets from database
private _queryTickets = ["READ", "lotteryTickets", 
	[
		["ticketID", "BEGuid", "numbers", "bonusball"],
		[
			["active", ["DB","BOOL", true] call MPServer_fnc_database_parse],
			["serverID",["DB","INT",call life_var_serverID] call MPServer_fnc_database_parse]
		]
	]
] call MPServer_fnc_database_request;

uiSleep 5;

private _Winners = [];
private _jackpotRollover = _vaultObject getVariable ["safe",0];
private _winningNumbers = [];
private _winningBonusBall = [] call MPServer_fnc_lottery_generateBonusBall;
private _bonusBallPayout = _ticketBonusballPrice * ((floor(random (10 + life_var_serverMaxPlayers))) * 0.9);
private _totalTicketsPurchased = count _queryTickets;
private _JackPot = ((_ticketPrice * _totalTicketsPurchased) * 0.9) + _jackpotRollover;
private _jackpotSplit = _JackPot;

//-- Generate winning tickets
for "_i" from 1 to _ticketDrawCount do {
	_winningNumbers pushBack ([] call MPServer_fnc_lottery_generateTicket);
};

//-- Check if there are any winning tickets
{
	_x params ["_ticketid", "_BEGuid", "_numbers", "_bonusball"];

	_numbers = ["GAME","STRING", _numbers] call MPServer_fnc_database_parse;
	_bonusball = ["GAME","STRING", _bonusball] call MPServer_fnc_database_parse;

	private _wonBonusBall = [_winningBonusBall isEqualTo _bonusball,false] select (parseNumber _bonusball isEqualTo 0);
	
	if(_numbers in _winningNumbers)then{
		_Winners pushBack [_ticketid,_BEGuid,_wonBonusBall,_ticketLength];
	}else{
		private _matches = 0;
		{
			private _winningNumber = _x;

			{
				private _number = _x;
				if(_number in _numbers)then{
					_matches = _matches + 1;
				};
			}forEach (_winningNumber splitString "");
		}forEach _winningNumbers;

		if(_matches >= (_ticketLength / 2))then{
			_Winners pushBack [_ticketid,_BEGuid,_wonBonusBall,_matches];
		};
	};
} forEach (_queryTickets call BIS_fnc_arrayShuffle);

//-- Calculate winnings split between all winners
_jackpotSplit = _JackPot / (count _Winners);

//-- Make tickets dead in database
["CALL", "deactiveLotteryTickets"] call MPServer_fnc_database_request;

//-- Nobody one (Rollover)
if (count(_Winners) <= 0) exitWith {
	[0,format["No one has won the lottery! $%1 will be added to next drawing.",[_Jackpot] call life_fnc_numberText]] remoteExec ["life_fnc_broadcast",0];
	 
	_vaultObject setVariable ["safe",_JackPot,true];

	["UPDATE", "servers", [
		[
			["vault",["DB","INT", _JackPot] call MPServer_fnc_database_parse]
		],
		[
			["serverID",["DB","INT",call life_var_serverID] call MPServer_fnc_database_parse]
		]
	]]call MPServer_fnc_database_request;
};

//-- Empty vault
_vaultObject setVariable ["safe",0,true];
["UPDATE", "servers", [[["vault",["DB","INT", 0] call MPServer_fnc_database_parse]],[["serverID",["DB","INT",call life_var_serverID] call MPServer_fnc_database_parse]]]]call MPServer_fnc_database_request;

//-- Notify
[0,format["Someone has won the lottery jackpot of $%1!",[_Jackpot] call life_fnc_numberText]] remoteExec ["life_fnc_broadcast",0];


//-- Paytime
{
	_x params ["_ticketid","_WinnerGuid","_wonBonusBall","_matches"];

	private _winnerIndex = _forEachIndex;
	
	{
		if(isPlayer _x)then{ 
			private _player = _x;
			private _name = (name _player);
			private _steamID = (getPlayerUID _player);
			private _ownerID = (owner _player);
			private _BEGuid = ('BEGuid' callExtension ("get:"+_steamID));
			private _payout = _jackpotSplit;
			private _payoutBB = _bonusBallPayout;

			if (_BEGuid isEqualTo _WinnerGuid) then 
			{  
				//--- Part winner
				if(_matches isNotEqualTo _ticketLength)then{
					_payout = (_payout / (_ticketLength - _matches));
					_payoutBB = (_payoutBB / (_ticketLength - _matches));
				};
				
				//--- Boradcast
				[
					0,
					[
						format["%1 is a lotto winner!",_name],
						format["%1 is a lotto winner and won the bounus ball (%2)!",_name,_winningBonusBall]
					] select _wonBonusBall
				] remoteExec ["life_fnc_broadcast",0];

				//--- Payout
				[
					[
						_payout,
						_wonBonusBall,
						[0,_payoutBB]select _wonBonusBall
					],
					{
						params ["_ticketPayout","_bonusBallWinner","_bonusBallPayout"];

						private _totalPayout = _ticketPayout + _bonusBallPayout;
						
						systemChat ([
							format["You have won $%1 from the lottery!",[_ticketPayout] call life_fnc_numberText],
							format["You have won $%1 from the lottery bonusball!",[_bonusBallPayout] call life_fnc_numberText]
						] select _bonusBallWinner);

						life_var_cash = life_var_cash + _totalPayout;
					}
				] remoteExec ["spawn",_ownerID];

				_Winners deleteAt _winnerIndex;
			}; 
		};
	} forEach playableUnits; 
}forEach _Winners;

//-- Reclaim tickets
if _ticketsReclaim then {
	private _offlineWinners = _Winners;

	{
		_x params ["_ticketid","_BEGuid","_wonBonusBall"];

		["CREATE", "unclaimedLotteryTickets", 
			[
				["BEGuid", 					["DB","STRING", _BEGuid] call MPServer_fnc_database_parse],
				["serverID",				["DB","INT", call life_var_serverID] call MPServer_fnc_database_parse],
				["winnings", 				["DB","INT", _jackpotSplit] call MPServer_fnc_database_parse],
				["bonusball", 				["DB","BOOL", _wonBonusBall] call MPServer_fnc_database_parse],
				["bonusballWinnings", 		["DB","INT", [0, _bonusBallPayout] select _wonBonusBall] call MPServer_fnc_database_parse]
			]
		] call MPServer_fnc_database_request;
	}forEach _offlineWinners;
};

//-- Delete dead tickets from database
["CALL", "deleteOldLotteryTickets"] call MPServer_fnc_database_request;

//-- Allow new tickets to be purchased
Life_var_lottoDrawLock = false;
publicVariable "Life_var_lottoDrawLock";

//-- 
true
