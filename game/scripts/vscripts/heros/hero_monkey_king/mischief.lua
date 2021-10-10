mischief=class({})
LinkLuaModifier("modifier_mischief_buff", "heros/hero_monkey_king/mischief.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_mischief_buff2", "heros/hero_monkey_king/mischief.lua", LUA_MODIFIER_MOTION_BOTH)
function mischief:IsHiddenWhenStolen()
    return false
end

function mischief:IsStealable()
    return true
end

function mischief:IsRefreshable()
    return true
end

function mischief:Set_InitialUpgrade(tg)
    return {LV=1}
end

function mischief:GetAssociatedSecondaryAbilities()
    return "untransform"
end

function mischief:OnSpellStart()
    local caster=self:GetCaster()
    local target=self:GetCursorTarget()

    if caster:HasAbility("untransform") then
        caster:EmitSound("Hero_MonkeyKing.Transform.On")
        caster:SwapAbilities( "mischief", "untransform", false, true )
    end
    if  caster.wukongsMOD~=nil and #caster.wukongsMOD>0 and caster:HasModifier("modifier_wukongs_command_buff") and not caster:HasModifier("modifier_mischief_buff") then
        caster:RemoveModifierByName("modifier_wukongs_command_buff")
    end
    caster:AddNewModifier(caster, self, "modifier_invulnerable", {duration=0.2})
    if  caster.mischief==nil then
    caster.mischief={
        "models/creeps/ice_biome/diregull/diregull.vmdl",
        "models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee.vmdl",
        "models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl",
        "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl",
        "models/creeps/n_creep_ogre_med/n_creep_ogre_med.vmdl",
        "models/creeps/neutral_creeps/n_creep_satyr_a/n_creep_satyr_a.vmdl",
        "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl",
        "models/creeps/neutral_creeps/n_creep_worg_small/n_creep_worg_small.vmdl",
        "models/props_debris/creep_camp001a.vmdl",
        "models/props_debris/creep_camp002a.vmdl",
        "models/props_debris/creep_camp001b.vmdl",
        "models/creeps/lane_creeps/creep_radiant_melee/radiant_melee.vmdl",
        "models/courier/baby_rosh/babyroshan_elemental_flying.vmdl",
        "models/courier/seekling/seekling.vmdl",
        "models/items/courier/azuremircourierfinal/azuremircourierfinal.vmdl",
        "models/items/wards/chen_ward/chen_ward.vmdl",
        "models/props_gameplay/default_ward.vmdl",
        "models/items/venomancer/ward/chomper_ward/chomper_ward.vmdl",
        "models/items/wards/knightstatue_ward/knightstatue_ward.vmdl",
        "models/heroes/kunkka/ghostship.vmdl",
        "models/props_gameplay/rune_haste01.vmdl",
        "models/props_gameplay/rune_regeneration01.vmdl",
        "models/props_gameplay/rune_illusion01.vmdl",
        "models/props_gameplay/rune_invisibility01.vmdl",
        "models/props_gameplay/rune_goldxp.vmdl",
        "models/props_gameplay/pumpkin_rune.vmdl",
        "models/props_gameplay/rune_doubledamage01.vmdl",
        "models/props_gameplay/rune_arcane.vmdl",
        "models/props_frostivus/frostivus_ancient/sled/elon_sled.vmdl",
        "models/creeps/roshan/roshan.vmdl",
        "models/items/hex/fish_hex_retro/fish_hex_r",
        "models/props_structures/barrel_fish.vmdl",
        "models/props_gameplay/red_box.vmdl",
        "models/props_gameplay/neutral_box_model.vmdl"
    }
end
    if  caster.mischief2==nil then
        caster.mischief2={
            "models/props_tree/frostivus_tree.vmdl",
            "models/props_tree/dire_tree005.vmdl",
            "models/props_tree/dire_tree004b_sfm.vmdl",
            "models/props_tree/tree_dead_02.vmdl",
            "models/props_tree/tree_pine_snow_02_destruction.vmdl",
            "models/props_tree/tree_pinestatic_02.vmdl",
            "models/props_tree/mango_tree.vmdl",
            "models/props_tree/dire_tree004b_sfm.vmdl",
            "models/props_tree/dire_tree007_sfm.vmdl",
            "models/props_tree/dire_tree004_inspector.vmdl",
            "models/props_tree/tree_stump001_ivy.vmdl"
        }
    end
    local modifier=
    {
        outgoing_damage=0,
        incoming_damage=0,
        bounty_base=0,
        bounty_growth=0,
        outgoing_damage_structure=0,
        outgoing_damage_roshan=0,
    }
        local illusions=CreateIllusions(caster, caster, modifier, 1, 150, false, true)
        illusions[1]:AddNewModifier(caster, self, "modifier_kill", {duration=5})
        illusions[1]:AddNewModifier(caster, self, "modifier_mischief_buff2", {duration=5})
      --  illusions[1]:AddNewModifier(caster, self, "modifier_monkey_king_fur_army_soldier_inactive", {duration=5})
      if target==nil then
        caster:AddNewModifier(caster, self, "modifier_monkey_king_transform", {})
      else
        caster:AddNewModifier(caster, self, "modifier_mischief_buff", {tar=target and target:entindex() or nil})
      end
end


modifier_mischief_buff=class({})
function modifier_mischief_buff:IsDebuff()
	return false
end

function modifier_mischief_buff:IsHidden()
	return false
end

function modifier_mischief_buff:IsPurgable()
	return false
end

function modifier_mischief_buff:IsPurgeException()
	return false
end

function modifier_mischief_buff:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ABILITY_START,
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_DISABLE_AUTOATTACK
    }
end



function modifier_mischief_buff:GetModifierModelChange(tg)
   return self.MODEL
end

function modifier_mischief_buff:GetDisableAutoAttack()
    return 1
 end


function modifier_mischief_buff:OnAttack(tg)
    if not IsServer() then
        return
    end
    if tg.attacker==self:GetParent()  then
      self:Destroy()
    end
end


function modifier_mischief_buff:OnTakeDamage(tg)
    if not IsServer() then
        return
    end
    if tg.unit==self:GetParent() and (tg.attacker:IsRealHero()or tg.attacker:IsBoss() ) then
      self:Destroy()
    end
end

function modifier_mischief_buff:OnAbilityStart(tg)
    if not IsServer() then
        return
    end

    if tg.unit == self:GetParent() then
        self:Destroy()
    end
end


function modifier_mischief_buff:OnCreated(tg)
    if not IsServer() then
        return
    end
    local tar=tg.tar and EntIndexToHScript(tg.tar) or nil
    local caster=self:GetCaster()
    if tar~=nil then
        self.MODEL=tar:GetModelName()
    else
          self.MODEL=caster.mischief[RandomInt(1,#caster.mischief)]
    end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_mischief_buff:OnDestroy(tg)
    self.MODEL=nil
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(particle)
    local caster=self:GetCaster()
    if caster:HasModifier("modifier_wukongs_command_buff3") then
        local dur=caster:FindModifierByName("modifier_wukongs_command_buff3"):GetRemainingTime()
        if caster:HasAbility("wukongs_command") then
            local ab=caster:FindAbilityByName("wukongs_command")
        end
        caster:AddNewModifier(caster, ab or self:GetAbility(), "modifier_wukongs_command_buff", {duration=dur})
    end
    if self:GetParent():HasAbility("mischief") then
        self:GetParent():SwapAbilities( "mischief", "untransform", true, false )
    end
end

function modifier_mischief_buff:CheckState()
	return
	{
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}
end


modifier_mischief_buff2=class({})
function modifier_mischief_buff2:IsDebuff()
	return false
end

function modifier_mischief_buff2:IsHidden()
	return true
end

function modifier_mischief_buff2:IsPurgable()
	return false
end

function modifier_mischief_buff2:IsPurgeException()
	return false
end

function modifier_mischief_buff2:CheckState()
	return
	{
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}
end