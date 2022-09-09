/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
*/

disableSerialization;
if (diag_tickTime - life_var_hud_laststatsrendered_at >= 0.25) then {
	life_var_hud_laststatsrendered_at = diag_tickTime;
	private _display1 = uiNamespace getVariable ["RscPlayerHUD",displayNull];

	//-- Player Events
	(_display1 displayCtrl 1007) ctrlShow (life_var_thirst < 15); 	//-- Thrist Logo
	(_display1 displayCtrl 1002) ctrlShow (life_var_hunger < 15);	//-- Hunger Logo
	(_display1 displayCtrl 1003) ctrlShow life_var_newlife;		//-- Newlife Logo
	(_display1 displayCtrl 1004) ctrlShow life_var_earplugs;	//-- EarPlugs Logo
	(_display1 displayCtrl 1006) ctrlShow life_var_autorun;		//-- Autorun Logo
	(_display1 displayCtrl 1008) ctrlShow life_var_combat;		//-- Combat Logo
	
	//-- Player Stats
	switch (life_var_hud_layer1mode) do {
		case 0: 
		{ 
			//Player Stats 
			(_display1 displayCtrl 1302) ctrlShow true;//-- Hunger
			(_display1 displayCtrl 1303) ctrlShow true;//-- Hunger
			(_display1 displayCtrl 1304) ctrlShow true;//-- Thrist
			(_display1 displayCtrl 1305) ctrlShow true;//-- Thrist
			(_display1 displayCtrl 1306) ctrlShow true;//-- Damage
			(_display1 displayCtrl 1307) ctrlShow true;//-- Damage

			//-- Hunger
			(_display1 displayCtrl 1302) ctrlSetText format ["%1%2", round life_var_hunger, "%"];
			if (life_var_hunger > 25) then{
				(_display1 displayCtrl 1303) ctrlSetTextColor [63/255, 212/255, 252/255, 1];
				(_display1 displayCtrl 1302) ctrlSetTextColor [1, 1, 1, 1];
			}else {
				(_display1 displayCtrl 1303) ctrlSetTextColor [221/255, 38/255, 38/255, 1];
				(_display1 displayCtrl 1302) ctrlSetTextColor [221/255, 38/255, 38/255, 1];
			};

			//-- Thrist
			(_display1 displayCtrl 1304) ctrlSetText format ["%1%2", round life_var_thirst, "%"];
			if (life_var_thirst > 25) then{
				(_display1 displayCtrl 1305) ctrlSetTextColor [63/255, 212/255, 252/255, 1];
				(_display1 displayCtrl 1304) ctrlSetTextColor [1, 1, 1, 1];
			}else {
				(_display1 displayCtrl 1305) ctrlSetTextColor [221/255, 38/255, 38/255, 1];
				(_display1 displayCtrl 1304) ctrlSetTextColor [221/255, 38/255, 38/255, 1];
			};

			//-- Damage
			private _damage = (1 - (damage player)) * 100;
			(_display1 displayCtrl 1306) ctrlSetText format ["%1%2", round _damage, "%"];
			if (_damage > 25) then{
				(_display1 displayCtrl 1307) ctrlSetTextColor [63/255, 212/255, 252/255, 1];
				(_display1 displayCtrl 1306) ctrlSetTextColor [1, 1, 1, 1];
			}else {
				(_display1 displayCtrl 1307) ctrlSetTextColor [221/255, 38/255, 38/255, 1];
				(_display1 displayCtrl 1306) ctrlSetTextColor [221/255, 38/255, 38/255, 1];
			};
		}; 
		case 1: 
		{
			//Player Stats 
			(_display1 displayCtrl 1302) ctrlShow false;//-- Hunger
			(_display1 displayCtrl 1303) ctrlShow false;//-- Hunger
			(_display1 displayCtrl 1304) ctrlShow false;//-- Thrist
			(_display1 displayCtrl 1305) ctrlShow false;//-- Thrist
			(_display1 displayCtrl 1306) ctrlShow false;//-- Damage
			(_display1 displayCtrl 1307) ctrlShow false;//-- Damage  
		 	 
		};
	};
};