class CfgPatches 
{
    class Utils 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        authors[] = {"Ni1kko"};
    };
};

class CfgUtils
{
    useGMTtime = 1; // 1 - use GMT time, 0  use UTC time
};

class CfgFunctions 
{
    class MPServer 
    {
        class Utils_Functions
        {
            file = "\life_backend\Functions\Utils";
            class util_getPlayerObject {};
            class util_randomString {};
            class util_getSideString {};
            class util_tooExpression {};
            class util_getCurrentDay {};
            class util_getCurrentTime {};
            class util_getRemainingTime {}; 
        };
    };
};