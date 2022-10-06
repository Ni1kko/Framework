class RscDisplayLoadingScreen
{
	idd = 8000;
	onLoad = "uiNamespace setVariable ['RscDisplayLoadingScreen', _this#0]; life_var_loadingScreenActive = true;";
	onUnload = "uiNamespace setVariable ['RscDisplayLoadingScreen', displayNull]; life_var_loadingScreenActive = false;";
    onDestroy="uiNamespace setVariable ['RscDisplayLoadingScreen', displayNull]; life_var_loadingScreenActive = false;";
	
	class Controls 
	{
		class Background: RscDefineText 
		{

			idc = 1;
			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";
			colorBackground[] = { 0, 0, 0, 1 };
		};

		class SplashNoise: RscDefinePicture 
		{
			idc = 2;
			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";
			text = "\A3\Ui_f\data\IGUI\RscTitles\SplashArma3\arma3_splashNoise_ca.paa";
		};

		class Message 
		{
			idc = 100;
			style = "1 + 16";
			type = 13;
			x = 0;
			y = 0.2;
			w = 1;
			h = 10000;
			size = "(0.05 / 1.17647) * safezoneH";
			sizeEx = 0.4;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			shadow = 1;
			text = "";
			class Attributes
			{
				align = "center";
				valign = "top";
			};
		};
	};
};