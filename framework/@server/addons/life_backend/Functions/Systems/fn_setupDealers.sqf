/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _everyXmins = 30;
private _drugDealers = [
	"Dealer_1",
	"Dealer_2",
	"Dealer_3"
];

while {true} do {
	uiSleep (_everyXmins * 60);
	{
		private _dealer = missionNamespace getVariable [_x, objNull];

		if(!isNull _dealer)then{
			_dealer setVariable ["sellers",[],true];	
		};
	} forEach _drugDealers;
};

false