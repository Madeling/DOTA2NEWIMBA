CreateTalents("npc_dota_hero_ancient_apparition", "heros/hero_ancient_apparition/ice_blast.lua")
ice_blast=ice_blast or class({})
LinkLuaModifier("modifier_ice_blast_buff", "heros/hero_ancient_apparition/ice_blast.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_blast_debuff", "heros/hero_ancient_apparition/ice_blast.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ice_blast_debuff2", "heros/hero_ancient_apparition/ice_blast.lua", LUA_MODIFIER_MOTION_NONE)
function ice_blast:IsHiddenWhenStolen()
    return false
end

function ice_blast:IsStealable()
    return true
end

function ice_blast:IsRefreshable()
    return true
end


function ice_blast:OnAbilityPhaseStart()
	EmitSoundOn("Hero_Ancient_Apparition.IceBlast.Tracker",self:GetCaster())
    return true
end

function ice_blast:OnSpellStart()
	local caster=self:GetCaster()
	local casterpos=caster:GetAbsOrigin()
	local cur_pos=self:GetCursorPosition()
	local dur_sp=self:GetSpecialValueFor("dur_sp")
	local rd=self:GetSpecialValueFor("rd")
	local sp=1000

	for num=1,4+self:GetCaster():TG_GetTalentValue("special_bonus_ancient_apparition_6") do
		local null = CreateUnitByName(
			"npc_dummy_unit",
			cur_pos+RandomVector(500),
			 true,
			 nil,
			 nil,
			 caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS and DOTA_TEAM_BADGUYS or DOTA_TEAM_GOODGUYS)
		local P =
		{
			Target = null,
			Source = caster,
			Ability = self,
			EffectName = "particles/heros/aa/snowball_projectile2.vpcf",
			iMoveSpeed = sp,
			vSourceLoc = casterpos,
			bDrawsOnMinimap = false,
			bDodgeable = false,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = false,
			ExtraData = {null = null:entindex()},
        }
        ProjectileManager:CreateTrackingProjectile(P)
		sp=sp+caster:GetLevel()*20
	end


end

function ice_blast:OnProjectileHit_ExtraData(target, location,kv)
    local unit = EntIndexToHScript( kv.null)
    local caster=self:GetCaster()
	if not target then
		return
    end
    local target_pos=target:GetAbsOrigin()
    local team=caster:GetTeamNumber()
    local rd = self:GetSpecialValueFor( "rd" )
	local dam = self:GetSpecialValueFor( "dam" )
	local spdur = self:GetSpecialValueFor( "dur_sp" )
	local px= ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_explode.vpcf", PATTACH_CUSTOMORIGIN,target)
	ParticleManager:SetParticleControl(px, 3, target_pos+target:GetUpVector()*200)
	ParticleManager:ReleaseParticleIndex(px)
	target:EmitSound("TG.jkboom")
    AddFOWViewer(team, target_pos, rd,3, true)
    local heros = FindUnitsInRadius(
        team,
        target_pos,
        nil,
        rd,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,false)
        if #heros>0 then
        for _, hero in pairs(heros) do
                hero:AddNewModifier_RS(caster, self, "modifier_ice_blast_debuff", {duration=spdur})
                if not hero:IsMagicImmune() and not hero:IsBuilding() then
                    local damageTable = {
                        victim = hero,
                        attacker = caster,
                        damage = dam,
                        damage_type =DAMAGE_TYPE_MAGICAL,
                        ability = self,
                        }
                        ApplyDamage(damageTable)
                end
            caster:AddNewModifier(caster, self, "modifier_ice_blast_buff", {duration=3})
        end
    end
    unit:ForceKill(false)
    return true
end


modifier_ice_blast_debuff=class({})


function modifier_ice_blast_debuff:IsDebuff()
    return true
end

function modifier_ice_blast_debuff:IsPurgable()
    return false
end

function modifier_ice_blast_debuff:IsPurgeException()
    return false
end

function modifier_ice_blast_debuff:IsHidden()
    return false
end

function modifier_ice_blast_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_ice_blast_debuff:StatusEffectPriority()
    return 15
end

function modifier_ice_blast_debuff:OnDestroy()
	if  not IsServer()then
		return
	end
	self:GetParent():AddNewModifier_RS( self:GetCaster(), self:GetAbility(), "modifier_ice_blast_debuff2", {duration=self:GetAbility():GetSpecialValueFor("stun")	} )

end

function modifier_ice_blast_debuff:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_ice_blast_debuff:GetModifierMoveSpeedBonus_Percentage()
    return -100
end

function modifier_ice_blast_debuff:GetDisableHealing()
    return 1
end

modifier_ice_blast_debuff2= class({})


function modifier_ice_blast_debuff2:IsDebuff()
    return true
end

function modifier_ice_blast_debuff2:IsPurgable()
    return false
end

function modifier_ice_blast_debuff2:IsPurgeException()
    return true
end

function modifier_ice_blast_debuff2:IsHidden()
    return false
end

function modifier_ice_blast_debuff2:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_ice_blast_debuff2:StatusEffectPriority()
    return 20
end

function modifier_ice_blast_debuff2:CheckState()
    return
     {
            [MODIFIER_STATE_FROZEN] = true,
            [MODIFIER_STATE_STUNNED] = true,
            [MODIFIER_STATE_MUTED] = true,
            [MODIFIER_STATE_SILENCED] = true,
    }
end

function modifier_ice_blast_debuff2:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_DISABLE_HEALING
   }
end

function modifier_ice_blast_debuff2:GetDisableHealing()
    return 1
end

function modifier_ice_blast_debuff2:GetModifierModelChange()
    return "models/creeps/ice_biome/penguin/penguin.vmdl"
end

function modifier_ice_blast_debuff2:GetModifierModelScale()
    return 100
end

modifier_ice_blast_buff= class({})

function modifier_ice_blast_buff:IsPurgable()
    return false
end
function modifier_ice_blast_buff:IsPurgeException()
    return false
end
function modifier_ice_blast_buff:IsHidden()
    return false
end

function modifier_ice_blast_buff:RemoveOnDeath()
    return true
end


function modifier_ice_blast_buff:GetModifierPreAttack_CriticalStrike()
    return  280
end

function modifier_ice_blast_buff:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
   }
end