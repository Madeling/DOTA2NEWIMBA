CreateTalents("npc_dota_hero_sniper","heros/hero_sniper/slug.lua")
slug=class({})
LinkLuaModifier("modifier_slug_debuff", "heros/hero_sniper/slug.lua", LUA_MODIFIER_MOTION_NONE)
function slug:IsHiddenWhenStolen()
    return false
end

function slug:IsStealable()
    return true
end

function slug:IsRefreshable()
    return true
end


function slug:GetAOERadius()
    return 350
end

function slug:GetCastPoint()
    if self:GetCaster():HasModifier("modifier_sniper_roll") then
        return 0
    else
        return 0.15
    end
end

function slug:OnSpellStart()
	local caster = self:GetCaster()
	local casterpos = caster:GetAbsOrigin()
    local cur = self:GetCursorPosition()
    local fx ="particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
    self.dam = self:GetSpecialValueFor( "dam" )
    if caster:HasModifier("modifier_sniper_roll") then
       fx = "particles/econ/items/sniper/sniper_fall20_immortal/sniper_fall20_immortal_assassinate.vpcf"
       self.dam = self.dam+self:GetSpecialValueFor( "dam2" )
    end
    local null = CreateUnitByName(
        "npc_dummy_unit",
         cur,
         true,
         nil,
         nil,
         caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS)
    EmitSoundOn( "TG.gun", caster )
    local P =
        {
            Target = null,
            Source = caster,
            Ability = self,
            EffectName = fx,
            iMoveSpeed = 3000,
            iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
            bDrawsOnMinimap = false,
            bDodgeable = false,
            bIsAttack = false,
            bVisibleToEnemies = true,
            bReplaceExisting = false,
            bProvidesVision = false,
            ExtraData = {null = null:entindex()},
        }
        TG_CreateProjectile({id=1,team=caster:GetTeamNumber(),owner=caster,target=null,p=P})
end



function slug:OnProjectileHit_ExtraData(target, location,kv)
    local unit = EntIndexToHScript( kv.null)
    local caster=self:GetCaster()
  --  TG_IS_ProjectilesValue1(caster,function()
  --      unit:ForceKill(false)
  --      target=nil
  --  end)
	if not target then
		return
    end
    local target_pos=target:GetAbsOrigin()
    local team=caster:GetTeamNumber()
    local rd = self:GetSpecialValueFor( "rd" )
    local stundur = self:GetSpecialValueFor( "stundur" )
    local vdur = self:GetSpecialValueFor( "vdur" )
    local dur = self:GetSpecialValueFor( "dur" )
    if caster:HasModifier("modifier_sniper_roll") then
        stundur = stundur+self:GetSpecialValueFor( "stundur2" )
     end
    EmitSoundOn( "Hero_Sniper.AssassinateDamage", target )
    AddFOWViewer(team, target_pos, rd,vdur, true)
    local heros = FindUnitsInRadius(
        team,
        target_pos,
        nil,
        rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,false)
    if #heros>0 then
     for _, hero in pairs(heros) do
        if hero:IsAlive() and not hero:IsMagicImmune() then
            hero:AddNewModifier_RS(caster, self, "modifier_stunned", {duration=stundur})
            hero:AddNewModifier_RS(caster, self, "modifier_slug_debuff", {duration=dur})
            local damageTable = {
                victim = hero,
                attacker = caster,
                damage = self.dam,
                damage_type =DAMAGE_TYPE_MAGICAL,
                ability = self,
                }
            ApplyDamage(damageTable)
            caster:PerformAttack(hero, false, false, true, false, true, false, true)
        end
    end
end
    unit:ForceKill(false)
    return true
end

modifier_slug_debuff = class({})

function modifier_slug_debuff:IsDebuff()
	return true
end

function modifier_slug_debuff:IsHidden()
	return false
end

function modifier_slug_debuff:IsPurgable()
	return false
end

function modifier_slug_debuff:IsPurgeException()
	return false
end


function modifier_slug_debuff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end


function modifier_slug_debuff:GetModifierPhysicalArmorBonus()
    return 0-self:GetAbility():GetSpecialValueFor( "ar" )
end

function modifier_slug_debuff:GetModifierMagicalResistanceBonus()
    if self:GetCaster():TG_HasTalent("special_bonus_sniper_10l") then
        return -25
    else
        return 0
    end
end
