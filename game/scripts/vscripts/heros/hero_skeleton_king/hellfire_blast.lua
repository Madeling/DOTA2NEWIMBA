CreateTalents("npc_dota_hero_skeleton_king","heros/hero_skeleton_king/hellfire_blast.lua")

hellfire_blast=class({})
LinkLuaModifier("modifier_hellfire_blast_buff", "heros/hero_skeleton_king/hellfire_blast.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_hellfire_blast_debuff", "heros/hero_skeleton_king/hellfire_blast.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_hellfire_blast_debuff2", "heros/hero_skeleton_king/hellfire_blast.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function hellfire_blast:IsHiddenWhenStolen()
    return false
end

function hellfire_blast:IsStealable()
    return true
end


function hellfire_blast:IsRefreshable()
    return true
end

function hellfire_blast:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self,iLevel)-self:GetCaster():TG_GetTalentValue("special_bonus_skeleton_king_1")
end

function hellfire_blast:OnSpellStart()
	local caster=self:GetCaster()
	local caster_pos=caster:GetAbsOrigin()
	local target=self:GetCursorTarget()
	local caster_team=caster:GetTeamNumber()
	local sp = self:GetSpecialValueFor( "blast_speed" )
	local rd = self:GetSpecialValueFor( "rd" )
	caster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
	local units=FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(),nil,rd, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #units>0 then
			for _,unit in pairs(units) do
				local P = {
					Ability = self,
					EffectName = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf",
					iMoveSpeed = sp,
					Source =caster,
					Target = unit,
					bDrawsOnMinimap = false,
					bDodgeable = true,
					bIsAttack = false,
					bProvidesVision = false,
					bReplaceExisting = false,
					vSourceLoc = caster_pos,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
				}
				TG_CreateProjectile({id=1,team=caster_team,owner=caster,p=P})
			end
	end
end


function hellfire_blast:OnProjectileHit_ExtraData( target, location,kv)
	local caster=self:GetCaster()
	if target == nil  then
		return
	end
    if  target:TG_TriggerSpellAbsorb(self) then
        return
    end
		EmitSoundOn( "Hero_SkeletonKing.Hellfire_BlastImpact", target )
		if  not target:IsMagicImmune() then
			target:AddNewModifier_RS(caster, self, "modifier_hellfire_blast_debuff", {duration=self:GetSpecialValueFor( "blast_stun_duration" )})
			caster:AddNewModifier(caster, self, "modifier_hellfire_blast_buff", {duration=self:GetSpecialValueFor( "dur" )})
			if caster:TG_HasTalent("special_bonus_skeleton_king_4") then
				caster:PerformAttack(target, false, true, true, false, true, false, true)
			end
			local dam = self:GetSpecialValueFor( "dam" )
			local damage = {
				victim = target,
				attacker = caster,
				damage = dam,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damage )
		end
	return true
end

modifier_hellfire_blast_debuff=class({})

function modifier_hellfire_blast_debuff:IsHidden()
	return false
end

function modifier_hellfire_blast_debuff:IsPurgable()
	return false
end

function modifier_hellfire_blast_debuff:IsPurgeException()
	return true
end

function modifier_hellfire_blast_debuff:IsDebuff()
    return true
end


function modifier_hellfire_blast_debuff:OnRemoved()
    if  IsServer() then
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hellfire_blast_debuff2", {duration=self:GetAbility():GetSpecialValueFor( "blast_dot_duration" )+self:GetCaster():TG_GetTalentValue("special_bonus_skeleton_king_3")})
    end
end

function modifier_hellfire_blast_debuff:CheckState()
	return
	{
		[MODIFIER_STATE_STUNNED] = true,
	}
end




modifier_hellfire_blast_debuff2=class({})

function modifier_hellfire_blast_debuff2:IsHidden()
	return false
end

function modifier_hellfire_blast_debuff2:IsPurgable()
	return true
end

function modifier_hellfire_blast_debuff2:IsPurgeException()
	return true
end

function modifier_hellfire_blast_debuff2:IsDebuff()
    return true
end

function modifier_hellfire_blast_debuff2:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
end

function modifier_hellfire_blast_debuff2:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor( "blast_slow" )
end


modifier_hellfire_blast_buff=class({})

function modifier_hellfire_blast_buff:IsHidden()
	return false
end

function modifier_hellfire_blast_buff:IsPurgable()
	return false
end

function modifier_hellfire_blast_buff:IsPurgeException()
	return false
end