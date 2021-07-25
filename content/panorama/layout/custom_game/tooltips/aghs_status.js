let pSelf = $.GetContextPanel();
let pAghsScepterContainer = $("#AghsScepterContainer");
let pAghsShardContainer = $("#AghsShardContainer");
let m_sLastUnitName = "";
let m_iLastUnitIndex = -1;

function SetupTooltip() {
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

        let tUnitData = CustomUIConfig.UnitsKv[sName];
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