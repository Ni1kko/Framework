class CfgPatches {
    class RemoteExec {
        units[] = {};
        weapons[] = {};
        requiredAddons[] = {"Database"};
        authors[] = {"Ni1kko"};
    };
};

class CfgRemoteExec
{ 
    enabled = 1;
    checkEveryXmins = 3;
};

class CfgFunctions {
    class Life {
        class RemoteExec_Functions
        {
            file = "\life_backend\Functions\RemoteExec"; 
            class remoteExecRun {}; 
        };
    };
};