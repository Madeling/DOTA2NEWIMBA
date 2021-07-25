stone_gaze=class({})

LinkLuaModifier( "modifier_stone_gaze", "heros/hero_medusa/stone_gaze.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stone_gaze_debuff", "heros/hero_medusa/stone_gaze.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stone_gaze_petrified", "heros/hero_medusa/stone_gaze.lua", LUA_MODIFIER_MOTION_NONE )

function stone_gaze:IsHiddenWhenStolen()
    return false
end

function stone_gaze:IsStealable()
    return true
end

function stone_gaze:IsRefreshable()
    return true
end

function stone_gaze:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )
	caster:AddNewModifier(caster,self,"modifier_stone_gaze", {duration = duration+caster:TG_GetTalentValue("special_bonus_medusa_5") })
end

function stone_gaze:OnProjectileHit_ExtraData( target, location, kv )
    if not target then
        return
    end
    local caster = self:GetCaster()
	if not target:IsMagicImmune() then
		local ab=caster:FindAbilityByName("mystic_snake")
		if ab then
			EmitSoundOn("Hero_Medusa.MysticSnake.Target", target)
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = ab:GetSpecialValueFor("snake_damage")*2,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags=DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR,
				ability = ab,
			}
			ApplyDamage(damageTable)
			target:AddNewModifier_RS(caster, ab, "modifier_mystic_snake_debuff", {duration=ab:GetSpecialValueFor("slow_duration")})
			target:AddNewModifier_RS(caster, ab, "modifier_rooted", {duration=1.5+caster:TG_GetTalentValue("special_bonus_medusa_3")})
		end
    end
end

modifier_stone_gaze=class({})

function modifier_stone_gaze:IsHidden()
	return false
end

function modifier_stone_gaze:IsDebuff()
	return false
end

function modifier_stone_gaze:IsPurgable()
	return false
end

function modifier_stone_gaze:IsPurgeException()
	return false
end

function modifier_stone_gaze:OnCreated(tg)
    self.parent = self:GetParent()
    self.ability=self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.dur = self.ability:GetSpecialValueFor( "duration" )+self:GetCaster():TG_GetTalentValue("special_bonus_medusa_5")
    if not IsServer() then
        return
    end
    EmitSoundOn( "Hero_Medusa.StoneGaze.Cast", self.parent)
	local pf = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(pf,1,self.parent,PATTACH_POINT_FOLLOW,"attach_head",self.parent:GetAbsOrigin(),true )
	self:AddParticle(pf,false,false,-1,false,false)
	self:StartIntervalThink( 0.1 )
end

function modifier_stone_gaze:OnIntervalThink()
    local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
    if #enemies>0 then
        for _,enemy in pairs(enemies) do
            local modifier1 = enemy:FindModifierByNameAndCaster( "modifier_stone_gaze_debuff", self.parent )
            local modifier2 = enemy:FindModifierByNameAndCaster( "modifier_stone_gaze_petrified", self.parent )
            if not modifier1 and not modifier2 then
                local modifier = enemy:AddNewModifier(self.parent,self.ability,"modifier_stone_gaze_debuff",{duration=self.dur,caster = self.parent:entindex()})
            end
        end
    end
end

function modifier_stone_gaze:DeclareFunctions()
    return
    {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_stone_gaze:OnAttackLanded(tg)
	if IsServer() then
		if tg.attacker==self.parent and not self.parent:IsIllusion() and not tg.target:IsBuilding() then
			if tg.target.stone_gaze_petrified~=nil and tg.target.stone_gaze_petrified>=2 then
				local damageTable = {
					victim = tg.target,
					attacker = self.parent,
					damage = self.parent:GetAverageTrueAttackDamage(self.parent),
					damage_type = DAMAGE_TYPE_PURE,
					ability = self.ability,
				}
				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_stone_gaze:OnDeath(tg)
	if IsServer() then
        if tg.unit==self.parent then
            local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            if #enemies>0 then
                local ab=self.parent:FindAbilityByName("mystic_snake")
				if ab then
					for _,enemy in pairs(enemies) do
						local P =
						{
							Target=enemy,
							Source=self.parent,
							Ability=self.ability,
							EffectName="particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
							iMoveSpeed=1000,
							bDodgeable=false,
							iSourceAttachment=DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
							bDrawsOnMinimap=false,
							bVisibleToEnemies=true,
							iVisionTeamNumber=self.parent:GetTeamNumber(),
						}
						ProjectileManager:CreateTrackingProjectile(P)
					end
                end
            end
        end
	end
end

modifier_stone_gaze_debuff=class({})

function modifier_stone_gaze_debuff:IsHidden()
	return false
end

function modifier_stone_gaze_debuff:IsDebuff()
	return false
end

function modifier_stone_gaze_debuff:IsPurgable()
	return false
end

function modifier_stone_gaze_debuff:IsPurgeException()
	return false
end

function modifier_stone_gaze_debuff:OnCreated(tg)
    self.parent = self:GetParent()
	if self:GetAbility()then
    self.ability=self:GetAbility()
	self.slow = -self.ability:GetSpecialValueFor( "slow" )
	self.stun_duration = self.ability:GetSpecialValueFor( "stone_duration" )
	self.face_duration = self.ability:GetSpecialValueFor( "face_duration" )
	self.physical_bonus = self.ability:GetSpecialValueFor( "bonus_physical_damage" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.stone_angle = self.ability:GetSpecialValueFor( "vision_cone" )
	end
	self.stone_angle = 85
	self.facing = false
    self.counter = 0
    self.interval = 0.03
    if not IsServer() then
        return
    end
	self.center_unit = EntIndexToHScript(tg.caster)
	local pf = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(pf,1,self.center_unit,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",self.parent:GetAbsOrigin(),true)
	self:AddParticle(pf,false,false,-1,false,false)
	self.pf1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.pf1,1,self.parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",self.parent:GetAbsOrigin(),true)
	self:AddParticle(self.pf1,false,false,-1,false,false)
	self:StartIntervalThink(self.interval)
end

function modifier_stone_gaze_debuff:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_stone_gaze_debuff:GetModifierMoveSpeedBonus_Percentage()
	if self.facing then
		return self.slow
	end
end

function modifier_stone_gaze_debuff:GetModifierAttackSpeedBonus_Constant()
	if self.facing then
		return self.slow
	end
end


function modifier_stone_gaze_debuff:OnIntervalThink()
	local vector = self.center_unit:GetOrigin()-self.parent:GetOrigin()
	local center_angle = VectorToAngles( vector ).y
	local facing_angle = VectorToAngles( self.parent:GetForwardVector() ).y
	local distance = vector:Length2D()
	local prev_facing = self.facing
	self.facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) < self.stone_angle ) and (distance < self.radius )
	if self.facing~=prev_facing then
        if self.facing then
            target = self.center_unit
            EmitSoundOnClient("Hero_Medusa.StoneGaze.Target",self.parent:GetPlayerOwner() )
            ParticleManager:SetParticleControlEnt(self.pf1,1,target,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",target:GetAbsOrigin(),true)
        end
	end
	if self.facing then
		self.counter = self.counter + self.interval
	end
	if self.counter>=self.face_duration then
		self.parent:AddNewModifier_RS(self:GetCaster(),self.ability,"modifier_stone_gaze_petrified",{duration = self.stun_duration,physical_bonus = self.physical_bonus,center_unit = self.center_unit:entindex()})
		self:Destroy()
	end
end

modifier_stone_gaze_petrified=class({})

function modifier_stone_gaze_petrified:IsHidden()
	return false
end

function modifier_stone_gaze_petrified:IsDebuff()
	return false
end

function modifier_stone_gaze_petrified:IsPurgable()
	return false
end

function modifier_stone_gaze_petrified:IsPurgeException()
	return false
end

function modifier_stone_gaze_petrified:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_stone_gaze_petrified:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end


function modifier_stone_gaze_petrified:OnCreated(tg)
    self.parent = self:GetParent()
    if not IsServer()then
        return
	end
	if self.parent.stone_gaze_petrified==nil then
		self.parent.stone_gaze_petrified=0
	end
	self.parent.stone_gaze_petrified=self.parent.stone_gaze_petrified+1
	if self.parent.stone_gaze_petrified>=2 then
		self.parent.stone_gaze_petrified=2
	end
	self.physical_bonus = tg.physical_bonus
	self.center_unit = EntIndexToHScript(tg.center_unit)
    EmitSoundOnClient("Hero_Medusa.StoneGaze.Stun", self.parent:GetPlayerOwner())
    local pf = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
    ParticleManager:SetParticleControlEnt(pf,1,self.center_unit,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",self.center_unit:GetAbsOrigin(),true)
	self:AddParticle(pf,false,false,-1,false,false)
end

function modifier_stone_gaze_petrified:OnRefresh(tg)
	self:OnCreated(tg)
end

function modifier_stone_gaze_petrified:OnDestroy()
	if not IsServer()then
        return
	end
	if self.parent.stone_gaze_petrified>=2 then
		self.parent.stone_gaze_petrified=nil
	end
end



function modifier_stone_gaze_petrified:DeclareFunctions()
    return
    {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_stone_gaze_petrified:GetModifierIncomingDamage_Percentage(tg)
	if tg.damage_type==DAMAGE_TYPE_PHYSICAL then
		return self.physical_bonus
	end
end

function modifier_stone_gaze_petrified:CheckState()
    return
    {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
