blade_dance=class({})
LinkLuaModifier("modifier_blade_dance_pa", "heros/hero_juggernaut/blade_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blade_dance_move", "heros/hero_juggernaut/blade_dance.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

function blade_dance:IsHiddenWhenStolen()
    return false
end

function blade_dance:IsStealable()
    return false
end


function blade_dance:GetIntrinsicModifierName()
    return "modifier_blade_dance_pa"
end

function blade_dance:OnSpellStart()
  --[[    local caster = self:GetCaster()   废弃
    local cur_pos=self:GetCursorPosition()
    local caster_pos=caster:GetAbsOrigin()
  local dis=TG_Distance(caster_pos,cur_pos)
    local dir=TG_Direction(cur_pos,caster_pos)
    if dis>800 then
        dis=800
    end
    local time=dis/1500
    local dir_table={}
    local sp=2000
    local pos1 = RotatePosition(caster_pos, QAngle(0, 15, 0), caster_pos + dir)
    local pos2 = RotatePosition(caster_pos, QAngle(0, -15, 0), caster_pos + dir)
    local dir1=TG_Direction(pos1,caster_pos)
    local dir2=TG_Direction(pos2,caster_pos)
    table.insert (dir_table , dir)
    caster.JUMP=false
    caster:EmitSound("TG.juggjump")
    caster:SetForwardVector(TG_Direction(cur_pos,caster_pos))
    caster:AddNewModifier(caster, self, "modifier_blade_dance_move", {duration=time,dir=dir})
        caster:EmitSound("TG.jugginv")
        for num=1,#dir_table do
            local Projectile =
		    {
			Ability = self,
			EffectName = "particles/heros/jugg/jugg_shockwave.vpcf",
			vSpawnOrigin = caster_pos,
			fDistance = 3000,
			fStartRadius = 300,
			fEndRadius =300,
			Source = caster,
			bHasFrontalCone = false,
            bReplaceExisting = false,
            fExpireTime = GameRules:GetGameTime() + 10.0,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			vVelocity =dir_table[num]*sp,
			bProvidesVision = false,
            }
            TG_CreateProjectile({id=0,team=caster:GetTeamNumber(),owner=caster,p=Projectile})
        end]]
end

--[[
function blade_dance:OnProjectileHit_ExtraData(target, location, kv)
    local caster=self:GetCaster()
	if target==nil then
		return
	end
	if target:IsAlive() then
	    caster:PerformAttack(target, false, false, true, false, true, false, true)
    end
end]]

modifier_blade_dance_pa=class({})

function modifier_blade_dance_pa:IsHidden()
    return true
end

function modifier_blade_dance_pa:IsPurgable()
    return false
end

function modifier_blade_dance_pa:IsPurgeException()
    return false
end

function modifier_blade_dance_pa:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_ATTACK_FAIL,
    }
end

function modifier_blade_dance_pa:AllowIllusionDuplicate()
    return false
end

function modifier_blade_dance_pa:OnCreated()
    self.crit = {}
    self.agi=self:GetAbility():GetSpecialValueFor("agi")
end
function modifier_blade_dance_pa:OnRefresh()
    self.agi=self:GetAbility():GetSpecialValueFor("agi")
end
function modifier_blade_dance_pa:GetModifierPreAttack_CriticalStrike(tg)
    if not IsServer() or self:GetParent():IsIllusion()  then
		return
	end
    if tg.attacker == self:GetParent() and not tg.target:IsBuilding() and not self:GetParent():PassivesDisabled() then
        local ch=self:GetParent():HasModifier("modifier_omni_slash_buff") and 50 or self:GetAbility():GetSpecialValueFor("ch")+self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_4")
        if RollPseudoRandomPercentage(ch,0,self:GetParent()) then
			self:GetParent():EmitSound("Hero_Juggernaut.BladeDance.Arcana")
            self.crit[tg.record] = true
            return self:GetAbility():GetSpecialValueFor("crit_mult")+self:GetCaster():TG_GetTalentValue("special_bonus_juggernaut_3")
		else
			return 0
		end
	end
    return false
end


function modifier_blade_dance_pa:OnAttackLanded(tg)
    if not IsServer() then
		return
	end
	if tg.attacker ~= self:GetParent() or self:GetParent():PassivesDisabled()  or tg.target:IsBuilding() or not tg.target:IsAlive() then
		return
    end
    local damageTable = {
                        victim = tg.target,
                        attacker = self:GetParent(),
                        damage =self:GetParent():GetAgility()*self.agi,
                        damage_type =DAMAGE_TYPE_PHYSICAL,
                        ability = self:GetAbility(),
                        }
    ApplyDamage(damageTable)
    if self.crit[tg.record] then
  --[[ local pos=tg.attacker:GetAbsOrigin()
        local spawn=tg.target:GetAbsOrigin()
        local dirt=TG_Direction(spawn+Vector(1,1,0),pos)
        self:GetParent():EmitSound("TG.juggjump")
        local Projectile =
        {
        Ability = self:GetAbility(),
        EffectName = "particles/heros/jugg/jugg_shockwave.vpcf",
        vSpawnOrigin = self:GetParent():GetAbsOrigin(),
        fDistance = 3000,
        fStartRadius =200 ,
        fEndRadius =200,
        Source = self:GetParent(),
        fMaxSpeed = 2000,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity = dirt*2000,
        bVisibleToEnemies = true,
        }
        ProjectileManager:CreateLinearProjectile( Projectile )]]
    local p = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.target)
    ParticleManager:SetParticleControlEnt(p, 1, tg.target, PATTACH_ABSORIGIN_FOLLOW, nil, tg.target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(p)
    end
    self.crit[tg.record] = nil
    end

function modifier_blade_dance_pa:OnAttackFail(tg)
        if not IsServer() then
            return
        end
        self.crit[tg.record] = nil
end

function modifier_blade_dance_pa:OnDestroy()
        self.crit = nil
end


modifier_blade_dance_move=class({})


function modifier_blade_dance_move:IsHidden()
    return false
end

function modifier_blade_dance_move:IsPurgable()
    return false
end

function modifier_blade_dance_move:IsPurgeException()
    return false
end

function modifier_blade_dance_move:OnCreated(tg)
    if not IsServer() then
        return
    end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_spirit/courier_trail_spirit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle, false, false, 20, false, false )
    local particle2 = ParticleManager:CreateParticle("particles/heros/jugg/jugg_jump.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle( particle2, false, false, 20, false, false )
    self.DIR=ToVector(tg.dir)
    self.POS=self:GetParent():GetAbsOrigin()
		if not self:ApplyHorizontalMotionController()then
			self:Destroy()
		end

end

function modifier_blade_dance_move:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
    end
    self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (1500 / (1.0 / g )))
end


function modifier_blade_dance_move:OnDestroy()
    if not IsServer() then
        return
    end
    self:GetParent():RemoveHorizontalMotionController(self)
end

function modifier_blade_dance_move:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end

function modifier_blade_dance_move:GetOverrideAnimation()
    return ACT_DOTA_VICTORY
end

function modifier_blade_dance_move:GetModifierTurnRate_Percentage()
	return 100
end

function modifier_blade_dance_move:CheckState()
    return
    {
        [MODIFIER_STATE_STUNNED] = true,
    }
end