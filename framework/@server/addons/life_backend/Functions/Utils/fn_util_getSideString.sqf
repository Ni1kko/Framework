/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _side = param [0, player, [objNull,sideUnknown]];
private _shortName = param [1, false, [false]];
 
if(typeName _side isEqualTo "OBJECT")then{
   
   if(isNull _object) then {
      _side = sideUnknown;
   }else{ 
      _side = side _side;
   };
};

private _string = switch _side do 
{
   case civilian: {['civilian', 'civ'] select _shortName};
   case west:{['west', 'cop'] select _shortName};
   case east:{['east', 'reb'] select _shortName};
   case independent:{['independent', 'med'] select _shortName};
   default{['unknown' ''] select _shortName};
};

_string