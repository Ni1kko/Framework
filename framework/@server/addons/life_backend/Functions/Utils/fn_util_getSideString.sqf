/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _input = param [0, player, [objNull,sideUnknown]];
private _shortName = param [1, false, [false]];
private _side = (if(typeName _input isEqualTo "OBJECT")then{if(isNull _input)then{sideUnknown}else{side _input}}else{_input});

private _string = switch _side do 
{
   case civilian: {['civilian', 'civ'] select _shortName};
   case west:{['west', 'cop'] select _shortName};
   case east:{['east', 'reb'] select _shortName};
   case independent:{['independent', 'med'] select _shortName};
   default{['unknown' ''] select _shortName};
};

_string