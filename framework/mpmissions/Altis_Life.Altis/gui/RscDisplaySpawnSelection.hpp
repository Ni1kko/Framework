class RscDisplaySpawnSelection
{
    idd = 38500;
    movingEnabled = 0;
    enableSimulation = 1;
    onLoad="uiNamespace setVariable ['RscDisplaySpawnSelection', _this#0];";
    onUnload="uiNamespace setVariable ['RscDisplaySpawnSelection', displayNull]";
    onDestroy="uiNamespace setVariable ['RscDisplaySpawnSelection', displayNull]";

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
        
        class SpawnScreen: Life_RscPicture 
        {
            idc = 38531;
            text = "textures\gui\RscDisplaySpawnSelection\selectionFrame.paa";
            x = 0.190625 * safezoneW + safezoneX;
            y = 0.093 * safezoneH + safezoneY;
            w = 0.629062 * safezoneW;
            h = 0.792 * safezoneH;
        };

        class MapView: Life_RscMapControl 
        {
            idc = 38502;
            colorBackground[] = {
                0,
                0,
                0,
                0.7
            };
            x = 0.37625 * safezoneW + safezoneX;
            y = 0.324 * safezoneH + safezoneY;
            w = 0.376406 * safezoneW;
            h = 0.418 * safezoneH;
            maxSatelliteAlpha = 0.75; //0.75;
            alphaFadeStartScale = 1.15; //0.15;
            alphaFadeEndScale = 1.29; //0.29;
        };
    };

    class controls 
    {
        class SpawnPointList: Life_RscListNBox 
        {
            idc = 38510;
            text = "";
            sizeEx = 0.041;
            coloumns[] = {
                0,
                0,
                0.9
            };
            drawSideArrows = 0;
            idcLeft = -1;
            idcRight = -1;
            rowHeight = 0.050;
            x = 0.247344 * safezoneW + safezoneX;
            y = 0.324 * safezoneH + safezoneY;
            w = 0.12375 * safezoneW;
            h = 0.374 * safezoneH;
            onLBSelChanged = "_this call MPClient_fnc_spawnPointSelected;";
        };

        class spawnButton: Life_RscButtonMenu 
        {
            idc = -1;
            type = 1;
            style = "0x02";
            colorBackground[] = {
                0.03,
                0.55,
                0.95,
                1
            };
            text = "Spawn";
            onButtonClick = "[] call MPClient_fnc_spawnConfirm";
            x = 0.247344 * safezoneW + safezoneX;
            y = 0.709 * safezoneH + safezoneY;
            w = 0.12375 * safezoneW;
            h = 0.033 * safezoneH;
            colorBackgroundActive[] = {
                0.06,
                0.32,
                0.96,
                1
            };
            colorBackgroundDisabled[] = {
                0.95,
                0.95,
                0.95,
                0
            };
            offsetX = 0.003;
            offsetY = 0.003;
            offsetPressedX = 0.002;
            offsetPressedY = 0.002;
            colorShadow[] = {
                0,
                0,
                0,
                1
            };
            colorBorder[] = {
                0,
                0,
                0,
                0
            };
            borderSize = 0.008;
        };
    };
};