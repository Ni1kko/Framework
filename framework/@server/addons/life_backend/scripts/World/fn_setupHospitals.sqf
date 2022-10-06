#include "\life_backend\serverDefines.hpp"
/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

{
    private _middle = createVehicle ["Land_Hospital_main_F", [0,0,0], [], 0, "NONE"];
    _middle setDir (markerDir _x);
    _middle setPosATL (getMarkerPos _x);

    private _left = createVehicle ["Land_Hospital_side1_F", [0,0,0], [], 0, "NONE"];
    _left attachTo [_middle, [4.69775,32.6045,-0.1125]];
    detach _left;

    private _right = createVehicle ["Land_Hospital_side2_F", [0,0,0], [], 0, "NONE"];
    _right attachTo [_middle, [-28.0336,-10.0317,0.0889387]];
    detach _right;

    if (worldName isEqualTo "Tanoa") then {
		switch _x do {
			case "hospital_2": 
			{ 
				atm_hospital_2 setPos (_right modelToWorld [4.48633,0.438477,-8.25683]);
				vendor_hospital_2 setPos (_right modelToWorld [4.48633,0.438477,-8.25683]);
				"medic_spawn_3" setMarkerPos (_right modelToWorld [8.01172,-5.47852,-8.20022]);
				"med_car_2" setMarkerPos (_right modelToWorld [8.01172,-5.47852,-8.20022]);
				hospital_assis_2 setPos (_middle modelToWorld [0.0175781,0.0234375,-0.231956]);
			};
			case "hospital_3": 
			{ 
				atm_hospital_3 setPos (_right modelToWorld [4.48633,0.438477,-8.25683]);
				vendor_hospital_3 setPos (_right modelToWorld [4.48633,0.438477,-8.25683]);
				"medic_spawn_1" setMarkerPos (_right modelToWorld [-1.85181,-6.07715,-8.24944]);
				"med_car_1" setMarkerPos (_right modelToWorld [5.9624,11.8799,-8.28493]);
				hospital_assis_2 setPos (_middle modelToWorld [0.0175781,0.0234375,-0.231956]);
			};
		}; 
    };
} forEach ["hospital_2","hospital_3"];
