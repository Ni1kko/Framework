 
class life_Rsc_DisplayLoading {

	idd = 8000;
	onLoad = "uiNamespace setVariable [ 'life_Rsc_DisplayLoading', _this select 0 ]";
	fadein = 0;
	duration = 1e+011;
	fadeout = 0;

	class Controls {

		class Background: Life_RscText {

			idc = -1;

			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";

			colorBackground[] = { 0, 0, 0, 1 };

		};

		class SplashNoise: Life_RscPicture {

			idc = -1;

			x = "safezoneXAbs";
			y = "safezoneY";
			w = "safezoneWAbs";
			h = "safezoneH";

			text = "\A3\Ui_f\data\IGUI\RscTitles\SplashArma3\arma3_splashNoise_ca.paa";

		};

		class Message {

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

			class Attributes {

				align = "center";
				valign = "top";

			};

		};

	};

};