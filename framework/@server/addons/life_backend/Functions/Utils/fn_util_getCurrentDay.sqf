/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/


private _dateTime = "extDB3" callExtension "9:LOCAL_TIME";
_dateTime = (call compile _dateTime)#1;
/*
   //TODO: use this command for _dateTime
   systemTimeUTC params ["_year","_month","_day","_hour","_minute","_second"]; 
*/

private _daynameQuery = [format["SELECT DAYNAME('%1-%2-%3')",_dateTime#0, _dateTime#1, _dateTime#2],2] call DB_fnc_asyncCall;

_daynameQuery params [
   ["_dayname", "", [""]]
];

_dayname = toUpper _dayname;

if !(_dayname in ["MONDAY","TUESDAY","WEDNESDAY","THURSDAY","FRIDAY","SATURDAY","SUNDAY"]) then {
   _dayname = "Error";
};

_dayname