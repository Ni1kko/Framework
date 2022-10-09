#include "..\..\clientDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
	## fn_inventoryWalletPlayersComboSelChanged.sqf
*/


disableSerialization;

params [
	["_control", controlNull, [controlNull]],
	["_selectedIndex", -1, [0]]
];

hint format ["fn_inventoryWalletPlayersComboSelChanged\n%1", str _this];