/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/


private _queryTickets = ["READ", "unclaimedLotteryTickets", 
	[
		["ticketID", "BEGuid", "winnings", "bonusball","bonusballWinnings"],
		[["claimed", ["DB","BOOL", false] call life_fnc_database_parse]]
	]
] call life_fnc_database_request;

private _claimedTickets = [];

while {count _queryTickets > 0} do {
	private _allPlayers = playableUnits;

	waitUntil {
		uiSleep 10;
		count _allPlayers isNotEqualTo count playableUnits
	};

	{
		_x params ["_ticketID", "_WinnerGuid", "_winnings", "_wonBonusBall","_bonusballWinnings"];

		private _winnerIndex = _forEachIndex;

		{
			if(isPlayer _x)then{ 
				private _player = _x;
				private _name = (name _player);
				private _steamID = (getPlayerUID _player);
				private _ownerID = (owner _player);
				private _BEGuid = ('BEGuid' callExtension ("get:"+_steamID));
	
				if (_BEGuid isEqualTo _WinnerGuid) then 
				{  
					[
						[
							_winnings,
							_wonBonusBall,
							[0,_bonusballWinnings]select _wonBonusBall
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

					_queryTickets deleteAt _winnerIndex;
					_claimedTickets pushBack _ticketID;
				}; 
			};
		}forEach _allPlayers

		uiSleep 2; 

	}forEach _queryTickets;


	if(count _claimedTickets > 0)then{
		{ 

			["UPDATE", "unclaimedLotteryTickets", 
				[
					["claimed", ["DB","BOOL", true] call life_fnc_database_parse], 
				],
				[
					["ticketID", ["DB","INT", _x] call life_fnc_database_parse]
				]
			] call life_fnc_database_request;
			_queryTickets deleteAt _forEachIndex;
		}forEach _claimedTickets;
	};

	uiSleep 10;

	["CALL", "deleteClaimedLotteryTickets"] call life_fnc_database_request;
};