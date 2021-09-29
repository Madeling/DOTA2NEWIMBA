powershot= class({})
LinkLuaModifier("modifier_powershot_debuff", "heros/hero_windrunner/powershot.lua", LUA_MODIFIER_MOTION_NONE)

function powershot:IsHiddenWhenStolen()
    return false
end

function powershot:IsStealable()
    return true
end

function powershot:IsRefreshable()
    return true
end

function powershot:OnAbilityPhaseStart()
    	self.caster=self:GetCaster()
	self.caster_pos = self.caster:GetAbsOrigin()
	self.caster:EmitSound("Ability.PowershotPull")
	self.caster:AddActivityModifier("stinger")
	self.caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,3)
	self.particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "bow_mid",self.caster_pos, false)
	ParticleManager:SetParticleControlEnt(self.particle, 1, self.caster, PATTACH_POINT_FOLLOW, "bow_mid", self.caster_pos, false)
    return true
end

function powershot:OnAbilityPhaseInterrupted()
    if self.particle then
        ParticleManager:DestroyParticle(self.particle, true)
        ParticleManager:ReleaseParticleIndex(self.particle)
        self.particle=nil
    end
	return true
end


function powershot:OnSpellStart()
	local curpos = self:GetCursorPosition()
	local dir=curpos==self.caster_pos and self.caster:GetForwardVector() or TG_Direction(curpos,self.caster_pos)
	local sp=self:GetSpecialValueFor( "sp1" )
	local rg=self.caster:Has_Aghanims_Shard() and 25000 or self:GetSpecialValueFor( "rg" )
	local wh=self:GetSpecialValueFor( "wh" )
	local vrd=self:GetSpecialValueFor( "vrd" )
	local dir1=TG_Direction(RotatePosition(self.caster_pos, QAngle(0, 5, 0), self.caster_pos + dir * rg),curpos)
	local dir2=TG_Direction(RotatePosition(self.caster_pos, QAngle(0, -5, 0), self.caster_pos + dir * rg),curpos)
	local dirtb={}
	table.insert (dirtb, dir)
	if  self.caster:TG_HasTalent("special_bonus_windrunner_1") then
		table.insert (dirtb, dir1)
		table.insert (dirtb, dir2)
	end
	self.damageTable = {
		attacker = self.caster,
		damage_type =DAMAGE_TYPE_MAGICAL,
		ability = self,
		}
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle=nil
	end
		EmitSoundOn( "Ability.Powershot", self.caster )
		for a=1,#dirtb do
			local pp =
			{
				EffectName ="particles/econ/items/windrunner/windranger_arcana/windranger_arcana_spell_powershot.vpcf",
				Ability = self,
				vSpawnOrigin =self.caster:GetAbsOrigin(),
				vVelocity =dirtb[a]*sp,
				fDistance =rg,
				fStartRadius = wh,
				fEndRadius = wh,
				Source = self.caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
				bProvidesVision = true,
				iVisionRadius = vrd,
				iVisionTeamNumber = self.caster:GetTeamNumber()
			}
			ProjectileManager:CreateLinearProjectile( pp )
		end
end


function powershot:OnProjectileHit_ExtraData(target, location, kv)
		if target==nil then
			return
		end
		local sleep=self:GetSpecialValueFor( "sleep" )
		local dam=self:GetSpecialValueFor( "dam" )
		if not target:IsMagicImmune()  then
			if not Is_Chinese_TG(target,self.caster) then
					if self.caster:Has_Aghanims_Shard() and target:GetHealth() < target:GetMaxHealth()*20*0.01 and target:IsRealHero() then
						TG_Kill(self.caster,target,self)
					elseif TG_Distance(target:GetAbsOrigin(),self.caster:GetAbsOrigin())<3000 then
						self.damageTable.victim = target
						self.damageTable.damage = dam
						ApplyDamage(self.damageTable)
						target:AddNewModifier_RS(self.caster, self, "modifier_powershot_debuff", {duration=sleep})
					end
			end
			--------------------------------------------------------------------------------------------------------
			--------------------------------------------------------------------------------------------------------
			if Is_Chinese_TG(target,self.caster) and self.caster:TG_HasTalent("special_bonus_windrunner_2") then
				target:Heal(dam, self)
				SendOverheadEventMessage(target, OVERHEAD_ALERT_HEAL, target,dam, nil)
			end
		end
end


function powershot:OnProjectileThink_ExtraData(vLocation, table)
	GridNav:DestroyTreesAroundPoint(vLocation,300,false)
end


modifier_powershot_debuff= class({})

function modifier_powershot_debuff:IsDebuff()
	return true
end

function modifier_powershot_debuff:IsHidden()
	return false
end

function modifier_powershot_debuff:IsPurgable()
	return true
end

function modifier_powershot_debuff:IsPurgeException()
	return true
end


function modifier_powershot_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_powershot_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function modifier_powershot_debuff:OnCreated()
	if  IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_DISABLED)
end
end

function modifier_powershot_debuff:OnDestroy()
	if  IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_DISABLED)
end
end

function modifier_powershot_debuff:OnTakeDamage(tg)
	if  IsServer() then
		if tg.unit==self:GetParent() and tg.unit:HasModifier("modifier_powershot_debuff") then
			self:Destroy()
	end
end
end

function modifier_powershot_debuff:DeclareFunctions()
	 return
	 {MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_powershot_debuff:CheckState()
	 return
	  {
			[MODIFIER_STATE_DISARMED] = true,
		    [MODIFIER_STATE_NIGHTMARED] = true,
		    [MODIFIER_STATE_SILENCED] = true,
		    [MODIFIER_STATE_STUNNED] = true,
		    [MODIFIER_STATE_INVISIBLE] = false,
		}
end