#include "\life_backend\script_macros.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/Framework
*/

private _input = param [0, objNull, [objNull,sideUnknown]];

private _string = switch (true) do 
{
   case (_input isKindOf "CAManBase" ): {"Man"};
   case (_input isKindOf "LandVehicle"): {"Car"};
   case (_input isKindOf "Air"): {"Air"};
   case (_input isKindOf "Ship"): {"Ship"};
   case (_input isKindOf "House"): {"House"};
   case (_input isKindOf "Fish_Base_F"):
   {
      switch (typeOf _input) do 
      {
         case "Salema_F":           {"Fish"};
         case "Ornate_random_F" :   {"Fish"};
         case "Mackerel_F" :        {"Fish"};
         case "Tuna_F" :            {"Fish"};
         case "Mullet_F" :          {"Fish"};
         case "CatShark_F" :        {"Fish"};
         case "Turtle_F" :          {"Turtle"};
         default {TYPE_NOT_FOUND};
      };
   };
   case (_input isKindOf "Box_IND_Grenades_F"): {"CargoStorageSmall"};
   case (_input isKindOf "B_supplyCrate_F"): {"CargoStorageLarge"};
   default {TYPE_NOT_FOUND};
};

_string