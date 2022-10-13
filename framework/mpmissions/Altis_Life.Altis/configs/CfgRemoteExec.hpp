/*
	## Nikko Renolds
	## https://github.com/Ni1kko/FrameworkV2
    ## CfgRemoteExec.hpp
*/

class CfgRemoteExec 
{
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
            REWhitelist(MPClient_fnc_AAN,RE_CLIENT)
            REWhitelist(MPClient_fnc_addVehicle2Chain,RE_CLIENT)
            REWhitelist(MPClient_fnc_bountyReceive,RE_CLIENT)
            REWhitelistJIP(MPClient_fnc_copLights,RE_CLIENT)
            REWhitelist(MPClient_fnc_copSearch,RE_CLIENT)
            REWhitelistJIP(MPClient_fnc_copSiren,RE_CLIENT)
            REWhitelist(MPClient_fnc_freezePlayer,RE_CLIENT)
            REWhitelist(MPClient_fnc_gangCreated,RE_CLIENT)
            REWhitelist(MPClient_fnc_gangDisbanded,RE_CLIENT)
            REWhitelist(MPClient_fnc_gangInvite,RE_CLIENT)
            REWhitelist(MPClient_fnc_garageRefund,RE_CLIENT)
            REWhitelist(MPClient_fnc_giveDiff,RE_CLIENT)
            REWhitelist(MPClient_fnc_hideObj,RE_CLIENT)
            REWhitelist(MPClient_fnc_garageMenu,RE_CLIENT)
            REWhitelist(MPClient_fnc_jail,RE_CLIENT)
            REWhitelist(MPClient_fnc_jailMe,RE_CLIENT)
            REWhitelist(MPClient_fnc_knockedOut,RE_CLIENT)
            REWhitelist(MPClient_fnc_licenseCheck,RE_CLIENT)
            REWhitelist(MPClient_fnc_licensesRead,RE_CLIENT)
            REWhitelist(MPClient_fnc_lightHouse,RE_CLIENT)
            REWhitelistJIP(MPClient_fnc_mediclights,RE_CLIENT)
            REWhitelist(MPClient_fnc_medicRequest,RE_CLIENT)
            REWhitelistJIP(MPClient_fnc_medicSiren,RE_CLIENT)
            REWhitelist(MPClient_fnc_moveIn,RE_CLIENT)
            REWhitelist(MPClient_fnc_pickupItem,RE_CLIENT)
            REWhitelist(MPClient_fnc_pickupMoney,RE_CLIENT)
            REWhitelist(MPClient_fnc_receiveItem,RE_CLIENT)
            REWhitelist(MPClient_fnc_receiveMoney,RE_CLIENT)
            REWhitelist(MPClient_fnc_removeLicenses,RE_CLIENT)
            REWhitelist(MPClient_fnc_restrain,RE_CLIENT)
            REWhitelist(MPClient_fnc_revived,RE_CLIENT)
            REWhitelist(MPClient_fnc_robPerson,RE_CLIENT)
            REWhitelist(MPClient_fnc_robReceive,RE_CLIENT)
            REWhitelist(MPClient_fnc_searchClient,RE_CLIENT)
            REWhitelist(MPClient_fnc_seizeClient,RE_CLIENT)
            REWhitelist(MPClient_fnc_soundDevice,RE_CLIENT)
            REWhitelist(MPClient_fnc_spikeStripEffect,RE_CLIENT)
            REWhitelist(MPClient_fnc_tazeSound,RE_CLIENT)
            REWhitelist(MPClient_fnc_ticketPaid,RE_CLIENT)
            REWhitelist(MPClient_fnc_ticketPrompt,RE_CLIENT)
            REWhitelist(MPClient_fnc_vehicleAnimate,RE_CLIENT)
            REWhitelist(MPClient_fnc_wantedList,RE_CLIENT)
            REWhitelist(MPClient_fnc_gangBankResponse,RE_CLIENT)
            REWhitelist(MPClient_fnc_chopShopSold,RE_CLIENT)
            REWhitelist(MPClient_fnc_fetchPlayerData,RE_CLIENT)
            REWhitelist(MPClient_fnc_insertPlayerData,RE_CLIENT)
            REWhitelist(MPClient_fnc_receivePlayerData,RE_CLIENT)
            REWhitelist(MPClient_fnc_updatePlayerData,RE_CLIENT)
            REWhitelist(MPServer_fnc_clientGangKick,RE_CLIENT)
            REWhitelist(MPServer_fnc_clientGangLeader,RE_CLIENT)
            REWhitelist(MPServer_fnc_clientGangLeft,RE_CLIENT)
            REWhitelist(MPServer_fnc_clientGetKey,RE_CLIENT)
            REWhitelist(MPClient_fnc_spat,RE_CLIENT)
            REWhitelist(MPClient_fnc_bountyHunterTaze,RE_CLIENT)
            REWhitelist(MPClient_fnc_handleMoney,RE_CLIENT)
            REWhitelist(MPClient_fnc_log,RE_CLIENT)
            REWhitelist(MPClient_fnc_enableIndicator,RE_CLIENT)

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
