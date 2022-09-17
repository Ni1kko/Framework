/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

//-- Wait for ranks to be set
waitUntil {(missionNamespace getVariable ["life_session_completed",false])};

//-- Get ranks
private _adminlevel = call (missionNamespace getVariable ["life_adminlevel",{0}]);
private _donorlevel = call (missionNamespace getVariable ["life_donorlevel",{0}]);
private _policeRank = call (missionNamespace getVariable ["life_coplevel",{0}]);
private _medicRank =  call (missionNamespace getVariable ["life_medLevel",{0}]);
private _rebelRank =  call (missionNamespace getVariable ["life_reblevel",{0}]);
private _civJobRank = call (missionNamespace getVariable ["life_joblevel",{0}]);

//--
private _lastUniform = "";
private _lastUniformTextures = [];
private _lastVest = "";
private _lastVestTextures = [];
private _lastBackpack = "";
private _lastBackpackTextures = [];
private _lastPlayerSide = playerSide;

while{true}do
{
	//-- Wait for change
	waitUntil {
		uiSleep 0.2;
		playerSide isNotEqualTo _lastPlayerSide 
		OR {(uniform player) isNotEqualTo _lastUniform
		OR {(getObjectTextures(uniformContainer player)) isNotEqualTo _lastUniformTextures 
		OR {(vest player) isNotEqualTo _lastVest 
		OR {(getObjectTextures(vestContainer player)) isNotEqualTo _lastVestTextures 
		OR {(backpack player) isNotEqualTo _lastBackpack
		OR {(getObjectTextures(backpackContainer player)) isNotEqualTo _lastBackpackTextures	
	}}}}}}};

	//-- Re-texturing
	switch (true) do
	{
		//-- Handle uniforms
		case (getObjectTextures(uniformContainer player) isNotEqualTo _lastUniformTextures OR (uniform player) isNotEqualTo _lastUniform): 
		{ 
			private _defaultTextures = getArray(configFile >> "CfgWeapons" >> (uniform player) >> "hiddenSelectionsTextures");
			private _uniformTexture = (switch (uniform player) do 
			{
				//-- Police Uniforms (1 - 7)
				case "U_Rangemaster": 
				{ 
					switch (side player) do 
					{ 
						case west:          {format["textures\police\uniforms\uniform%1",[".paa",format["_%1.jpg",_policeRank]] select (_policeRank >= 1 AND _policeRank <= 7)]};
						case independent:	{format["textures\medic\uniforms\uniform%1", [".jpg",format["_%1.jpg",_medicRank]] select (_medicRank >= 1 AND _medicRank <= 5)]};
						default 			{""};
					};
				}; 
				//-- Police Uniforms (8 - 9) NPAS & RTU 
				case "U_O_OfficerUniform_ocamo": 
				{ 
					switch (side player) do 
					{ 
						case west:          {format["textures\police\uniforms\uniform%1",["_9.paa",format["_8.jpg",_policeRank]] select (_policeRank isEqualTo 8)]};
						default 			{""};
					};
				};
				//-- Police Uniforms (10 - 14)
				case "U_OG_Guerrilla_6_1": 
				{ 
					switch (side player) do 
					{ 
						case west:          {format["textures\police\uniforms\uniform%1.jpg",["_10",format["_%1",_policeRank]] select (_policeRank >= 10 AND _policeRank <= 14)]};
						default 			{""};
					};
				};
				case "U_C_Poloshirt_blue": 			{"textures\civilian\uniforms\uniform_1.paa"};
				case "U_C_Poloshirt_burgundy": 	    {"textures\civilian\uniforms\uniform_2.paa"};
				case "U_C_Poloshirt_stripped": 	    {"textures\civilian\uniforms\uniform_3.paa"};
				case "U_C_Poloshirt_tricolour": 	{"textures\civilian\uniforms\uniform_4.paa"};
				case "U_C_Poloshirt_salmon": 		{"textures\civilian\uniforms\uniform_5.paa"};
				case "U_C_Poloshirt_redwhite": 	    {"textures\civilian\uniforms\uniform_6.paa"};
				case "U_C_Commoner1_1": 			{"textures\civilian\uniforms\uniform_7.paa"};
				case "U_B_CombatUniform_mcam_worn": {"textures\civilian\uniforms\uniform_bountyhunter.paa"};
				default 							{""};
			});

			if(_adminlevel >= 1) then 
			{
				private _customTexture = player getVariable ["customUniformTexture", ""]; 
				if(count _customTexture > 0) then {
					_uniformTexture = _customTexture;
				};
			};

			if(count _uniformTexture > 0) then {
				(uniformContainer player) setObjectTextureGlobal [0, _uniformTexture];
			}else{
				{(uniformContainer player) setObjectTextureGlobal [_forEachIndex, _x]}forEach _defaultTextures;
			};
			
			_lastUniformTextures = getObjectTextures(uniformContainer player);
			_lastUniform = uniform player;
		};
		//-- Handle vests
		case (getObjectTextures(vestContainer player) isNotEqualTo _lastVestTextures OR (vest player) isNotEqualTo _lastVest):
		{
			private _defaultTextures = getArray(configFile >> "CfgWeapons" >> (vest player) >> "hiddenSelectionsTextures");
			private _vestTexture = (switch (side player) do 
			{
				case independent:	{"textures\medic\vests\carry-rig.paa"};
				default 			{""};
			});

			if(_adminlevel >= 1) then 
			{
				private _customTexture = player getVariable ["customVestTexture", ""]; 
				if(count _customTexture > 0) then {
					_vestTexture = _customTexture;
				};
			};

			if(count _vestTexture > 0) then {
				(vestContainer player) setObjectTextureGlobal [0, _vestTexture];
			}else{
				{(vestContainer player) setObjectTextureGlobal [_forEachIndex, _x]}forEach _defaultTextures;
			};

			_lastVestTextures = getObjectTextures (vestContainer player);
			_lastVest = vest player;
		};
		//-- Handle backpacks
		case (getObjectTextures(backpackContainer player) isNotEqualTo _lastBackpackTextures OR (backpack player) isNotEqualTo _lastBackpack):
		{
			private _defaultTextures = getArray(configFile >> "CfgVehicles" >> (backpack player) >> "hiddenSelectionsTextures");
			private _backpackTexture = (switch (side player) do 
			{
				case west:			{"Invisible"};
				case independent:	{"Invisible"};
				default 			{""};
			});

			if(_adminlevel >= 1) then 
			{
				private _customTexture = player getVariable ["customBackpackTexture", "Invisible"];
				if(count _customTexture > 0) then {
					_backpackTexture = _customTexture;
				};
			};

			if(count _backpackTexture > 0) then {
				//Load custom or invisible texture
				(backpackContainer player) setObjectTextureGlobal [0, [_backpackTexture, ""] select (_backpackTexture isEqualTo "Invisible")];
			}else{
				//Reload default textures (need for if player switches side without droping gear)
				{(backpackContainer player) setObjectTextureGlobal [_forEachIndex, _x]}forEach _defaultTextures;
			};
			
			_lastBackpackTextures = getObjectTextures (backpackContainer player);
			_lastBackpack = backpack player;
		};
	};
	 
	_lastPlayerSide = playerSide;
};

false