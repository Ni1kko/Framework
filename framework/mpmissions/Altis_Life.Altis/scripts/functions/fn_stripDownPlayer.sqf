/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

params [
    ["_player", player, [objNull]],
    ["_isDead", false, [false]]
];

private _headMountedGear = hmd _player;
private _headGear = headgear _player;
private _goggles = goggles _player;
private _backpack = backpack _player;
private _vest = vest _player;
private _uniform = uniform _player;
private _weapons = weapons _player;
private _magazines = magazines _player;
private _assignedItems = assignedItems _player;
private _currentWeapon = currentWeapon _player;
 
//-- Drop stuff
if _isDead then 
{
    private _weaponHolderDir = random(360);            // Get a random direction for the weapon holder
    private _weaponHolderSpeed = 1.5;                  // Set the speed of the weapon holder
    
    if (count _currentWeapon > 0)then
    {
        //-- Create weapon holder to drop weapon.
        private _weaponHolderIndex = life_var_weaponHolders pushBackUnique ("WeaponHolderSimulated" createVehicle [0,0,0]);//"GroundWeaponHolder_Scripted"

        if(_weaponHolderIndex isNotEqualTo -1)then
        {
            private _weaponHolder = life_var_weaponHolders#_weaponHolderIndex;

            if(!isNull _weaponHolder)then
            {  
                //-- Prevent player coliding with weapon holder.
                _weaponHolder disableCollisionWith _player;

                //-- Position weapon holder near hands.
                _weaponHolder setPos (_player modelToWorld [0,.2,1.2]);

                //-- Drop weapon.
                _player action ["DropWeapon", _currentWeapon, _currentWeapon];

                //-- Clear weapon name now its dropped.
                _currentWeapon = "";
                
                //-- Set weapon holder fall velocity in m/s.
                _weaponHolder setVelocity [_weaponHolderSpeed * sin(_weaponHolderDir), _weaponHolderSpeed * cos(_weaponHolderDir),4];
            };
        };
    };

    //-- Drop virtual items
    [_player] call MPClient_fnc_dropItems;

    //-- Save loadout array after dropping weapon.
    life_var_gearWhenDied = getUnitLoadout _player;
};

//-- Remove head mounted gear
if (count _headMountedGear > 0) then {_player unlinkItem _headMountedGear};

//-- Remove head gear
if (count _headGear > 0) then {removeHeadGear _player};

//-- Remove goggles
if (count _goggles > 0) then {removeGoggles _player};

//-- Remove backpack
if (count _backpack > 0) then {removeBackpack _player}; 

//-- Remove vest
if (count _vest > 0) then {removeVest _player};

//-- Remove uniform
if (count _uniform > 0) then {removeUniform _player};

//-- Remove weapons
if (count _weapons > 0) then {removeAllWeapons _player};

//-- Remove magazines
if (count _magazines > 0) then {{_player removeMagazines _x} forEach _magazines};

//-- Remove assigned items
if (count _assignedItems > 0) then {{_player unassignItem _x; _player removeItem _x} forEach _assignedItems};

//--- Reset Carry Weight
life_maxWeight =  getNumber(missionConfigFile >> "Life_Settings" >> "total_maxWeight");

true