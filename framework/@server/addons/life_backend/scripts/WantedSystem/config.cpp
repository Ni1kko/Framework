class CfgPatches 
{
    class Wanted 
    {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Systems"};
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
            file = "\life_backend\scripts\WantedSystem";
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