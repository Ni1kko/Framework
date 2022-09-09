class RscDisplayDeathScreen
{
	idd=-1;
	movingEnable=0;
  	fadein=0;
	duration = 10e10;
  	fadeout=0;
	name="RscDisplayDeathScreen";
	onLoad = "uiNamespace setVariable ['RscDisplayDeathScreen',_this select 0]";
	onUnload = "uiNamespace setVariable ['RscDisplayDeathScreen', objNull]";
	onDestroy = "uiNamespace setVariable ['RscDisplayDeathScreen', objNull]";
	objects[]={};
	
	class controlsBackground
	{
		class DeathPicture: Life_RscPicture
		{
			idc = -1;
			text = "textures\blood.paa";
			x = 0.2375 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.525 * safezoneW;
			h = 0.7 * safezoneH;
			colorBackground[] = {0,0,0,0};
		};		
	};
	
	class Controls
	{

		class txt_top_left: Life_RscStructuredText
		{
			idc = 66601;
			x = 0 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 0.5 * safezoneW;
			h = 0.11 * safezoneH;
		};
		class txt_top_right: Life_RscStructuredText
		{
			idc = 66602;
			x = 0.5 * safezoneW + safezoneX;
			y = 0 * safezoneH + safezoneY;
			w = 0.5 * safezoneW;
			h = 0.11 * safezoneH;			
		};
		class txt_bottom_left: Life_RscStructuredText
		{
			idc = 66603;
			x = 0 * safezoneW + safezoneX;
			y = 0.89 * safezoneH + safezoneY;
			w = 0.5 * safezoneW;
			h = 0.11 * safezoneH;
			colorBackground[] = {0,0,0,0.5};
		};		
		class txt_bottom_right: Life_RscStructuredText
		{
			idc = 66604;
			x = 0.5 * safezoneW + safezoneX;
			y = 0.89 * safezoneH + safezoneY;
			w = 0.5 * safezoneW;
			h = 0.11 * safezoneH;
			colorBackground[] = {0,0,0,0.5};		
		};	
	};
};