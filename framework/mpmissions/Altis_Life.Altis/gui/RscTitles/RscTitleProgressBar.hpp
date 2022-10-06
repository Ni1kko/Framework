/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## RscTitleProgressBar.hpp
*/

class RscTitleProgressBar 
{ 
    idd = 11203;
    duration = INFINTE;
    fadein=0;
    fadeout=0;
    movingEnable = 0;
    onLoad="uiNamespace setVariable ['RscTitleProgressBar',_this select 0]";
    onUnload="uiNamespace setVariable ['RscTitleProgressBar', displayNull]";
    onDestroy="uiNamespace setVariable ['RscTitleProgressBar', displayNull]";

    objects[]={};

    class controlsBackground {
        class background: RscDefineText {
            idc = -1;
            colorBackground[] = {0,0,0,0.7};
            x = 0.38140 * safezoneW + safezoneX;
            y = 0.06 * safezoneH + safezoneY;
            w = 0.65;
            h = 0.05;
        };
        class ProgressBar: RscDefineProgressBar {
            idc = 38201;
            x = 0.38140 * safezoneW + safezoneX;
            y = 0.06 * safezoneH + safezoneY;
            w = 0.65;
            h = 0.05;
        };

        class ProgressText: RscDefineText {
            idc = 38202;
            text = "Servicing Chopper (50%)...";
            x = 0.386 * safezoneW + safezoneX;
            y = 0.0635 * safezoneH + safezoneY;
            w = 0.65;
            h = (1 / 25);
        };
    };
};

class life_timer {
    name = "life_timer";
    idd = 38300;
    fadeIn = 1;
    duration = 99999999999;
    fadeout = 1;
    movingEnable = 0;
    onLoad = "uiNamespace setVariable ['life_timer',_this select 0]";
    objects[] = {};

    class controlsBackground {
        class TimerIcon: RscDefinePicture {
            idc = -1;
            text = "\a3\ui_f\data\IGUI\RscTitles\MPProgress\timer_ca.paa";
            x = 0.00499997 * safezoneW + safezoneX;
            y = 0.291 * safezoneH + safezoneY;
            w = 0.04;
            h = 0.045;
        };

        class TimerText: RscDefineText {
            colorBackground[] = {0,0,0,0};
            idc = 38301;
            text = "";
            x = 0.0204688 * safezoneW + safezoneX;
            y = 0.2778 * safezoneH + safezoneY;
            w = 0.09125 * safezoneW;
            h = 0.055 * safezoneH;
        };
    };
};