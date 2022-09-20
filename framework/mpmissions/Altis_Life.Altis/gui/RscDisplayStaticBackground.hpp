class RscDisplayStaticBackground
{

	idd = 8100;
	onLoad = "uiNamespace setVariable [ 'life_Rsc_DisplayStatic', _this select 0 ]";
	onUnload = "uiNamespace setVariable [ 'life_Rsc_DisplayStatic', displayNull ]";
	fadein = 0;
	duration = 1e+011;
	fadeout = 0;

	class controlsBackground 
	{
		class Background: Life_RscText 
		{

			idc = 1;
			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";
			colorBackground[] = { 0, 0, 0, 1 };
		};

		class SplashNoise: Life_RscPicture 
		{
			idc = 2;
			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";
			text = "\A3\Ui_f\data\IGUI\RscTitles\SplashArma3\arma3_splashNoise_ca.paa";
		};
	};
};