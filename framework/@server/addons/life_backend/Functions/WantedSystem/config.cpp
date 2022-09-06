class CfgPatches 
{
    class Wanted 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {};
        authors[] = {"Ni1kko"};
    };
};

class CfgWanted
{ 

};

class CfgFunctions 
{
    class MPServer 
    {
        class Wanted_Functions
        {
            file = "\life_backend\Functions\WantedSystem";
            class wantedFetch {};
            class wantedPerson {};
            class wantedBounty {};
            class wantedRemove {};
            class wantedAdd {};
            class wantedCrimes {};
            class wantedProfUpdate {};
        };
    };
};