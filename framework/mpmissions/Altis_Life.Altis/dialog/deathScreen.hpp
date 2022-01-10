class DeathScreen
{
	idd = 7300;
	name = "Life_Death_Screen";
	movingEnable = 0;
    enableSimulation = 1;

	class controlsBackground {
		class RscText_1000: Life_RscText
			{
				idc = -1;
				x = 0.29375 * safezoneW + safezoneX;
				y = 0.00500001 * safezoneH + safezoneY;
				w = 0.4125 * safezoneW;
				h = 0.165 * safezoneH;
				colorBackground[] = {0,0,0,0.7};
				colorActive[] = {0,0,0,0.7};
			};
		class RscText_1001: Life_RscText
		{
			idc = -1;
			text = "You have been killed, here's how:"; //--- ToDo: Localize;
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.00500001 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.022 * safezoneH;
			colorBackground[] = {0,0,0,1};
			colorActive[] = {0,0,0,1};
			class Attributes
			{
				align = "center";
			};
		};
	};
	class controls {

		  class MedicsOnline: Life_RscText {
            idc = 7304;
            colorBackground[] = {0,0,0,0};
            text = "Medics Online: 1";
            x = 0.005 * safezoneW + safezoneX;
            y = 0.015 * safezoneH + safezoneY;
            w = 0.8;
            h = (1 / 25);
        };

        class MedicsNearby: Life_RscText {
            idc = 7305;
            colorBackground[] = {0,0,0,0};
            text = "Medics Nearby: No";
            x = 0.005 * safezoneW + safezoneX;
            y = 0.040 * safezoneH + safezoneY;
            w = 0.8;
            h = (1 / 25);
        };
		class RscText_1002: Life_RscText
		{
			idc = 7310;
			text = "Killed by:"; //--- ToDo: Localize;
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.038 * safezoneH + safezoneY;
			w = 0.402187 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				align = "center";
			};
		};
		class RscText_1003: LIfe_RscText
		{
			idc = 7311;
			text = "Weapon:"; //--- ToDo: Localize;
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.071 * safezoneH + safezoneY;
			w = 0.402187 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				align = "center";
			};
		};
		class RscText_1004: Life_RscText
		{
			idc = 7312;
			text = "Distance: "; //--- ToDo: Localize;
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.104 * safezoneH + safezoneY;
			w = 0.402187 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				align = "center";
			};
		};
		class RscText_1005: Life_RscText
		{
			idc = 7301;
			text = "Respawn Timer"; //--- ToDo: Localize;
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.137 * safezoneH + safezoneY;
			w = 0.402187 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				align = "center";
			};
		};
		class RscButtonMenu_2400: Life_RscButtonMenu
		{
			idc = 7303;
			text = "Request Medic"; //--- ToDo: Localize;
			onButtonClick = "[] call life_fnc_requestMedic;";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.17 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				align = "center";
			};
		};
		class RscButtonMenu_2401: Life_RscButtonMenu
		{
			idc = 7302;
			text = "Start New Life"; //--- ToDo: Localize;
			onButtonClick = "closeDialog 0; life_respawned = true; [] call life_fnc_spawnMenu;";
			x = 0.5 * safezoneW + safezoneX;
			y = 0.17 * safezoneH + safezoneY;
			w = 0.20625 * safezoneW;
			h = 0.022 * safezoneH;
			class Attributes
			{
				align = "center";
			};
		};
	};
};