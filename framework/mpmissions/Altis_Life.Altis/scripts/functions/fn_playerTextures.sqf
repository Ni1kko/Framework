/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

private _lastUniformTextures = [];
private _side = playerSide;

private _adminlevel = call life_adminlevel;
private _donorlevel = call life_donorlevel;
private _policeRank = call life_coplevel;
private _medicRank = call life_medLevel;
private _rebelRank = call life_reblevel;
private _civJobRank = call life_joblevel;

//-- Handle backpacks
[]spawn {
	private _side = playerSide;
	private _backpack = unitBackpack player;
	while{true}do
	{ 
		waitUntil {(playerSide isNotEqualTo _side) OR (unitBackpack player isNotEqualTo _backpack)};

		if(playerSide in [west,independent]) then {
			(unitBackpack player) setObjectTextureGlobal [0,""];
		};

		_backpack = unitBackpack player;
		_side = playerSide;
	};
};

//-- Handle vests
[]spawn {
	private _side = playerSide;
	private _vest = vestContainer player;
	while{true}do
	{ 
		waitUntil {(playerSide isNotEqualTo _side) OR (vestContainer player isNotEqualTo _vest)};

		if(playerSide isEqualTo independent) then {
			(vestContainer player) setObjectTextureGlobal [0, "textures\medic\vests\carry-rig.paa"];
		};

		_vest = vestContainer player;
		_side = playerSide;
	};
};

//-- Handle uniforms
while{true}do
{ 
	waitUntil {(playerSide isNotEqualTo _side) OR ((getObjectTextures player) isNotEqualTo _lastUniformTextures)};
		
	private _texture = (switch (uniform player) do 
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
		case "U_C_Poloshirt_blue": 			{"textures\civilian\uniforms\uniform_1.jpg"};
		case "U_C_Poloshirt_burgundy": 	    {"textures\civilian\uniforms\uniform_2.jpg"};
		case "U_C_Poloshirt_stripped": 	    {"textures\civilian\uniforms\uniform_3.jpg"};
		case "U_C_Poloshirt_tricolour": 	{"textures\civilian\uniforms\uniform_4.jpg"};
		case "U_C_Poloshirt_salmon": 		{"textures\civilian\uniforms\uniform_5.jpg"};
		case "U_C_Poloshirt_redwhite": 	    {"textures\civilian\uniforms\uniform_6.jpg"};
		case "U_C_Commoner1_1": 			{"textures\civilian\uniforms\uniform_7.jpg"};
		case "U_B_CombatUniform_mcam_worn": {"textures\civilian\uniforms\uniform_bountyhunter.paa"};
        default 							{""};
	});
 
    if(count _texture > 0) then {
        player setObjectTextureGlobal [0, _texture];
    };
	
	_lastUniformTextures = getObjectTextures player;
	_side = playerSide;
};

false