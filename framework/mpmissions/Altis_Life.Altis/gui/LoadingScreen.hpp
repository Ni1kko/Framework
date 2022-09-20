class life_Rsc_DisplayLoading : RscDisplayStaticBackground
{
	idd = 8000;
	onLoad = "uiNamespace setVariable [ 'life_Rsc_DisplayLoading', _this select 0 ]; life_var_loadingScreenActive = true;";
	onUnload = "uiNamespace setVariable [ 'life_Rsc_DisplayLoading', displayNull ]; life_var_loadingScreenActive = false;";

	class Controls 
	{
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