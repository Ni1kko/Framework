/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## RscTitleHUD.hpp
*/

class RscTitleHUD
{
    idd = 11201;
    duration = INFINTE;
    fadein=1;
    fadeout=1;
    onLoad="uiNamespace setVariable ['RscTitleHUD', _this#0];";
    onUnload="uiNamespace setVariable ['RscTitleHUD', displayNull]";
    onDestroy="uiNamespace setVariable ['RscTitleHUD', displayNull]";

    class controls
    {
        class Grenade: RscDefineControlsGroup
        {
            idc=1400;
            x="(safezoneX + safezoneW) - 256 * pixelW - 60 * pixelW";
            y="(safezoneY + safezoneH) - 128 * pixelH - 60 * pixelH";
            w="256 * pixelW";
            h="128 * pixelH";
            show="false";
            class controls
            {
                class WeaponBackground: RscDefinePictureKeepAspect
                {
                    idc=1401;
                    x=0;
                    y=0;
                    w="256 * pixelW";
                    h="128 * pixelH";
                    colorText[]={1,1,1,1};
                    text="textures\gui\RscTitles\RscTitleHUD\hud_panel_grenade_ca.paa";
                };
                class Ammo: RscDefineText
                {
                    idc=1402;
                    x="256 * pixelW - 55 * pixelW";
                    y="128 * pixelH - 95 * pixelH";
                    w="45 * pixelW";
                    h="35 * pixelH";
                    colorText[]={1,1,1,1};
                    text="";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="29 * pixelH";
                };
                class TypeSingleLine: RscDefineText
                {
                    idc=1403;
                    x="256 * pixelW - 115 * pixelW";
                    y="128 * pixelH - 95 * pixelH";
                    w="60 * pixelW";
                    h="35 * pixelH";
                    colorText[]=
                    {
                        "63/255",
                        "212/255",
                        "252/255",
                        1
                    };
                    text="RGO";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=1;
                    style=1;
                    sizeEx="11 * pixelH";
                    show="false";
                };
                class TypeDoubleLine1: RscDefineText
                {
                    idc=1404;
                    x="256 * pixelW - 115 * pixelW";
                    y="128 * pixelH - 90 * pixelH";
                    w="60 * pixelW";
                    h="15 * pixelH";
                    colorText[]=
                    {
                        "63/255",
                        "212/255",
                        "252/255",
                        1
                    };
                    text="RGO";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=1;
                    style=1;
                    sizeEx="11 * pixelH";
                    show="false";
                };
                class TypeDoubleLine2: RscDefineText
                {
                    idc=1405;
                    x="256 * pixelW - 115 * pixelW";
                    y="128 * pixelH - 80 * pixelH";
                    w="60 * pixelW";
                    h="15 * pixelH";
                    colorText[]=
                    {
                        "63/255",
                        "212/255",
                        "252/255",
                        1
                    };
                    text="RGO";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=1;
                    style=1;
                    sizeEx="11 * pixelH";
                    show="false";
                };
            };
        };
        class Weapon: RscDefineControlsGroup
        {
            idc=1100;
            x="(safezoneX + safezoneW) - 256 * pixelW - 60 * pixelW";
            y="(safezoneY + safezoneH) - 128 * pixelH - 60 * pixelH";
            w="256 * pixelW";
            h="128 * pixelH";
            class controls
            {
                class WeaponBackground: RscDefinePictureKeepAspect
                {
                    idc=1101;
                    x=0;
                    y=0;
                    w="256 * pixelW";
                    h="128 * pixelH";
                    colorText[]={1,1,1,1};
                    text="textures\gui\RscTitles\RscTitleHUD\hud_panel_weapon_ca.paa";
                };
                class Ammo: RscDefineText
                {
                    idc=1102;
                    x="256 * pixelW - 235 * pixelW";
                    y="128 * pixelH - 50 * pixelH";
                    w="125 * pixelW";
                    h="50 * pixelH";
                    colorText[]={1,1,1,1};
                    text="30";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="50 * pixelH";
                };
                class Magazines: RscDefineText
                {
                    idc=1104;
                    x="256 * pixelW - 115 * pixelW";
                    y="128 * pixelH - 40 * pixelH";
                    w="55 * pixelW";
                    h="30 * pixelH";
                    colorText[]={1,1,1,1};
                    text="2";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=0;
                    sizeEx="30 * pixelH";
                };
                class Zeroing: RscDefineText
                {
                    idc=1105;
                    x="256 * pixelW - 55 * pixelW - 10 * pixelW";
                    y="128 * pixelH - 45 * pixelH";
                    w="55 * pixelW";
                    h="20 * pixelH";
                    colorText[]=
                    {
                        "111/255",
                        "113/255",
                        "122/255",
                        1
                    };
                    text="100m";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="18 * pixelH";
                };
                class FireMode: RscDefineText
                {
                    idc=1103;
                    x="256 * pixelW - 60 * pixelW - 10 * pixelW";
                    y="128 * pixelH - 25 * pixelH";
                    w="60 * pixelW";
                    h="20 * pixelH";
                    colorText[]=
                    {
                        "111/255",
                        "113/255",
                        "122/255",
                        1
                    };
                    text="SEMI";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="18 * pixelH";
                };
            };
        };
        class Vehicle: RscDefineControlsGroup
        {
            idc=1200;
            x="(safezoneX + safezoneW) - 256 * pixelW - 60 * pixelW";
            y="(safezoneY + safezoneH) - 128 * pixelH - 60 * pixelH";
            w="256 * pixelW";
            h="128 * pixelH";
            class controls
            {
                class VehicleBackground: RscDefinePictureKeepAspect
                {
                    idc=1201;
                    x=0;
                    y=0;
                    w="256 * pixelW";
                    h="128 * pixelH";
                    colorText[]={1,1,1,1};
                    text="textures\gui\RscTitles\RscTitleHUD\hud_panel_weapon_ca.paa";
                };
                class Speed: RscDefineText
                {
                    idc=1202;
                    x="256 * pixelW - 235 * pixelW";
                    y="128 * pixelH - 50 * pixelH";
                    w="125 * pixelW";
                    h="50 * pixelH";
                    colorText[]={1,1,1,1};
                    text="30";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="50 * pixelH";
                };
                class Height: RscDefineText
                {
                    idc=1203;
                    x="256 * pixelW - 55 * pixelW - 10 * pixelW";
                    y="128 * pixelH - 45 * pixelH";
                    w="55 * pixelW";
                    h="20 * pixelH";
                    colorText[]=
                    {
                        "111/255",
                        "113/255",
                        "122/255",
                        1
                    };
                    text="100m";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="18 * pixelH";
                    show="false";
                };
                class Fuel: RscDefineText
                {
                    idc=1204;
                    x="256 * pixelW - 100 * pixelW - 10 * pixelW";
                    y="128 * pixelH - 25 * pixelH";
                    w="100 * pixelW";
                    h="20 * pixelH";
                    colorText[]=
                    {
                        "111/255",
                        "113/255",
                        "122/255",
                        1
                    };
                    text="";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="18 * pixelH";
                };
            };
        };
        class Stats: RscDefineControlsGroup
        {
            idc=1300;
            x="safeZoneX + 60 * pixelW";
            y="(safeZoneY + safeZoneH) - 60 * pixelH - 64 * pixelH";
            w="256 * pixelW";
            h="64 * pixelH";
            class controls
            {
                class StatsBackground: RscDefinePictureKeepAspect
                {
                    idc=1301;
                    x=0;
                    y=0;
                    w="256 * pixelW";
                    h="64 * pixelH";
                    colorText[]={1,1,1,1};
                    text="textures\gui\RscTitles\RscTitleHUD\hud_panel_player_ca.paa";
                };
                class HungerLabel: RscDefineText
                {
                    idc=1303;
                    x="10 * pixelW";
                    y="64 * pixelH - 35 * pixelH";
                    w="70 * pixelW";
                    h="20 * pixelH";
                    colorText[]=
                    {
                        "63/255",
                        "212/255",
                        "252/255",
                        1
                    };
                    text="HUNGER";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=0;
                    sizeEx="11 * pixelH";
                }; 
                class Hunger: RscDefineText
                {
                    idc=1302;
                    x="85 * pixelW";
                    y="64 * pixelH - 35 * pixelH"; 
                    w="50 * pixelW";
                    h="20 * pixelH";
                    colorText[]={1,1,1,1};
                    text="";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="14 * pixelH";
                };
                class HealthLabel: RscDefineText
                {
                    idc=1307;
                    x="10 * pixelW";
                    y="64 * pixelH - 45 * pixelH";
                    w="70 * pixelW";
                    h="20 * pixelH"; 
                    colorText[]=
                    {
                        "63/255",
                        "212/255",
                        "252/255",
                        1
                    };
                    text="HEALTH";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=0;
                    sizeEx="11 * pixelH";
                };
                class Health: RscDefineText
                {
                    idc=1306;
                    x="85 * pixelW";
                    y="64 * pixelH - 45 * pixelH";
                    w="50 * pixelW";
                    h="20 * pixelH"; 
                    colorText[]={1,1,1,1};
                    text="";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="14 * pixelH"; 
                };
                class ThirstLabel: RscDefineText
                {
                    idc=1305;
                    x="10 * pixelW";
                    y="64 * pixelH - 25 * pixelH";
                    w="70 * pixelW";
                    h="20 * pixelH";
                    colorText[]=
                    {
                        "63/255",
                        "212/255",
                        "252/255",
                        1
                    };
                    text="THIRST";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=0;
                    sizeEx="11 * pixelH";
                }; 
                class Thirst: RscDefineText
                {
                    idc=1304;
                    x="85 * pixelW";
                    y="64 * pixelH - 25 * pixelH";
                    w="50 * pixelW";
                    h="20 * pixelH";
                    colorText[]={1,1,1,1};
                    text="";
                    font="RobotoCondensed";
                    shadow=0;
                    fixedWidth=0;
                    linespacing=0;
                    style=1;
                    sizeEx="14 * pixelH";
                };
            };
        };
        class MuzzleDisplay: RscDefineText
        {
            idc=1005;
            x="(safeZoneX + safeZoneW) - 280 * pixelW";
            y="(safeZoneY + safeZoneH) - 50 * pixelH";
            w="220 * pixelW";
            h="30 * pixelH";
            colorText[]={1,1,1,1};
            colorBackground[]=
            {
                "19/255",
                "22/255",
                "27/255",
                0.80000001
            };
            text="";
            shadow=0;
            fixedWidth=0;
            sizeEx="18 * pixelH";
            fade=1;
            style=1;
        };
        class GroupMembers: RscDefineStructuredText
        {
            idc=1000;
            x="safeZoneX + 60 * pixelW";
            y="safeZoneY + 60 * pixelH";
            w="400 * pixelW";
            h="500 * pixelH";
            colorBackground[]={0,0,0,0};
            lineSpacing=2;
            text="";
            shadow=2;
        };
        class HungerIcon: RscDefinePictureKeepAspect
        {
            idc=1002;
            x="(safeZoneX + safeZoneW) - 60 * pixelW - 64 * pixelW";
            y="(safeZoneY + safeZoneH) - 630 * pixelH - 64 * pixelH";
            w="64 * pixelW";
            h="64 * pixelH";
            text="textures\gui\RscTitles\RscTitleHUD\hud_icon_hunger_ca.paa";
            shadow=0;
            show="false";
            colorText[]={1,1,1,1};
            blinkingPeriod=0.75;
        };
        class ThirstIcon: RscDefinePictureKeepAspect
        {
            idc=1007;
            x="(safeZoneX + safeZoneW) - 60 * pixelW - 64 * pixelW";
            y="(safeZoneY + safeZoneH) - 720 * pixelH - 64 * pixelH";
            w="64 * pixelW";
            h="64 * pixelH";
            text="textures\gui\RscTitles\RscTitleHUD\hud_icon_thirst_ca.paa";
            shadow=0;
            show="false";
            colorText[]={1,1,1,1};
            blinkingPeriod=0.75;
        };
        class CombatIcon: RscDefinePictureKeepAspect
        {
            idc=1008;
            x="(safeZoneX + safeZoneW) - 60 * pixelW - 64 * pixelW";
            y="(safeZoneY + safeZoneH) - 810 * pixelH - 64 * pixelH";
            w="64 * pixelW";
            h="64 * pixelH";
            text="textures\gui\RscTitles\RscTitleHUD\hud_icon_combat_ca.paa";
            shadow=0;
            show="false";
            colorText[]={1,1,1,1};
            blinkingPeriod=0.75;
        };
        class NewlifeIcon: RscDefinePictureKeepAspect
        {
            idc=1003;
            x="(safeZoneX + safeZoneW) - 60 * pixelW - 64 * pixelW";
            y="(safeZoneY + safeZoneH) - 455 * pixelH - 64 * pixelH";
            w="64 * pixelW";
            h="64 * pixelH";
            text="textures\gui\RscTitles\RscTitleHUD\hud_icon_newlife_ca.paa";
            shadow=0;
            show="false";
            colorText[]={1,1,1,1};
        };
        class EarPlugsIcon: RscDefinePictureKeepAspect
        {
            idc=1004;
            x="(safeZoneX + safeZoneW) - 60 * pixelW - 64 * pixelW";
            y="(safeZoneY + safeZoneH) - 365 * pixelH - 64 * pixelH";
            w="64 * pixelW";
            h="64 * pixelH";
            text="textures\gui\RscTitles\RscTitleHUD\hud_icon_earplugs_ca.paa";
            shadow=0;
            show="false";
            colorText[]={1,1,1,1};
        };
        class AutoRunIcon: RscDefinePictureKeepAspect
        {
            idc=1006;
            x="(safeZoneX + safeZoneW) - 60 * pixelW - 64 * pixelW";
            y="(safeZoneY + safeZoneH) - 275 * pixelH - 64 * pixelH";
            w="64 * pixelW";
            h="64 * pixelH";
            text="textures\gui\RscTitles\RscTitleHUD\hud_icon_autorun_ca.paa";
            shadow=0;
            show="false";
            colorText[]={1,1,1,1};
        };
    };
    class ShortItemNames
	{
		SmokeShell[] 						= {"WHITE", 	"SMOKE"};
		1Rnd_Smoke_Grenade_shell[] 			= {"WHITE", 	"SMOKE"};
		3Rnd_Smoke_Grenade_shell[] 			= {"WHITE", 	"SMOKE"};

		SmokeShellBlue[] 					= {"BLUE", 		"SMOKE"};
		1Rnd_SmokeBlue_Grenade_shell[] 		= {"BLUE", 		"SMOKE"};
		3Rnd_SmokeBlue_Grenade_shell[] 		= {"BLUE", 		"SMOKE"};

		SmokeShellGreen[] 					= {"GREEN", 	"SMOKE"};
		1Rnd_SmokeGreen_Grenade_shell[] 	= {"GREEN", 	"SMOKE"};
		3Rnd_SmokeGreen_Grenade_shell[] 	= {"GREEN", 	"SMOKE"};

		SmokeShellOrange[] 					= {"ORANGE", 	"SMOKE"};
		1Rnd_SmokeOrange_Grenade_shell[]	= {"ORANGE", 	"SMOKE"};
		3Rnd_SmokeOrange_Grenade_shell[] 	= {"ORANGE", 	"SMOKE"};

		SmokeShellPurple[] 					= {"PURPLE", 	"SMOKE"};
		1Rnd_SmokePurple_Grenade_shell[] 	= {"PURPLE", 	"SMOKE"};
		3Rnd_SmokePurple_Grenade_shell[] 	= {"PURPLE", 	"SMOKE"};

		SmokeShellRed[] 					= {"RED", 		"SMOKE"};
		1Rnd_SmokeRed_Grenade_shell[] 		= {"RED", 		"SMOKE"};
		3Rnd_SmokeRed_Grenade_shell[] 		= {"RED", 		"SMOKE"};
				
		SmokeShellYellow[] 					= {"YELLOW", 	"SMOKE"};
		1Rnd_SmokeYellow_Grenade_shell[] 	= {"YELLOW", 	"SMOKE"};
		3Rnd_SmokeYellow_Grenade_shell[] 	= {"YELLOW", 	"SMOKE"};
				
		UGL_FlareCIR_F[] 					= {"IR", 		"FLARE"};
		3Rnd_UGL_FlareCIR_F[] 				= {"IR", 		"FLARE"};

		UGL_FlareGreen_F[] 					= {"GREEN", 	"FLARE"};
		3Rnd_UGL_FlareGreen_F[] 			= {"GREEN", 	"FLARE"};

		UGL_FlareRed_F[] 					= {"RED", 		"FLARE"};
		3Rnd_UGL_FlareRed_F[] 				= {"RED", 		"FLARE"};

		UGL_FlareWhite_F[] 					= {"WHITE", 	"FLARE"};
		3Rnd_UGL_FlareWhite_F[] 			= {"WHITE", 	"FLARE"};

		UGL_FlareYellow_F[] 				= {"YELLOW", 	"FLARE"};
		3Rnd_UGL_FlareYellow_F[] 			= {"YELLOW", 	"FLARE"};

		Chemlight_blue[] 					= {"BLUE", 		"LIGHT"};
		Chemlight_green[] 					= {"GREEN", 	"LIGHT"};
		Chemlight_red[] 					= {"RED", 		"LIGHT"};
		Chemlight_yellow[] 					= {"YELLOW", 	"LIGHT"};

		1Rnd_HE_Grenade_shell[] 			= {"40MM"};
		3Rnd_HE_Grenade_shell[] 			= {"40MM"};

		O_IR_Grenade[] 						= {"IR"};
		I_IR_Grenade[] 						= {"IR"};
		B_IR_Grenade[] 						= {"IR"};

		HandGrenade[] 						= {"RGO"};
		MiniGrenade[] 						= {"RGN"};
	};
    class Party
    {
        showESP = 1;
        allow3DMarkers = 1;
    };
};