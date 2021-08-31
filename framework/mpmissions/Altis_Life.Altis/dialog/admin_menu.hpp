class RscDisplayAdminMenu
{
	idd = 1776;
	movingEnable = 1;
	enableSimulation = 1;
	class controlsBackground{};
	class Controls
	{
		class RscMainList: Life_RscListBox
		{
			idc = 1776;
			x = "0 * safezoneW + safezoneX";
			y = "0.04 * safezoneH + safezoneY";
			w = "0.2 * safezoneW";
			h = "0.96 * safezoneH";
			rowHeight = 0;
			sizeEx = 0.034;
			type = 5;
			colorText[] = {1,1,1,1};
			colorScrollbar[] = {1,1,1,1};
			colorBackground[] = {0.12,0.12,0.12,1};
			class ListScrollBar: Life_RscScrollBar
			{
				vspacing = 0;
				color[] = {1,1,1,1};
			};
		};
		class RscTitleBar: Life_RscStructuredText
		{
			idc = 1777;
			colorBackground[] = {0.1,0.1,0.1,1};
			text = "<t size='1.5' align='center' color='#FFFFFF'>Admin Menu</t>";
			x = "0 * safezoneW + safezoneX";
			y = "0 * safezoneH + safezoneY";
			w = "1 * safezoneW";
			h = "0.04 * safezoneH";
		};
		class RscPlayerList: RscMainList
		{
			idc = 1778;
			x = "0.2 * safezoneW + safezoneX";
			y = "0.04 * safezoneH + safezoneY";
			w = "0.15 * safezoneW";
			h = "0.48 * safezoneH";
		};
		class RscObjectList: RscMainList
		{
			idc = 1780;
			x = "0.35 * safezoneW + safezoneX";
			y = "0.04 * safezoneH + safezoneY";
			w = "0.15 * safezoneW";
			h = "0.48 * safezoneH";
		};
		class RscLogList: RscMainList
		{
			idc = 1781;
			x = "0.536094 * safezoneW + safezoneX";
			y = "0.093 * safezoneH + safezoneY";
			w = "0.433125 * safezoneW";
			h = "0.869 * safezoneH";
		};
		class RscMap_2201: Life_RscMapControl
		{
			idc = 1779;
			x = "0.2 * safezoneW + safezoneX";
			y = "0.517 * safezoneH + safezoneY";
			w = "0.3 * safezoneW";
			h = "0.49 * safezoneH";
		};
	};
};