let pSelf = $.GetContextPanel();
let pAghsScepterContainer = $("#AghsScepterContainer");
let pAghsShardContainer = $("#AghsShardContainer");
let m_sLastUnitName = "";
let m_iLastUnitIndex = -1;



function SetupTooltip() {
    //var aghs = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements");
    //aghs.FindChildTraverse("AghsStatusContainer").style.visibility = "collapse";
    let sUnitName = pSelf.GetAttributeString("unitname", "");
    let iUnitIndex = pSelf.GetAttributeInt("entityindex", -1);

    pSelf.SetHasClass("HasScepter", iUnitIndex == -1 || Entities.HasScepter(iUnitIndex));
    pSelf.SetHasClass("HasShard", iUnitIndex == -1 || Entities.HasBuff(iUnitIndex, "modifier_aghs_shard"));

    if (sUnitName != m_sLastUnitName || iUnitIndex != m_iLastUnitIndex) {
        pAghsScepterContainer.RemoveAndDeleteChildren();
        pAghsShardContainer.RemoveAndDeleteChildren();

        let bNoScepter = true;
        let bNoShard = true;

        let AddDescription = sAbilityName => {
            let tData = CustomUIConfig.AbilitiesKv[sAbilityName];
            if (tData) {
                if (tData.IsGrantedByScepter == 1 || tData.IsGrantedByScepter == "1" || tData.IsGrantedByShard == 1 || tData.IsGrantedByShard == "1") {
                    let sDescription = GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, $.Localize("dota_tooltip_ability_" + sAbilityName + "_description"));
                    if (sDescription != "dota_tooltip_ability_" + sAbilityName + "_description") {
                        if (tData.IsGrantedByScepter == 1 || tData.IsGrantedByScepter == "1") {
                            let pPanel = $.CreatePanel("Panel", pAghsScepterContainer, "");
                            pPanel.BLoadLayoutSnippet("AghsScepterNewAbilitySnippet");
                            pPanel.SetDialogVariable("scepter_granted_ability", $.Localize("dota_tooltip_ability_" + sAbilityName, pPanel));
                            pPanel.SetDialogVariable("scepter_upgrade_description", sDescription);
                            let pScepterAbilityImage = pPanel.FindChildTraverse("ScepterAbilityImage");
                            if (pScepterAbilityImage) {
                                pScepterAbilityImage.abilityname = sAbilityName;
                            }
                            bNoScepter = false;
                        }
                        if (tData.IsGrantedByShard == 1 || tData.IsGrantedByShard == "1") {
                            let pPanel = $.CreatePanel("Panel", pAghsShardContainer, "");
                            pPanel.BLoadLayoutSnippet("AghsScepterNewAbilitySnippet");
                            pPanel.SetDialogVariable("scepter_granted_ability", $.Localize("dota_tooltip_ability_" + sAbilityName, pPanel));
                            pPanel.SetDialogVariable("scepter_upgrade_description", sDescription);
                            let pScepterAbilityImage = pPanel.FindChildTraverse("ScepterAbilityImage");
                            if (pScepterAbilityImage) {
                                pScepterAbilityImage.abilityname = sAbilityName;
                            }
                            bNoShard = false;
                        }
                    }
                } else if (tData.HasScepterUpgrade == 1 || tData.HasScepterUpgrade == "1" || tData.HasShardUpgrade == 1 || tData.HasShardUpgrade == "1") {
                    if (tData.HasScepterUpgrade == 1 || tData.HasScepterUpgrade == "1") {
                        let sDescription = GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, $.Localize("dota_tooltip_ability_" + sAbilityName + "_aghanim_description"));
                        if (sDescription != "dota_tooltip_ability_" + sAbilityName + "_aghanim_description") {
                            let pPanel = $.CreatePanel("Panel", pAghsScepterContainer, "");
                            pPanel.BLoadLayoutSnippet("AghsScepterSnippet");
                            pPanel.SetDialogVariable("scepter_granted_ability", $.Localize("dota_tooltip_ability_" + sAbilityName, pPanel));
                            pPanel.SetDialogVariable("scepter_upgrade_description", sDescription);
                            let pScepterAbilityImage = pPanel.FindChildTraverse("ScepterAbilityImage");
                            if (pScepterAbilityImage) {
                                pScepterAbilityImage.abilityname = sAbilityName;
                            }
                            bNoScepter = false;
                        }
                    }
                    if (tData.HasShardUpgrade == 1 || tData.HasShardUpgrade == "1") {
                        let sDescription = GameUI.ReplaceDOTAAbilitySpecialValues(sAbilityName, $.Localize("dota_tooltip_ability_" + sAbilityName + "_shard_description"));
                        if (sDescription != "dota_tooltip_ability_" + sAbilityName + "_shard_description") {
                            let pPanel = $.CreatePanel("Panel", pAghsShardContainer, "");
                            pPanel.BLoadLayoutSnippet("AghsScepterSnippet");
                            pPanel.SetDialogVariable("scepter_granted_ability", $.Localize("dota_tooltip_ability_" + sAbilityName, pPanel));
                            pPanel.SetDialogVariable("scepter_upgrade_description", sDescription);
                            let pScepterAbilityImage = pPanel.FindChildTraverse("ScepterAbilityImage");
                            if (pScepterAbilityImage) {
                                pScepterAbilityImage.abilityname = sAbilityName;
                            }
                            bNoShard = false;
                        }
                    }
                }
            }
        };

        let sName = SkinNameToUnitName(sUnitName) || sUnitName;

        let tUnitData = HEROLIST[sName];
        if (iUnitIndex != -1) {
            for (let i = 0; i < Entities.GetAbilityCount(iUnitIndex); i++) {
                const iAbilityIndex = Entities.GetAbility(iUnitIndex, i);
                if (iAbilityIndex == -1) break;
                let sAbilityName = Abilities.GetAbilityName(iAbilityIndex);
                AddDescription(sAbilityName);
            }
        } else {
            if (tUnitData) {
                for (let i = 1; i <= 32; i++) {
                    let sAbilityName = tUnitData["Ability" + i];
                    AddDescription(sAbilityName);
                }
            }
        }

        pAghsScepterContainer.SetHasClass("NoUpgrade", bNoScepter);
        pAghsShardContainer.SetHasClass("NoUpgrade", bNoShard);

        if (bNoScepter) {
            let sDescription = $.Localize("dota_tooltip_ability_" + sName + "_scepter_description");
            let pPanel = $.CreatePanel("Panel", pAghsScepterContainer, "");
            if (sDescription != "dota_tooltip_ability_" + sName + "_scepter_description") {
                pPanel.BLoadLayoutSnippet("AghsHeroScepterSnippet");
                let pHeroImage = pPanel.FindChildTraverse("HeroImage");
                if (pHeroImage) {
                    pHeroImage.heroimagestyle = "portrait";
                    pHeroImage.heroname = tUnitData.GhostModelUnitName;
                }
                pPanel.SetDialogVariable("scepter_upgrade_description", sDescription);
            } else {
                pPanel.BLoadLayoutSnippet("NoUpgradeSnippet");
            }
        }
        if (bNoShard) {
            let sDescription = $.Localize("dota_tooltip_ability_" + sName + "_shard_description");
            let pPanel = $.CreatePanel("Panel", pAghsShardContainer, "");
            if (sDescription != "dota_tooltip_ability_" + sName + "_shard_description") {
                pPanel.BLoadLayoutSnippet("AghsHeroShardSnippet");
                let pHeroImage = pPanel.FindChildTraverse("HeroImage");
                if (pHeroImage) {
                    pHeroImage.heroimagestyle = "portrait";
                    pHeroImage.heroname = tUnitData.GhostModelUnitName;
                }
                pPanel.SetDialogVariable("scepter_upgrade_description", $.Localize(""));
            } else {
                pPanel.BLoadLayoutSnippet("NoUpgradeSnippet");
            }
        }
    }

    if ($("#AghsStatusScepterScene")) {
        if (!pSelf.BHasClass("HasScepter")) {
            $("#AghsStatusScepterScene").DeleteAsync(-1);
        }
    } else {
        if (pSelf.BHasClass("HasScepter")) {
            let pParent = $("#AghsStatusScepterContainer");
            pParent.BCreateChildren(`<DOTAParticleScenePanel id="AghsStatusScepterScene" particleName="particles/ui/hud/aghs_status_active_scepter.vpcf" particleonly="true" cameraOrigin="400 0 0" lookAt="180 0 0" fov="20" hittest="false"/>`);
        }
    }

    if ($("#AghsStatusShardScene")) {
        if (!pSelf.BHasClass("HasShard")) {
            $("#AghsStatusShardScene").DeleteAsync(-1);
        }
    } else {
        if (pSelf.BHasClass("HasShard")) {
            let pParent = $("#AghsStatusShardContainer");
            pParent.BCreateChildren(`<DOTAParticleScenePanel id="AghsStatusShardScene" particleName="particles/ui/hud/aghs_status_active_shard.vpcf" particleonly="true" cameraOrigin="400 0 0" lookAt="180 0 0" fov="20" hittest="false"/>`);
        }
    }

    m_sLastUnitName = sUnitName;
    m_iLastUnitIndex = iUnitIndex;
}

(() => {
    SetupTooltip();
})();


var HEROLIST=
[
	//"npc_dota_hero_tg"			"1"
	"npc_dota_hero_vengefulspirit"		,
	"npc_dota_hero_invoker"			,
	"npc_dota_hero_tinker" 			,
	"npc_dota_hero_venomancer"		,
	"npc_dota_hero_omniknight" 		,
	"npc_dota_hero_undying" 		,
	"npc_dota_hero_templar_assassin"	,
	"npc_dota_hero_sniper" 		,
	"npc_dota_hero_kunkka" 		,
	"npc_dota_hero_elder_titan" 		,
	"npc_dota_hero_gyrocopter" 		,
	"npc_dota_hero_juggernaut" 		,
	"npc_dota_hero_oracle"		,
	"npc_dota_hero_phoenix" 		,
	"npc_dota_hero_ancient_apparition" 	,
	"npc_dota_hero_enchantress"		,
	"npc_dota_hero_sven"		,
	"npc_dota_hero_enigma" 		,
	"npc_dota_hero_shadow_shaman"	,
	"npc_dota_hero_phantom_assassin"	,
	"npc_dota_hero_centaur" 		,
	"npc_dota_hero_naga_siren" 		,
	"npc_dota_hero_crystal_maiden" 	,
	"npc_dota_hero_axe" 		,
	"npc_dota_hero_night_stalker"		,
	"npc_dota_hero_monkey_king"		,
	"npc_dota_hero_windrunner"		,
	"npc_dota_hero_dark_seer" 		,
	"npc_dota_hero_skeleton_king"		,
	"npc_dota_hero_chen"		,
	"npc_dota_hero_ember_spirit"		,
	"npc_dota_hero_dragon_knight"	,
	"npc_dota_hero_lycan"		,
	"npc_dota_hero_medusa"		,
	"npc_dota_hero_obsidian_destroyer"	,
	"npc_dota_hero_furion"		,
	"npc_dota_hero_tusk"		,
	"npc_dota_hero_bristleback"		,
	"npc_dota_hero_viper" 		,
	"npc_dota_hero_drow_ranger"		,
	"npc_dota_hero_sand_king"		,
	"npc_dota_hero_spirit_breaker"		,
	"npc_dota_hero_jakiro"		,
	"npc_dota_hero_abaddon" 		,
	"npc_dota_hero_bane" 			,


	//////////////////////////////////////////
	//老imba
	"npc_dota_hero_rattletrap"			,
	"npc_dota_hero_puck"			,
	"npc_dota_hero_chaos_knight" 			,
	"npc_dota_hero_pudge"			,
	"npc_dota_hero_lina" 			,
	"npc_dota_hero_lich" 			,
	"npc_dota_hero_skywrath_mage" 		,
	"npc_dota_hero_troll_warlord"			,
	"npc_dota_hero_bounty_hunter" 		,
	"npc_dota_hero_abyssal_underlord" 		,
	"npc_dota_hero_disruptor" 			,
	"npc_dota_hero_nyx_assassin"			,
	"npc_dota_hero_storm_spirit"			,
	"npc_dota_hero_faceless_void"			,
	"npc_dota_hero_lion"			,
	"npc_dota_hero_mirana"			,
	"npc_dota_hero_queenofpain"			,
	"npc_dota_hero_pugna"	,
	//////////////////////////////////////////



	//////////////////////////////////////////
	//毒瘤
	"npc_dota_hero_necrolyte"		,
	"npc_dota_hero_zuus"		,
	"npc_dota_hero_mars"		,
	//////////////////////////////////////////

	//////////////////////////////////////////
	//神秘
	"npc_dota_hero_brewmaster"	,
	"npc_dota_hero_dark_willow"	,
	"npc_dota_hero_death_prophet"	,
	"npc_dota_hero_legion_commander"	,
	"npc_dota_hero_nevermore"	,
	"npc_dota_hero_slardar"	,
	"npc_dota_hero_slark"	,
	"npc_dota_hero_tidehunter"	,
	"npc_dota_hero_visage"	,
	"npc_dota_hero_void_spirit"	,
	"npc_dota_hero_ursa"	,
	"npc_dota_hero_riki"		,
	"npc_dota_hero_morphling"	,
	"npc_dota_hero_rubick"	,
	//////////////////////////////////////////



	//////////////////////////////////////////
	//ting
	"npc_dota_hero_dazzle"		,
	"npc_dota_hero_doom_bringer"	,
	"npc_dota_hero_razor"		,
	"npc_dota_hero_lich" 		,
	"npc_dota_hero_huskar"		,
	"npc_dota_hero_luna"		,
	"npc_dota_hero_witch_doctor" 		,
	"npc_dota_hero_treant"		,
	"npc_dota_hero_tiny" 			,
	"npc_dota_hero_keeper_of_the_light"	,
	//////////////////////////////////////////


	//////////////////////////////////////////
	//林肯
	"npc_dota_hero_antimage" 		,
	"npc_dota_hero_wisp"		,
	"npc_dota_hero_batrider"		,
	"npc_dota_hero_hoodwink" 		,
	"npc_dota_hero_life_stealer"		,
	"npc_dota_hero_ogre_magi"		,
	"npc_dota_hero_snapfire"		,
	"npc_dota_hero_shredder"		,
	"npc_dota_hero_pangolier"		,
	"npc_dota_hero_terrorblade"		,
	"npc_dota_hero_meepo"		,
	"npc_dota_hero_arc_warden" 		,
	"npc_dota_hero_earthshaker"		,
	"npc_dota_hero_phantom_lancer"	,
	"npc_dota_hero_bloodseeker"		,
	"npc_dota_hero_dawnbreaker" 		,
	"npc_dota_hero_shadow_demon" 	,
	"npc_dota_hero_broodmother" 	,
	"npc_dota_hero_grimstroke" 		,
	"npc_dota_hero_spectre"		,
	"npc_dota_hero_clinkz"			,
	//////////////////////////////////////////




	//////////////////////////////////////////
	//traveler
	"npc_dota_hero_leshrac"		,
	//////////////////////////////////////////



	"npc_dota_hero_silencer"			,
	"npc_dota_hero_magnataur"			,
	"npc_dota_hero_winter_wyvern" 		,
	"npc_dota_hero_earth_spirit"			,

	"npc_dota_hero_weaver"			,


]
