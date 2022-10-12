/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgRemoteExec.hpp
*/

class CfgRemoteExec 
{
    #define REWhitelist(NAME,TARGET) class NAME { \
        allowedTargets = TARGET; \
    };
    #define REWhitelistJIP(NAME,TARGET) class NAME { \
        allowedTargets = TARGET; \
        jip = 1; \
    };
    
    class Functions 
    {
        // RemoteExec modes:
		// 0 - disabled
		// 1 - allowed, taking whitelist into account
		// 2 - allowed, ignoring whitelist (default, because of backward compatibility)
		#ifdef DEBUG
		    mode = 2;// 2 while we are developing
        #else
            mode = 1;
        #endif

		// Ability to send JIP messages:
		// 0 - disable JIP messages
		// 1 - allow JIP messages (default)
		jip = 1;

		//-- Whitelist
        /* Client only functions */
            REWhitelist(MPClient_fnc_AAN,1)
            REWhitelist(MPClient_fnc_addVehicle2Chain,1)
            REWhitelist(MPClient_fnc_bountyReceive,1)
            REWhitelistJIP(MPClient_fnc_copLights,1)
            REWhitelist(MPClient_fnc_copSearch,1)
            REWhitelistJIP(MPClient_fnc_copSiren,1)
            REWhitelist(MPClient_fnc_freezePlayer,1)
            REWhitelist(MPClient_fnc_gangCreated,1)
            REWhitelist(MPClient_fnc_gangDisbanded,1)
            REWhitelist(MPClient_fnc_gangInvite,1)
            REWhitelist(MPClient_fnc_garageRefund,1)
            REWhitelist(MPClient_fnc_giveDiff,1)
            REWhitelist(MPClient_fnc_hideObj,1)
            REWhitelist(MPClient_fnc_garageMenu,1)
            REWhitelist(MPClient_fnc_jail,1)
            REWhitelist(MPClient_fnc_jailMe,1)
            REWhitelist(MPClient_fnc_knockedOut,1)
            REWhitelist(MPClient_fnc_licenseCheck,1)
            REWhitelist(MPClient_fnc_licensesRead,1)
            REWhitelist(MPClient_fnc_lightHouse,1)
            REWhitelistJIP(MPClient_fnc_mediclights,1)
            REWhitelist(MPClient_fnc_medicRequest,1)
            REWhitelistJIP(MPClient_fnc_medicSiren,1)
            REWhitelist(MPClient_fnc_moveIn,1)
            REWhitelist(MPClient_fnc_pickupItem,1)
            REWhitelist(MPClient_fnc_pickupMoney,1)
            REWhitelist(MPClient_fnc_receiveItem,1)
            REWhitelist(MPClient_fnc_receiveMoney,1)
            REWhitelist(MPClient_fnc_removeLicenses,1)
            REWhitelist(MPClient_fnc_restrain,1)
            REWhitelist(MPClient_fnc_revived,1)
            REWhitelist(MPClient_fnc_robPerson,1)
            REWhitelist(MPClient_fnc_robReceive,1)
            REWhitelist(MPClient_fnc_searchClient,1)
            REWhitelist(MPClient_fnc_seizeClient,1)
            REWhitelist(MPClient_fnc_soundDevice,1)
            REWhitelist(MPClient_fnc_spikeStripEffect,1)
            REWhitelist(MPClient_fnc_tazeSound,1)
            REWhitelist(MPClient_fnc_ticketPaid,1)
            REWhitelist(MPClient_fnc_ticketPrompt,1)
            REWhitelist(MPClient_fnc_vehicleAnimate,1)
            REWhitelist(MPClient_fnc_wantedList,1)
            REWhitelist(MPClient_fnc_gangBankResponse,1)
            REWhitelist(MPClient_fnc_chopShopSold,1)
            REWhitelist(MPClient_fnc_fetchPlayerData,1)
            REWhitelist(MPClient_fnc_insertPlayerData,1)
            REWhitelist(MPClient_fnc_receivePlayerData,1)
            REWhitelist(MPClient_fnc_updatePlayerData,1)
            REWhitelist(MPServer_fnc_clientGangKick,1)
            REWhitelist(MPServer_fnc_clientGangLeader,1)
            REWhitelist(MPServer_fnc_clientGangLeft,1)
            REWhitelist(MPServer_fnc_clientGetKey,1)
            REWhitelist(MPClient_fnc_spat,1)
            REWhitelist(MPClient_fnc_bountyHunterTaze,1)
            REWhitelist(MPClient_fnc_handleMoney,1)
            REWhitelist(MPClient_fnc_log,1)
            REWhitelist(MPClient_fnc_enableIndicator,1)

        /* Server only functions */
            REWhitelist(MPServer_fnc_rcon_ban,RE_SERVER)
            REWhitelist(MPServer_fnc_rcon_kick,RE_SERVER)
            REWhitelist(MPServer_fnc_clientMessageRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_insertPlayerDataRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_fetchPlayerDataRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_updatePlayerDataRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_updatePlayerDataRequestPartial,RE_SERVER)
            REWhitelist(MPServer_fnc_jailSys,RE_SERVER)
            REWhitelist(MPServer_fnc_wantedAdd,RE_SERVER)
            REWhitelist(MPServer_fnc_wantedBounty,RE_SERVER)
            REWhitelist(MPServer_fnc_wantedCrimes,RE_SERVER)
            REWhitelist(MPServer_fnc_wantedFetch,RE_SERVER)
            REWhitelist(MPServer_fnc_wantedProfUpdate,RE_SERVER)
            REWhitelist(MPServer_fnc_wantedRemove,RE_SERVER)
            REWhitelist(MPServer_fnc_addContainer,RE_SERVER)
            REWhitelist(MPServer_fnc_addHouse,RE_SERVER)
            REWhitelist(MPServer_fnc_chopShopSell,RE_SERVER)
            REWhitelist(MPServer_fnc_cleanupRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_deleteDBContainer,RE_SERVER)
            REWhitelist(MPServer_fnc_getVehicles,RE_SERVER)
            REWhitelist(MPServer_fnc_insertGangDataRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_keyManagement,RE_SERVER)
            REWhitelist(MPServer_fnc_managesc,RE_SERVER)
            REWhitelist(MPServer_fnc_pickupAction,RE_SERVER)
            REWhitelist(MPServer_fnc_sellHouse,RE_SERVER)
            REWhitelist(MPServer_fnc_sellHouseContainer,RE_SERVER)
            REWhitelist(MPServer_fnc_spawnVehicle,RE_SERVER)
            REWhitelist(MPServer_fnc_spikeStrip,RE_SERVER)
            REWhitelist(MPServer_fnc_updateGangDataRequestPartial,RE_SERVER)
            REWhitelist(MPServer_fnc_updateHouseContainers,RE_SERVER)
            REWhitelist(MPServer_fnc_updateHouseTrunk,RE_SERVER)
            REWhitelist(MPServer_fnc_log,RE_SERVER)
            REWhitelist(MPServer_fnc_setMarketDataValue,RE_SERVER)
            REWhitelist(MPClient_fnc_handleMoneyRequest,RE_SERVER)

            //-- To be removed
            REWhitelist(MPServer_fnc_vehicleCreate,RE_SERVER)
            REWhitelist(MPServer_fnc_vehicleDelete,RE_SERVER)
            REWhitelist(MPServer_fnc_vehicleStore,RE_SERVER)
            //////////////////////////////////////////

            //--- New functions
            REWhitelist(MPServer_fnc_vehicle_buyRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_updateVehicleDataRequestPartial,RE_SERVER)
            //////////////////////////////////////////
            
            REWhitelist(MPServer_fnc_handleBlastingCharge,RE_SERVER)
            REWhitelist(MPServer_fnc_houseGarage,RE_SERVER)
            REWhitelist(MPServer_fnc_switchSideRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_tents_buildRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_tents_packupRequest,RE_SERVER)
            REWhitelist(MPServer_fnc_lottery_buyTicket,RE_SERVER)

        /* HeadlessClient only functions */
            REWhitelist(HC_fnc_addContainer,RE_HEADLESS)
            REWhitelist(HC_fnc_addHouse,RE_HEADLESS)
            REWhitelist(HC_fnc_chopShopSell,RE_HEADLESS)
            REWhitelist(HC_fnc_deleteDBContainer,RE_HEADLESS) 
            REWhitelist(HC_fnc_houseGarage,RE_HEADLESS)
            REWhitelist(HC_fnc_insertPlayerDataRequest,RE_HEADLESS)
            REWhitelist(HC_fnc_insertVehicleDataRequest,RE_HEADLESS)
            REWhitelist(HC_fnc_jailSys,RE_HEADLESS)
            REWhitelist(HC_fnc_keyManagement,RE_HEADLESS)
            REWhitelist(HC_fnc_fetchPlayerDataRequest,RE_HEADLESS)
            REWhitelist(HC_fnc_sellHouse,RE_HEADLESS)
            REWhitelist(HC_fnc_sellHouseContainer,RE_HEADLESS)
            REWhitelist(HC_fnc_spawnVehicle,RE_HEADLESS)
            REWhitelist(HC_fnc_spikeStrip,RE_HEADLESS)
            REWhitelist(HC_fnc_updateGang,RE_HEADLESS)
            REWhitelist(HC_fnc_updateHouseContainers,RE_HEADLESS)
            REWhitelist(HC_fnc_updateHouseTrunk,RE_HEADLESS)
            REWhitelist(HC_fnc_updatePlayerDataRequest,RE_HEADLESS)
            REWhitelist(HC_fnc_vehicleCreate,RE_HEADLESS)
            REWhitelist(HC_fnc_vehicleDelete,RE_HEADLESS)
            REWhitelist(HC_fnc_vehicleStore,RE_HEADLESS)
            REWhitelist(HC_fnc_wantedAdd,RE_HEADLESS)
            REWhitelist(HC_fnc_wantedBounty,RE_HEADLESS)
            REWhitelist(HC_fnc_wantedCrimes,RE_HEADLESS)
            REWhitelist(HC_fnc_wantedFetch,RE_HEADLESS)
            REWhitelist(HC_fnc_wantedProfUpdate,RE_HEADLESS)
            REWhitelist(HC_fnc_wantedRemove,RE_HEADLESS)

        /* Functions for everyone */
            REWhitelist(BIS_fnc_effectKilledAirDestruction,RE_GLOBAL)
            REWhitelist(BIS_fnc_effectKilledSecondaries,RE_GLOBAL)
            REWhitelist(MPClient_fnc_animSync,RE_GLOBAL)
            REWhitelist(MPClient_fnc_broadcast,RE_GLOBAL)
            REWhitelist(MPClient_fnc_colorVehicle,RE_GLOBAL)
            REWhitelist(MPClient_fnc_corpse,RE_GLOBAL)
            REWhitelist(MPClient_fnc_demoChargeTimer,RE_GLOBAL)
            REWhitelist(MPClient_fnc_flashbang,RE_GLOBAL)
            REWhitelist(MPClient_fnc_jumpFnc,RE_GLOBAL)
            REWhitelist(MPClient_fnc_lockVehicle,RE_GLOBAL)
            REWhitelist(MPClient_fnc_pulloutVeh,RE_GLOBAL)
            REWhitelist(MPClient_fnc_say3D,RE_GLOBAL)
            REWhitelist(MPClient_fnc_setFuel,RE_GLOBAL)
            REWhitelist(MPClient_fnc_simDisable,RE_GLOBAL)
            REWhitelist(bis_fnc_debugconsoleexec,RE_GLOBAL)
    };

    class Commands 
    {
        
        // RemoteExec modes:
		// 0 - disabled
		// 1 - allowed, taking whitelist into account
		// 2 - allowed, ignoring whitelist (default, because of backward compatibility)
        #ifdef DEBUG
		    mode = 2;// 2 while we are developing
        #else
            mode = 1;
        #endif

		// Ability to send JIP messages:
		// 0 - disable JIP messages
		// 1 - allow JIP messages (default)
		jip = 1;

        REWhitelist(addHandgunItem,RE_GLOBAL)
        REWhitelist(addMagazine,RE_GLOBAL)
        REWhitelist(addPrimaryWeaponItem,RE_GLOBAL)
        REWhitelist(addWeapon,RE_GLOBAL)
        REWhitelist(setFuel,RE_GLOBAL)
    };
};
