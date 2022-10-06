/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## RscTitleNameTags.hpp
*/

class RscTitleNameTags 
{
    idd = 11202;
    duration = INFINTE;
    onLoad = "uiNamespace setVariable ['RscTitleNameTags',_this select 0]";
    onUnload="uiNamespace setVariable ['RscTitleNameTags', displayNull]";
    onDestroy="uiNamespace setVariable ['RscTitleNameTags', displayNull]";
    objects[] = {};

    class controls
    {
        class BaseIcon
        {
            idc = -1;
            type = 13;
            style = 0;
            colorText[] = {1,1,1,1};
            colorBackground[] = {0,0,0,0};
            font = "PuristaMedium";
            text = "";
            size = 0.04;
            shadow = 1.5;
            w = 0; h = 0;
            x = 0.1; y = 0.1;
        };

        class p1 : BaseIcon {idc = NameTagBaseIDC;};
        class p2 : BaseIcon {idc = NameTagBaseIDC + 1;};
        class p3 : BaseIcon {idc = NameTagBaseIDC + 2;};
        class p4 : BaseIcon {idc = NameTagBaseIDC + 3;};
        class p5 : BaseIcon {idc = NameTagBaseIDC + 4;};
        class p6 : BaseIcon {idc = NameTagBaseIDC + 5;};
        class p7 : BaseIcon {idc = NameTagBaseIDC + 6;};
        class p8 : BaseIcon {idc = NameTagBaseIDC + 7;};
        class p9 : BaseIcon {idc = NameTagBaseIDC + 8;};
        class p10 : BaseIcon {idc = NameTagBaseIDC + 9;};
        class p11 : BaseIcon {idc = NameTagBaseIDC + 10;};
        class p12 : BaseIcon {idc = NameTagBaseIDC + 11;};
        class p13 : BaseIcon {idc = NameTagBaseIDC + 12;};
        class p14 : BaseIcon {idc = NameTagBaseIDC + 13;};
        class p15 : BaseIcon {idc = NameTagBaseIDC + 14;};
        class p16 : BaseIcon {idc = NameTagBaseIDC + 15;};
        class p17 : BaseIcon {idc = NameTagBaseIDC + 16;};
        class p18 : BaseIcon {idc = NameTagBaseIDC + 17;};
        class p19 : BaseIcon {idc = NameTagBaseIDC + 18;};
        class p20 : BaseIcon {idc = NameTagBaseIDC + 19;};
        class p21 : BaseIcon {idc = NameTagBaseIDC + 20;};
        class p22 : BaseIcon {idc = NameTagBaseIDC + 21;};
        class p23 : BaseIcon {idc = NameTagBaseIDC + 22;};
        class p24 : BaseIcon {idc = NameTagBaseIDC + 23;};
        class p25 : BaseIcon {idc = NameTagBaseIDC + 24;};
        class p26 : BaseIcon {idc = NameTagBaseIDC + 25;};
        class p27 : BaseIcon {idc = NameTagBaseIDC + 26;};
        class p28 : BaseIcon {idc = NameTagBaseIDC + 27;};
        class p29 : BaseIcon {idc = NameTagBaseIDC + 28;};
        class p30 : BaseIcon {idc = NameTagBaseIDC + 29;};
        class p31 : BaseIcon {idc = NameTagBaseIDC + 30;};
        class p32 : BaseIcon {idc = NameTagBaseIDC + 31;};
        class p33 : BaseIcon {idc = NameTagBaseIDC + 32;};
        class p34 : BaseIcon {idc = NameTagBaseIDC + 33;};
        class p35 : BaseIcon {idc = NameTagBaseIDC + 34;};
        class p36 : BaseIcon {idc = NameTagBaseIDC + 35;};
        class p37 : BaseIcon {idc = NameTagBaseIDC + 36;};
        class p38 : BaseIcon {idc = NameTagBaseIDC + 37;};
        class p39 : BaseIcon {idc = NameTagBaseIDC + 38;};
        class p40 : BaseIcon {idc = NameTagBaseIDC + 39;};
        class p41 : BaseIcon {idc = NameTagBaseIDC + 40;};
        class p42 : BaseIcon {idc = NameTagBaseIDC + 41;};
        class p43 : BaseIcon {idc = NameTagBaseIDC + 42;};
        class p44 : BaseIcon {idc = NameTagBaseIDC + 43;};
        class p45 : BaseIcon {idc = NameTagBaseIDC + 44;};
        class p46 : BaseIcon {idc = NameTagBaseIDC + 45;};
        class p47 : BaseIcon {idc = NameTagBaseIDC + 46;};
        class p48 : BaseIcon {idc = NameTagBaseIDC + 47;};
        class p49 : BaseIcon {idc = NameTagBaseIDC + 48;};
        class p50 : BaseIcon {idc = NameTagBaseIDC + 49;};
        class p51 : BaseIcon {idc = NameTagBaseIDC + 50;};
        class p52 : BaseIcon {idc = NameTagBaseIDC + 51;};
        class p53 : BaseIcon {idc = NameTagBaseIDC + 52;};
        class p54 : BaseIcon {idc = NameTagBaseIDC + 53;};
        class p55 : BaseIcon {idc = NameTagBaseIDC + 54;};
        class p56 : BaseIcon {idc = NameTagBaseIDC + 55;};
        class p57 : BaseIcon {idc = NameTagBaseIDC + 56;};
        class p58 : BaseIcon {idc = NameTagBaseIDC + 57;};
        class p59 : BaseIcon {idc = NameTagBaseIDC + 58;};
        class p60 : BaseIcon {idc = NameTagBaseIDC + 59;};
        class p61 : BaseIcon {idc = NameTagBaseIDC + 60;};
        class p62 : BaseIcon {idc = NameTagBaseIDC + 61;};
        class p63 : BaseIcon {idc = NameTagBaseIDC + 62;};
        class p64 : BaseIcon {idc = NameTagBaseIDC + 63;};
        class p65 : BaseIcon {idc = NameTagBaseIDC + 64;};
        class p66 : BaseIcon {idc = NameTagBaseIDC + 65;};
        class p67 : BaseIcon {idc = NameTagBaseIDC + 66;};
        class p68 : BaseIcon {idc = NameTagBaseIDC + 67;};
        class p69 : BaseIcon {idc = NameTagBaseIDC + 68;};
        class p70 : BaseIcon {idc = NameTagBaseIDC + 69;};
        class p71 : BaseIcon {idc = NameTagBaseIDC + 70;};
        class p72 : BaseIcon {idc = NameTagBaseIDC + 71;};
        class p73 : BaseIcon {idc = NameTagBaseIDC + 72;};
        class p74 : BaseIcon {idc = NameTagBaseIDC + 73;};
        class p75 : BaseIcon {idc = NameTagBaseIDC + 74;};
        class p76 : BaseIcon {idc = NameTagBaseIDC + 75;};
        class p77 : BaseIcon {idc = NameTagBaseIDC + 76;};
        class p78 : BaseIcon {idc = NameTagBaseIDC + 77;};
        class p79 : BaseIcon {idc = NameTagBaseIDC + 78;};
        class p80 : BaseIcon {idc = NameTagBaseIDC + 79;};
        class p81 : BaseIcon {idc = NameTagBaseIDC + 80;};
        class p82 : BaseIcon {idc = NameTagBaseIDC + 81;};
        class p83 : BaseIcon {idc = NameTagBaseIDC + 82;};
        class p84 : BaseIcon {idc = NameTagBaseIDC + 83;};
        class p85 : BaseIcon {idc = NameTagBaseIDC + 84;};
        class p86 : BaseIcon {idc = NameTagBaseIDC + 85;};
        class p87 : BaseIcon {idc = NameTagBaseIDC + 86;};
        class p88 : BaseIcon {idc = NameTagBaseIDC + 87;};
        class p89 : BaseIcon {idc = NameTagBaseIDC + 88;};
        class p90 : BaseIcon {idc = NameTagBaseIDC + 89;};
        class p91 : BaseIcon {idc = NameTagBaseIDC + 90;};
        class p92 : BaseIcon {idc = NameTagBaseIDC + 91;};
        class p93 : BaseIcon {idc = NameTagBaseIDC + 92;};
        class p94 : BaseIcon {idc = NameTagBaseIDC + 93;};
        class p95 : BaseIcon {idc = NameTagBaseIDC + 94;};
        class p96 : BaseIcon {idc = NameTagBaseIDC + 95;};
        class p97 : BaseIcon {idc = NameTagBaseIDC + 96;};
        class p98 : BaseIcon {idc = NameTagBaseIDC + 97;};
        class p99 : BaseIcon {idc = NameTagBaseIDC + 98;};
        class p100 : BaseIcon {idc = NameTagBaseIDC + 99;};
        class p101 : BaseIcon {idc = NameTagBaseIDC + 100;};
        class p102 : BaseIcon {idc = NameTagBaseIDC + 101;};
        class p103 : BaseIcon {idc = NameTagBaseIDC + 102;};
        class p104 : BaseIcon {idc = NameTagBaseIDC + 103;};
        class p105 : BaseIcon {idc = NameTagBaseIDC + 104;};
        class p106 : BaseIcon {idc = NameTagBaseIDC + 105;};
        class p107 : BaseIcon {idc = NameTagBaseIDC + 106;};
        class p108 : BaseIcon {idc = NameTagBaseIDC + 107;};
        class p109 : BaseIcon {idc = NameTagBaseIDC + 108;};
        class p110 : BaseIcon {idc = NameTagBaseIDC + 109;};
    };
};